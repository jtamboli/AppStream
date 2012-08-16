//
//  CAppService.h
//  App
//
//  Created by Jonathan Wight on 8/12/12.
//  Copyright (c) 2012 toxicsoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CStream;
@class CUser;
@class CPost;

@interface CAppService : NSObject

@property (readwrite, nonatomic, strong) NSString *client_id;
@property (readwrite, nonatomic, strong) NSString *access_token;

@property (readonly, nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (readonly, nonatomic, strong) CStream *globalStreamEntity; // TODO These are MOC specific and that's _probably_ bad.
@property (readonly, nonatomic, strong) CStream *myStreamEntity; // TODO These are MOC specific and that's _probably_ bad.
@property (readonly, nonatomic, strong) CStream *myPostsStreamEntity; // TODO These are MOC specific and that's _probably_ bad.
@property (readonly, nonatomic, strong) CStream *mentionsStreamEntity; // TODO These are MOC specific and that's _probably_ bad.
@property (readonly, nonatomic, strong) CUser *me;

+ (CAppService *)sharedInstance;

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender;

- (void)retrieveAllStreams;
- (void)retrievePostsForStream:(CStream *)inStream options:(NSDictionary *)inOptions success:(void (^)(NSArray *))inSuccessHandler;

- (void)introduce:(void (^)(void))inSuccessHandler;

- (void)post:(NSString *)inText success:(void (^)(void))inSuccessHandler;
- (void)post:(NSString *)inText replyTo:(CPost *)inPost success:(void (^)(void))inSuccessHandler;

- (void)deletePost:(CPost *)inPost success:(void (^)(void))inSuccessHandler;

@end
