//
//  NSURL+Extensions.h
//  App
//
//  Created by Jonathan Wight on 8/12/12.
//  Copyright (c) 2012 toxicsoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Extensions)

+ (NSURL *)URLWithBaseURL:(NSURL *)inURL queryDictionary:(NSDictionary *)inDictionary;
+ (NSURL *)URLWithString:(NSString *)inURLString queryDictionary:(NSDictionary *)inDictionary;

@end
