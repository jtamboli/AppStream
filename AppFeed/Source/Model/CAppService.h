//
//  CAppService.h
//  App
//
//  Created by Jonathan Wight on 8/12/12.
//  Copyright (c) 2012 toxicsoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CStream;

@interface CAppService : NSObject

@property (readwrite, nonatomic, strong) NSString *client_id;
@property (readwrite, nonatomic, strong) NSString *access_token;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) CStream *globalStreamEntity; // TODO These are MOC specific and that's _probably_ bad.
@property (readonly, strong, nonatomic) CStream *myStreamEntity; // TODO These are MOC specific and that's _probably_ bad.
@property (readonly, strong, nonatomic) CStream *myPostsStreamEntity; // TODO These are MOC specific and that's _probably_ bad.
@property (readonly, strong, nonatomic) CStream *mentionsStreamEntity; // TODO These are MOC specific and that's _probably_ bad.

+ (CAppService *)sharedInstance;

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender;

- (void)retrievePostsForStream:(CStream *)inStream options:(NSDictionary *)inOptions success:(void (^)(NSArray *))inSuccessHandler;


@end
