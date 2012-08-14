//
//  CAppDelegate.m
//  App
//
//  Created by Jonathan Wight on 8/12/12.
//  Copyright (c) 2012 toxicsoftware. All rights reserved.
//

#import "CAppDelegate.h"

#import "CMainWindowController.h"
#import "CAppService.h"

@interface CAppDelegate ()
@property (readwrite, strong, nonatomic) NSWindowController *mainWindowController;
@end

@implementation CAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
    {
    self.mainWindowController = [[CMainWindowController alloc] init];
    [self.mainWindowController.window orderFront:NULL];

//    NSUserNotification *theNotification = [[NSUserNotification alloc] init];
//    theNotification.title = @"Hello world (2)";
//    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:theNotification];
    }

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
    {
    return([[CAppService sharedInstance] applicationShouldTerminate:sender]);
    }

//// Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
//- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
//    {
//    return [[self managedObjectContext] undoManager];
//    }
//
//// Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
//- (IBAction)saveAction:(id)sender
//    {
//    NSError *error = nil;
//    
//    if (![[self managedObjectContext] commitEditing]) {
//        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
//    }
//    
//    if (![[self managedObjectContext] save:&error]) {
//        [[NSApplication sharedApplication] presentError:error];
//    }
//    }
//

@end
