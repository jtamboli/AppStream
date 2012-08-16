//
//  CPost.h
//  //  AppStream
//
//  Created by Jonathan Wight on 8/14/12.
//  Copyright (c) 2012 toxicsoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CStream, CUser;

@interface CPost : NSManagedObject

@property (nonatomic, retain) id blob;
@property (nonatomic, retain) NSString * externalIdentifier;
@property (nonatomic, retain) NSDate *posted;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSSet *streams;
@property (nonatomic, retain) CUser *user;
@property (nonatomic, retain) NSAttributedString *attributedText;
@property (nonatomic, assign) BOOL notified;
@end

@interface CPost (CoreDataGeneratedAccessors)

- (void)addStreamsObject:(CStream *)value;
- (void)removeStreamsObject:(CStream *)value;
- (void)addStreams:(NSSet *)values;
- (void)removeStreams:(NSSet *)values;

@end
