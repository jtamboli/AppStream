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

#import "CFormEncodingSerialization.h"
#import "NSDate_InternetDateExtensions.h"
#import "CCoreDataManager.h"

// See: https://github.com/appdotnet/api-spec

static CAppService *gSharedInstance = NULL;

@interface CAppService ()
@property (readwrite, nonatomic, strong) CCoreDataManager *coreDataManager;
@end

#pragma mark -

@implementation CAppService

@synthesize coreDataManager = _coreDataManager;
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

- (CCoreDataManager *)coreDataManager
    {
    if (_coreDataManager == NULL)
        {
        _coreDataManager = [[CCoreDataManager alloc] initWithApplicationDefaults];
        }
    return(_coreDataManager);
    }

- (NSManagedObjectContext *)managedObjectContext
    {
    return(self.coreDataManager.managedObjectContext);
    }

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Save changes in the application's managed object context before the application terminates.
    
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

- (CStream *)mentionsStreamEntity
    {
    return([self streamForPath:@"users/me/mentions"]);
    }

- (CStream *)myPostsStreamEntity
    {
    return([self streamForPath:@"users/me/posts"]);
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
            CUser *theUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
            theUser.externalIdentifier = inJSON[@"id"];
            theUser.name = inJSON[@"name"] != [NSNull null] ? inJSON[@"name"] : NULL;
            theUser.username = inJSON[@"username"] != [NSNull null] ? inJSON[@"username"] : NULL;
            theUser.blob = inJSON;
            return(theUser);
            };

        theObjects = [theArrayMergerHelper merge:&theError];
//        NSLog(@"Inserted: %ld", theObjects.count);
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
            CPost *thePost = [NSEntityDescription insertNewObjectForEntityForName:@"Post" inManagedObjectContext:self.managedObjectContext];
            thePost.externalIdentifier = inJSON[@"id"];
            thePost.text = inJSON[@"text"] != [NSNull null] ? inJSON[@"text"] : NULL;
            thePost.posted = [NSDate dateWithISO8601String:inJSON[@"created_at"]];
            thePost.blob = inJSON;

            NSString *theUserID = [inJSON valueForKeyPath:@"user.id"];
            CPost *theUser = [theUsersByID objectForKey:theUserID];

            [thePost setValue:theUser forKey:@"user"];

            return(thePost);
            };

        theObjects = [theArrayMergerHelper merge:&theError];
//        NSLog(@"Inserted: %ld", theObjects.count);
        }];

    return(theObjects);
    }

#pragma mark -

- (void)post:(NSString *)inText success:(void (^)(void))inSuccessHandler
    {
    NSDictionary *theDictionary = @{
        @"text": inText,
        };

    NSError *theError = NULL;

    NSData *theData = [CFormEncodingSerialization dataWithDictionary:theDictionary error:&theError];

    NSURL *theURL = [NSURL URLWithString:@"https://alpha-api.app.net/stream/0/posts"];

    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL];
    [theRequest setHTTPMethod:@"POST"];

    NSString *theAuthorizationValue = [NSString stringWithFormat:@"Bearer %@", self.access_token];
    [theRequest setValue:theAuthorizationValue forHTTPHeaderField:@"Authorization"];

    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPBody:theData];

    [NSURLConnection sendAsynchronousRequest:theRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSLog(@"%ld", ((NSHTTPURLResponse *)response).statusCode);
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        NSLog(@"%@", error);

        if (((NSHTTPURLResponse *)response).statusCode == 200)
            {
            NSError *theError = NULL;
            NSDictionary *thePostJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&theError];
            NSArray *thePosts = [self updatePosts:[NSSet setWithObject:thePostJSON]];
            CPost *thePost = [thePosts lastObject];

            [self.managedObjectContext performBlockAndWait:^{
                [thePost addStreamsObject:self.myPostsStreamEntity];
                [thePost addStreamsObject:self.globalStreamEntity];
                [thePost addStreamsObject:self.myStreamEntity];

                }];

            if (inSuccessHandler)
                {
                inSuccessHandler();
                }
            }


        }];
    }

@end
