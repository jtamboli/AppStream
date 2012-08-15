//
//  NSAttributedString+PostExtensins.h
//  AppFeed
//
//  Created by Jonathan Wight on 8/14/12.
//  Copyright (c) 2012 toxicsoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CPost;

@interface NSAttributedString (PostExtensins)

+ (NSAttributedString *)attributedStringWithPost:(CPost *)inPost;

@end
