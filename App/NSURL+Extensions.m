//
//  NSURL+Extensions.m
//  App
//
//  Created by Jonathan Wight on 8/12/12.
//  Copyright (c) 2012 toxicsoftware. All rights reserved.
//

#import "NSURL+Extensions.h"

@implementation NSURL (Extensions)

+ (NSURL *)URLWithBaseURL:(NSURL *)inURL queryDictionary:(NSDictionary *)inQueryDictionary
    {
    if (inQueryDictionary.count > 0)
        {
        NSMutableArray *theQueryComponents = [NSMutableArray array];
        [inQueryDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {

            NSString *theEncodedKey = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)key, CFSTR(""), CFSTR("=&"), kCFStringEncodingUTF8);
            NSString *theEncodedValue = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)value, CFSTR(""), CFSTR("=&"), kCFStringEncodingUTF8);

            NSString *theComponent = [NSString stringWithFormat:@"%@=%@", theEncodedKey, theEncodedValue];
            [theQueryComponents addObject:theComponent];
            }];

        NSString *theURLString = [inURL absoluteString];
        theURLString = [NSString stringWithFormat:@"%@?%@", theURLString, [theQueryComponents componentsJoinedByString:@"&"]];

        inURL = [NSURL URLWithString:theURLString];
        }

    return(inURL);
    }

+ (NSURL *)URLWithString:(NSString *)inURLString queryDictionary:(NSDictionary *)inDictionary;
    {
    NSURL *theBaseURL = [NSURL URLWithString:inURLString];
    return([self URLWithBaseURL:theBaseURL queryDictionary:inDictionary]);
    }

@end
