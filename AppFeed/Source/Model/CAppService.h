//
//  CAppService.h
//  App
//
//  Created by Jonathan Wight on 8/12/12.
//  Copyright (c) 2012 toxicsoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAppService : NSObject

@property (readwrite, nonatomic, strong) NSString *client_id;
@property (readwrite, nonatomic, strong) NSString *access_token;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSWindowController *mainWindowController;
@property (readonly, strong, nonatomic) NSManagedObject *globalStreamEntity;
@property (readonly, strong, nonatomic) NSManagedObject *myStreamEntity;
@property (readonly, strong, nonatomic) NSManagedObject *myPostsStreamEntity;
@property (readonly, strong, nonatomic) NSManagedObject *mentionsStreamEntity;

+ (CAppService *)sharedInstance;

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender;

- (void)retrieveGlobalStream:(NSDictionary *)inOptions success:(void (^)(NSArray *))inSuccessHandler;


@end
