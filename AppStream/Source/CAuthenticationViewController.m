//
//  CAuthenticationViewController.m
//  App
//
//  Created by Jonathan Wight on 8/12/12.
//  Copyright (c) 2012 toxicsoftware. All rights reserved.
//

#import "CAuthenticationViewController.h"

#import <WebKit/WebKit.h>

#import "NSURL+Extensions.h"
#import "CAppService.h"

@interface CAuthenticationViewController ()
@property (readwrite, nonatomic, assign) IBOutlet WebView *webView;
@property (readwrite, nonatomic, assign) BOOL ignoreErrors;
@property (readwrite, nonatomic, copy) void (^completionBlock)(void);
@end

@implementation CAuthenticationViewController

- (id)initWithCompletionBlock:(void (^)(void))inCompletionBlock;
    {
    if ((self = [super initWithNibName:NSStringFromClass([self class]) bundle:NULL]) != NULL)
        {
        _completionBlock = inCompletionBlock;
        }
    return self;
    }

- (void)loadView;
    {
    [super loadView];
    //
    self.webView.resourceLoadDelegate = self;

    NSURL *theRedirectURL = [NSURL URLWithString:@"x-com-toxicsoftware-appstream:///"];
    NSArray *theScopes = @[@"stream", @"email", @"write_post", @"follow", @"messages", @"export"];

    NSDictionary *theQueryDictionary = @{
        @"client_id": [CAppService sharedInstance].client_id,
        @"redirect_uri": [theRedirectURL absoluteString],
        @"response_type": @"token",
        @"scope": [theScopes componentsJoinedByString:@" "]
        };

    NSURL *theURL = [NSURL URLWithString:@"https://alpha.app.net/oauth/authenticate" queryDictionary:theQueryDictionary];
    NSURLRequest *theRequest = [[NSURLRequest alloc] initWithURL:theURL];

    [self.webView.mainFrame loadRequest:theRequest];
    }

#pragma mark -

- (NSURLRequest *)webView:(WebView *)sender resource:(id)identifier willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse fromDataSource:(WebDataSource *)dataSource
    {
    if ([request.URL.scheme isEqualToString:@"x-com-toxicsoftware-appstream"])
        {
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^ *access_token *= *(.+) *$" options:0 error:&error];
        NSString *result = [regex stringByReplacingMatchesInString:request.URL.fragment options:0 range:NSMakeRange(0, [request.URL.fragment length]) withTemplate:@"$1"];
        if (result.length > 0)
            {
            [CAppService sharedInstance].access_token = result;

            self.ignoreErrors = YES;

            self.completionBlock();

//            self.view.alphaValue = 0.0;

            return(NULL);
            }
        }

//    NSMutableURLRequest *theRequest = [request mutableCopy];
//    theRequest.HTTPShouldHandleCookies = NO;
//    return(theRequest);

    return(request);
    }

- (void)webView:(WebView *)sender resource:(id)identifier didReceiveResponse:(NSURLResponse *)response fromDataSource:(WebDataSource *)dataSource;
    {
//    NSDictionary *allHeaders = [(NSHTTPURLResponse *)response allHeaderFields];
//    NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:allHeaders forURL:[response URL]];
//    for (NSHTTPCookie *aCookie in cookies)
//        {
//        [self.cookies addObject:aCookie];
//        }
    }

- (void)webView:(WebView *)sender resource:(id)identifier didFailLoadingWithError:(NSError *)error fromDataSource:(WebDataSource *)dataSource
    {
    if (self.ignoreErrors == NO)
        {
        NSLog(@"%@", error);
        }
    }

@end
