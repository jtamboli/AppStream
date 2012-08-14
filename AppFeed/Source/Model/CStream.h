//
//  CStream.h
//  AppFeed
//
//  Created by Jonathan Wight on 8/14/12.
//  Copyright (c) 2012 toxicsoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CPost;

@interface CStream : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSSet *posts;
@end

@interface CStream (CoreDataGeneratedAccessors)

- (void)addPostsObject:(CPost *)value;
- (void)removePostsObject:(CPost *)value;
- (void)addPosts:(NSSet *)values;
- (void)removePosts:(NSSet *)values;

@end
