//
//  CAppService.m
//  App
//
//  Created by Jonathan Wight on 8/12/12.
//  Copyright (c) 2012 toxicsoftware. All rights reserved.
//

#import "CAppService.h"

#import "CArrayMergeHelper.h"
#import "CStream.h"
#import "CPost.h"
#import "CUser.h"

// See: https://github.com/appdotnet/api-spec

static CAppService *gSharedInstance = NULL;

@interface CAppService ()
@end

#pragma mark -

@implementation CAppService

@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize globalStreamEntity = _globalStreamEntity;

+ (CAppService *)sharedInstance
    {
    static dispatch_once_t sOnceToken = 0;
    dispatch_once(&sOnceToken, ^{
        gSharedInstance = [[CAppService alloc] init];
        });
    return(gSharedInstance);
    }

- (id)init
    {
    if ((self = [super init]) != NULL)
        {
        _client_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"client_id"];
        if (_client_id.length == 0)
            {
            NSString *theInstructions = [NSString stringWithFormat:@"Use \'defaults write %@ client_id <your_client_id>\' from the terminal.", [NSBundle mainBundle].bundleIdentifier];
            NSLog(@"%@", theInstructions);

            NSAlert *theAlert = [[NSAlert alloc] init];
            [theAlert setMessageText:@"Coult not find client_id in defaults"];
            [theAlert setInformativeText:theInstructions];
            [theAlert addButtonWithTitle:@"Quit"];
            [theAlert runModal];

            exit(-1);
            }
        }
    return self;
    }

#pragma mark -

- (NSURL *)applicationFilesDirectory
    {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:[NSBundle mainBundle].bundleIdentifier];
    }

// Creates if necessary and returns the managed object model for the application.
- (NSManagedObjectModel *)managedObjectModel
    {
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"App" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
    }

// Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    
    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    
    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    } else {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
            
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"AppFeed.sqlite"];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];

    NSDictionary *theOptions = @{
        NSMigratePersistentStoresAutomaticallyOption : @(YES),
        NSInferMappingModelAutomaticallyOption : @(YES),
        };

    if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:theOptions error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _persistentStoreCoordinator = coordinator;
    
    return _persistentStoreCoordinator;
}

// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) 
- (NSManagedObjectContext *)managedObjectContext
    {
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];

    return _managedObjectContext;
    }

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Save changes in the application's managed object context before the application terminates.
    
    if (!_managedObjectContext) {
        return NSTerminateNow;
    }
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    NSLog(@"Saving…");
    if (![[self managedObjectContext] save:&error]) {

        // Customize this code block to include application-specific recovery steps.              
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}

#pragma mark -

- (CStream *)streamForPath:(NSString *)inPath
    {
    __block CStream *theStream = NULL;

    [self.managedObjectContext performBlockAndWait:^{

        NSFetchRequest *theFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Stream"];
        theFetchRequest.predicate = [NSPredicate predicateWithFormat:@"path == %@", inPath];

        NSError *theError = NULL;
        NSArray *theResults = [self.managedObjectContext executeFetchRequest:theFetchRequest error:&theError];

        if (theResults.count == 0)
            {
            theStream = [NSEntityDescription insertNewObjectForEntityForName:@"Stream" inManagedObjectContext:self.managedObjectContext];
            theStream.path = inPath;
            }
        else
            {
            theStream = [theResults lastObject];
            }
        }];

    return(theStream);
    }

- (CStream *)globalStreamEntity
    {
    if (_globalStreamEntity == NULL);
        {
        _globalStreamEntity = [self streamForPath:@"posts/stream/global"];
        }
    return(_globalStreamEntity);
    }

- (CStream *)myStreamEntity
    {
    return([self streamForPath:@"posts/stream"]);
    }

#pragma mark -

// https://alpha-api.app.net/stream/0/posts/stream

- (void)retrievePostsForStream:(CStream *)inStream options:(NSDictionary *)inOptions success:(void (^)(NSArray *))inSuccessHandler;
    {
    NSURL *theURL = [NSURL URLWithString:@"https://alpha-api.app.net/stream/0"];

    theURL = [theURL URLByAppendingPathComponent:inStream.path];

    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL];

    NSString *theAuthorizationValue = [NSString stringWithFormat:@"Bearer %@", self.access_token];

    [theRequest setValue:theAuthorizationValue forHTTPHeaderField:@"Authorization"];

    [NSURLConnection sendAsynchronousRequest:theRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        NSLog(@"%ld", ((NSHTTPURLResponse *)response).statusCode);
//        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//        NSLog(@"%@", error);

        // TODO response validation

        NSError *theError = NULL;
        NSArray *thePosts = [NSJSONSerialization JSONObjectWithData:data options:0 error:&theError];


        thePosts = [self updatePosts:[NSSet setWithArray:thePosts]];

        [self.managedObjectContext performBlockAndWait:^{
            for (CPost *thePost in thePosts)
                {
                [thePost addStreamsObject:inStream];

//                [thePost setValue:self.globalStreamEntity forKey:@"stream"];
                }

            }];

        if (inSuccessHandler)
            {
            inSuccessHandler(NULL);
            }
        }];
    }

- (NSArray *)updateUsers:(NSSet *)inUsers
    {
    __block NSArray *theObjects = NULL;

    [self.managedObjectContext performBlockAndWait:^{

        NSArray *theUsers = [inUsers allObjects];

        theUsers = [theUsers sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return([obj1[@"id"] compare:obj2[@"id"]]);
            }];

        NSArray *theIdentifiers = [theUsers valueForKey:@"id"];

        NSFetchRequest *theFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
        theFetchRequest.predicate = [NSPredicate predicateWithFormat:@"externalIdentifier IN %@", theIdentifiers];
        theFetchRequest.sortDescriptors = @[ [[NSSortDescriptor alloc] initWithKey:@"externalIdentifier" ascending:YES] ];

        NSError *theError = NULL;
        NSArray *theResults = [self.managedObjectContext executeFetchRequest:theFetchRequest error:&theError];

        CArrayMergeHelper *theArrayMergerHelper = [[CArrayMergeHelper alloc] init];
        theArrayMergerHelper.leftArray = theResults;
        theArrayMergerHelper.leftKey = @"externalIdentifier";
        theArrayMergerHelper.rightArray = theUsers;
        theArrayMergerHelper.rightKey = @"id";
        theArrayMergerHelper.insertHandler = ^(id inJSON) {
//            NSLog(@"INSERT: %@", thePost[@"text"]);
            CUser *theUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
            [theUser setValue:inJSON[@"id"] forKey:@"externalIdentifier"];
            [theUser setValue:inJSON[@"name"] != [NSNull null] ? inJSON[@"name"] : NULL forKey:@"name"];
            [theUser setValue:inJSON[@"username"] != [NSNull null] ? inJSON[@"name"] : NULL forKey:@"username"];
            [theUser setValue:inJSON forKey:@"blob"];
            return(theUser);
            };

        theObjects = [theArrayMergerHelper merge:&theError];
        NSLog(@"Inserted: %ld", theObjects.count);
        }];

    return(theObjects);
    }


- (NSArray *)updatePosts:(NSSet *)inPosts
    {
    __block NSArray *theObjects = NULL;

    [self.managedObjectContext performBlockAndWait:^{

        NSArray *thePosts = [inPosts allObjects];
        thePosts = [thePosts sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return([obj1[@"id"] compare:obj2[@"id"]]);
            }];

        NSArray *theUsers = [self updateUsers:[NSSet setWithArray:[thePosts valueForKey:@"user"]]];
        NSDictionary *theUsersByID = [NSDictionary dictionaryWithObjects:theUsers forKeys:[theUsers valueForKey:@"externalIdentifier"]];

        NSArray *theIdentifiers = [thePosts valueForKey:@"id"];

        NSFetchRequest *theFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Post"];
        theFetchRequest.predicate = [NSPredicate predicateWithFormat:@"externalIdentifier IN %@", theIdentifiers];
        theFetchRequest.sortDescriptors = @[ [[NSSortDescriptor alloc] initWithKey:@"externalIdentifier" ascending:YES] ];

        NSError *theError = NULL;
        NSArray *theResults = [self.managedObjectContext executeFetchRequest:theFetchRequest error:&theError];

        CArrayMergeHelper *theArrayMergerHelper = [[CArrayMergeHelper alloc] init];
        theArrayMergerHelper.leftArray = theResults;
        theArrayMergerHelper.leftKey = @"externalIdentifier";
        theArrayMergerHelper.rightArray = thePosts;
        theArrayMergerHelper.rightKey = @"id";
        theArrayMergerHelper.insertHandler = ^(id inJSON) {
//            NSLog(@"INSERT: %@", thePost[@"text"]);
            CPost *thePost = [NSEntityDescription insertNewObjectForEntityForName:@"Post" inManagedObjectContext:self.managedObjectContext];
            [thePost setValue:inJSON[@"id"] forKey:@"externalIdentifier"];
            [thePost setValue:inJSON[@"text"] != [NSNull null] ? inJSON[@"text"] : NULL forKey:@"text"];
            [thePost setValue:[NSDate date] forKey:@"posted"]; // TODO
            [thePost setValue:inJSON forKey:@"blob"];

            NSString *theUserID = [inJSON valueForKeyPath:@"user.id"];
            CPost *theUser = [theUsersByID objectForKey:theUserID];

            [thePost setValue:theUser forKey:@"user"];

            return(thePost);
            };

        theObjects = [theArrayMergerHelper merge:&theError];
        NSLog(@"Inserted: %ld", theObjects.count);
        }];

    return(theObjects);
    }

@end
