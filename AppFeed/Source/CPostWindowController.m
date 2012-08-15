//
//  CPostWindowController.m
//  AppFeed
//
//  Created by Jonathan Wight on 8/14/12.
//  Copyright (c) 2012 toxicsoftware. All rights reserved.
//

#import "CPostWindowController.h"

#import "CAppService.h"

@interface CPostWindowController ()
@property (readwrite, nonatomic, strong) NSString *text;
@end

@implementation CPostWindowController

- (id)init
    {
    if ((self = [super initWithWindowNibName:NSStringFromClass([self class])]) != NULL)
        {
        }
    return self;
    }

- (void)windowDidLoad
    {
    [super windowDidLoad];
    }

- (IBAction)post:(id)sender
    {
    [[CAppService sharedInstance] post:self.text success:^{
        [self.window orderOut:NULL];
        }];
    }

- (IBAction)cancel:(id)sender
    {
    [self.window orderOut:NULL];
    }

@end
