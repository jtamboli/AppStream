//
//  CTimelineTableCellView.m
//  AppFeed
//
//  Created by Jonathan Wight on 8/14/12.
//  Copyright (c) 2012 toxicsoftware. All rights reserved.
//

#import "CTimelineTableCellView.h"

#import "CAsyncImageView.h"

#import "CPost.h"

@interface CTimelineTableCellView ()
@property (readwrite, nonatomic, assign) IBOutlet CAsyncImageView *avatarImageView;
@end

@implementation CTimelineTableCellView

- (void)setObjectValue:(id)objectValue
    {
    [super setObjectValue:objectValue];

    NSDictionary *thePostJSON = ((CPost *)objectValue).blob;

    NSString *theURLString = [thePostJSON valueForKeyPath:@"user.avatar_image.url"];
    if (theURLString.length > 0)
        {
        NSURL *theURL = [NSURL URLWithString:theURLString];
        NSURLRequest *theRequest = [NSURLRequest requestWithURL:theURL];

        [self.avatarImageView loadRequest:theRequest];
        }
    }

- (void)reset
    {
    self.avatarImageView.image = NULL;
    }

@end
