//
//  NSAttributedString+PostExtensins.m
//  AppFeed
//
//  Created by Jonathan Wight on 8/14/12.
//  Copyright (c) 2012 toxicsoftware. All rights reserved.
//

#import "NSAttributedString+PostExtensins.h"

#import "CPost.h"

@implementation NSAttributedString (PostExtensins)

+ (NSAttributedString *)attributedStringWithPost:(CPost *)inPost
    {
    if (inPost.text == NULL)
        {
        return(NULL);
        }
    NSMutableAttributedString *theString = [[NSMutableAttributedString alloc] initWithString:inPost.text];

    NSArray *theEntities = [inPost.blob valueForKeyPath:@"entities.mentions"];
    for (NSDictionary *theEntity in theEntities)
        {
        NSRange theRange = {
            .location = [theEntity[@"pos"] integerValue],
            .length = [theEntity[@"len"] integerValue],
            };

        NSDictionary *theAttributes = @{
            NSForegroundColorAttributeName: [NSColor blueColor]
            };

        [theString setAttributes:theAttributes range:theRange];
        }

    theEntities = [inPost.blob valueForKeyPath:@"entities.hashtags"];
    for (NSDictionary *theEntity in theEntities)
        {
        NSRange theRange = {
            .location = [theEntity[@"pos"] integerValue],
            .length = [theEntity[@"len"] integerValue],
            };

        NSDictionary *theAttributes = @{
            NSForegroundColorAttributeName: [NSColor blueColor]
            };

        [theString setAttributes:theAttributes range:theRange];
        }

    theEntities = [inPost.blob valueForKeyPath:@"entities.links"];
    for (NSDictionary *theEntity in theEntities)
        {
        NSRange theRange = {
            .location = [theEntity[@"pos"] integerValue],
            .length = [theEntity[@"len"] integerValue],
            };

        NSDictionary *theAttributes = @{
            NSForegroundColorAttributeName: [NSColor blueColor],
            NSLinkAttributeName: [NSURL URLWithString:@"apple.com"],
            };

        [theString setAttributes:theAttributes range:theRange];
        }


    return(theString);
    }

@end
