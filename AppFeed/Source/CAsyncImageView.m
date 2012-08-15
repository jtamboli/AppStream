//
//  CAsyncImageView.m
//  AppFeed
//
//  Created by Jonathan Wight on 8/14/12.
//  Copyright (c) 2012 toxicsoftware. All rights reserved.
//

#import "CAsyncImageView.h"

@interface CAsyncImageView ()
@end

@implementation CAsyncImageView

// TODO: this is a really crude way of load images from web asynchronously.

- (void)loadRequest:(NSURLRequest *)inRequest;
    {
    [NSURLConnection sendAsynchronousRequest:inRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSImage *theImage = [[NSImage alloc] initWithData:data];
        self.image = theImage;
        }];
    }

@end
