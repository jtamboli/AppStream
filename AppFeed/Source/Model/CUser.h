//
//  CUser.h
//  AppFeed
//
//  Created by Jonathan Wight on 8/14/12.
//  Copyright (c) 2012 toxicsoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CPost;

@interface CUser : NSManagedObject

@property (nonatomic, retain) id blob;
@property (nonatomic, retain) NSString * externalIdentifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *posts;
@end

@interface CUser (CoreDataGeneratedAccessors)

- (void)addPostsObject:(CPost *)value;
- (void)removePostsObject:(CPost *)value;
- (void)addPosts:(NSSet *)values;
- (void)removePosts:(NSSet *)values;

@end
