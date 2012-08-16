//
//  CPostWindowController.m
//  //  AppStream
//
//  Created by Jonathan Wight on 8/14/12.
//  Copyright (c) 2012 toxicsoftware. All rights reserved.
//

#import "CPostWindowController.h"

#import "CAppService.h"
#import "CPost.h"
#import "CUser.h"

@interface CPostWindowController ()
@property (readwrite, nonatomic, strong) CPost *subjectPost;
@property (readwrite, nonatomic, strong) NSString *text;
@end

@implementation CPostWindowController

- (id)init
    {
    if ((self = [super initWithWindowNibName:NSStringFromClass([self class])]) != NULL)
        {
        }
    return self;
    }

- (id)initWithSubjectPost:(CPost *)inSubjectPost;
    {
    if ((self = [self init]) != NULL)
        {
        _subjectPost = inSubjectPost;

        _text = [NSString stringWithFormat:@"@%@ ", inSubjectPost.user.username];
        }
    return self;
    }

- (void)windowDidLoad
    {
    [super windowDidLoad];
    }

- (IBAction)post:(id)sender
    {
    [[CAppService sharedInstance] post:self.text replyTo:self.subjectPost success:^{
        [self.window orderOut:NULL];
        }];
    }

- (IBAction)cancel:(id)sender
    {
    [self.window orderOut:NULL];
    }

@end
