//
//  CAsyncImageView.m
//  //  AppStream
//
//  Created by Jonathan Wight on 8/14/12.
//  Copyright (c) 2012 toxicsoftware. All rights reserved.
//

#import "CAsyncImageView.h"

@interface CAsyncImageView ()
@property (readwrite, nonatomic, strong) NSURLRequest *request;
@end

@implementation CAsyncImageView

// TODO: this is a really crude way of loading images from web asynchronously.

- (void)loadRequest:(NSURLRequest *)inRequest;
    {
    self.request = inRequest;

    [NSURLConnection sendAsynchronousRequest:inRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (self.request == inRequest)
            {
            NSImage *theImage = [[NSImage alloc] initWithData:data];
            self.image = theImage;
            }
        }];
    }

@end
