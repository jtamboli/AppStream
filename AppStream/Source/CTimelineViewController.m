//
//  CTimelineViewController.m
//  App
//
//  Created by Jonathan Wight on 8/12/12.
//  Copyright (c) 2012 toxicsoftware. All rights reserved.
//

#import "CTimelineViewController.h"

#import "CAppService.h"
#import "CStream.h"
#import "CTimelineTableCellView.h"
#import "CAppDelegate.h"
#import "CPostWindowController.h"
#import "CTimelineTableView.h"
#import "CPost.h"
#import "CUser.h"
#import "NSManagedObjectContext+ObjectControllers.h"

@interface CTimelineViewController () <NSTableViewDelegate, CTimelineTableViewDelegate>
@property (readwrite, nonatomic, strong) NSPredicate *filterPredicate;
@property (readwrite, nonatomic, strong) NSArray *sortDescriptors;
@property (readwrite, nonatomic, strong) CPost *selectedPost;
@property (readwrite, nonatomic, assign) IBOutlet NSTableView *tableView;
@property (readwrite, nonatomic, assign) IBOutlet NSArrayController *postsArrayController;
@property (readwrite, nonatomic, assign) IBOutlet NSMenu *postMenu;
@end

@implementation CTimelineViewController

- (id)initWithName:(NSString *)inName predicate:(NSPredicate *)inPredicate;
    {
    if ((self = [super initWithNibName:NSStringFromClass([self class]) bundle:NULL]) != NULL)
        {
        _name = inName;
        _filterPredicate = inPredicate;
        _sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"posted" ascending:NO] ];
        }
    return self;
    }

- (void)loadView
    {
    [super loadView];

    [self.managedObjectContext registerObjectController:self.postsArrayController]; // TODO unregister!
    }

- (NSManagedObjectContext *)managedObjectContext
    {
    return([CAppService sharedInstance].managedObjectContext);
    }

#pragma mark -

- (IBAction)reply:(id)sender
    {
    CPost *thePost = [self.postsArrayController.selectedObjects lastObject];

    CPostWindowController *thePostWindowController = [[CPostWindowController alloc] initWithSubjectPost:thePost];
    [thePostWindowController.window makeKeyAndOrderFront:NULL];
    [CAppDelegate sharedInstance].postWindowController = thePostWindowController;
    }

- (IBAction)bookmark:(id)sender
    {
    self.selectedPost = [self.postsArrayController.selectedObjects lastObject];

    [self.managedObjectContext performBlockAndWait:^{
        self.selectedPost.label = self.selectedPost.label.length == 0 ? @"bookmark" : NULL;
        }];


    [self.managedObjectContext refetchObjectControllers];
    }

- (IBAction)delete:(id)sender
    {
    NSLog(@"Delete not implemented yet.");
    }

- (IBAction)open:(id)sender
    {
    self.selectedPost = [self.postsArrayController.selectedObjects lastObject];

    NSURL *theURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://alpha.app.net/%@/post/%@", self.selectedPost.user.username, self.selectedPost.externalIdentifier]];
    [[NSWorkspace sharedWorkspace] openURL:theURL];
    }

#pragma mark -

- (void)tableView:(NSTableView *)tableView didAddRowView:(NSTableRowView *)rowView forRow:(NSInteger)row NS_AVAILABLE_MAC(10_7);
    {
    for (int N = 0; N != rowView.numberOfColumns; ++N)
        {
        CTimelineTableCellView *theView = [rowView viewAtColumn:N];
        [theView reset];
        }
    }

- (NSMenu *)timelineTableView:(CTimelineTableView *)inTableView menuForEvent:(NSEvent *)event;
    {
    // TODO this KVO on array controller for this!
    self.selectedPost = [self.postsArrayController.selectedObjects lastObject];

    return(self.postMenu);
    }

@end
