//
//  CAppDelegate.h
//  App
//
//  Created by Jonathan Wight on 8/12/12.
//  Copyright (c) 2012 toxicsoftware. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CMainWindowController;
@class CPostWindowController;

@interface CAppDelegate : NSObject <NSApplicationDelegate>

@property (readwrite, nonatomic, strong) CMainWindowController *mainWindowController;
@property (readwrite, nonatomic, strong) CPostWindowController *postWindowController;

+ (CAppDelegate *)sharedInstance;

@end
