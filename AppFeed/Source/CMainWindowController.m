//
//  CMainWindowController.m
//  App
//
//  Created by Jonathan Wight on 8/12/12.
//  Copyright (c) 2012 toxicsoftware. All rights reserved.
//

#import "CMainWindowController.h"

#import "CAuthenticationViewController.h"
#import "CAppService.h"
#import "CMainViewController.h"
#import "CTimelineViewController.h"
#import "CContainerView.h"
#import "CStream.h"

@interface CMainWindowController ()
@property (readwrite, nonatomic, assign) IBOutlet CContainerView *containerView;
@property (readwrite, nonatomic, strong) NSViewController *viewController;
@end

@implementation CMainWindowController

- (id)init
    {
    if ((self = [super initWithWindowNibName:@"MainWindow"]) != NULL)
        {
        }
    return self;
    }

- (void)windowDidLoad
    {
    [super windowDidLoad];
    //
    self.viewController = [[CAuthenticationViewController alloc] initWithCompletionBlock:^{
        [self authorized];
        }];
    }

- (void)setViewController:(NSViewController *)viewController
    {
    _viewController = viewController;
    self.containerView.viewController = viewController;
    }

- (void)authorized
    {
    [self.viewController.view removeFromSuperview];
    self.viewController = NULL;

//    self.viewController = [[CTimelineViewController alloc] initWithStream:[CAppService sharedInstance].globalStreamEntity];
    self.viewController = [[CMainViewController alloc] init];
    }

@end
