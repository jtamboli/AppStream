//
//  NSManagedObjectContext+ObjectControllers.h
//  AppStream
//
//  Created by Jonathan Wight on 8/16/12.
//  Copyright (c) 2012 toxicsoftware. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (ObjectControllers)

- (void)registerObjectController:(NSObjectController *)inObjectController;
- (void)unregisterObjectController:(NSObjectController *)inObjectController;

- (void)refetchObjectControllers;

@end
