//
//  CAsyncImageView.h
//  AppFeed
//
//  Created by Jonathan Wight on 8/14/12.
//  Copyright (c) 2012 toxicsoftware. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CAsyncImageView : NSImageView

- (void)loadRequest:(NSURLRequest *)inRequest;

@end
