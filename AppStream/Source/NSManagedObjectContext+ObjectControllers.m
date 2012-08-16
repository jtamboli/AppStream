//
//  NSManagedObjectContext+ObjectControllers.m
//  AppStream
//
//  Created by Jonathan Wight on 8/16/12.
//  Copyright (c) 2012 toxicsoftware. All rights reserved.
//

#import "NSManagedObjectContext+ObjectControllers.h"

#import <objc/runtime.h>

@implementation NSManagedObjectContext (ObjectControllers)

static void *kKey;

- (void)registerObjectController:(NSObjectController *)inObjectController
    {
    NSMutableSet *theObjectControllers = objc_getAssociatedObject(self, &kKey);
    if (theObjectControllers == NULL)
        {
        theObjectControllers = [NSMutableSet set];
        objc_setAssociatedObject(self, &kKey, theObjectControllers, OBJC_ASSOCIATION_RETAIN);
        }

    [theObjectControllers addObject:inObjectController];
    }

- (void)unregisterObjectController:(NSObjectController *)inObjectController
    {
    NSMutableSet *theObjectControllers = objc_getAssociatedObject(self, &kKey);
    NSParameterAssert(theObjectControllers != NULL);
    [theObjectControllers removeObject:inObjectController];
    }

- (void)refetchObjectControllers
    {
    NSMutableSet *theObjectControllers = objc_getAssociatedObject(self, &kKey);
    for (NSObjectController *theObjectController in theObjectControllers)
        {
        [theObjectController fetchWithRequest:NULL merge:NO error:NULL]; // TODO check errors!
        }
    }


@end
