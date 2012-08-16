//
//  CMainViewController.m
//  //  AppStream
//
//  Created by Jonathan Wight on 8/14/12.
//  Copyright (c) 2012 toxicsoftware. All rights reserved.
//

#import "CMainViewController.h"

#import "CContainerView.h"
#import "CTimelineViewController.h"
#import "CAppService.h"

@interface CMainViewController ()
@property (readwrite, nonatomic, assign) IBOutlet NSTabView *tabView;
@property (readwrite, nonatomic, assign) IBOutlet NSArrayController *arrayController;
@property (readwrite, nonatomic, assign) NSIndexSet *selectionIndexes;
@end

@implementation CMainViewController

- (id)init
    {
    if ((self = [super initWithNibName:NSStringFromClass([self class]) bundle:NULL]) != NULL)
        {
        }
    return self;
    }

#pragma mark -

- (void)setSelectionIndexes:(NSIndexSet *)selectionIndexes
    {
    NSParameterAssert(selectionIndexes.count == 1);

    _selectionIndexes = selectionIndexes;

    [self.tabView selectTabViewItemAtIndex:selectionIndexes.lastIndex];
    }

- (NSManagedObjectContext *)managedObjectContext
    {
    return([CAppService sharedInstance].managedObjectContext);
    }

#pragma mark -

- (void)loadView;
    {
    [super loadView];

    NSArray *theItems = [self.tabView.tabViewItems copy];
    for (NSTabViewItem *theItem in theItems)
        {
        [self.tabView removeTabViewItem:theItem];
        }

    NSArray *thePrototypes = @[
        @{ @"name": @"Global", @"stream": [CAppService sharedInstance].globalStreamEntity },
        @{ @"name": @"My Stream", @"stream": [CAppService sharedInstance].myStreamEntity },
        @{ @"name": @"Mentions", @"stream": [CAppService sharedInstance].mentionsStreamEntity },
        @{ @"name": @"My Posts", @"stream": [CAppService sharedInstance].myPostsStreamEntity },
        ];

    for (NSDictionary *thePrototype in thePrototypes)
        {
        CTimelineViewController *theTimelineViewController = [[CTimelineViewController alloc] initWithStream:thePrototype[@"stream"]];
        CContainerView *theContainerView = [[CContainerView alloc] initWithFrame:CGRectZero];
        theContainerView.viewController = theTimelineViewController;

        NSTabViewItem *theTabViewItem = [[NSTabViewItem alloc] initWithIdentifier:thePrototype[@"name"]];
        theTabViewItem.label = thePrototype[@"name"];
        theTabViewItem.view = theContainerView;

        [self.tabView addTabViewItem:theTabViewItem];
        }

    }

#pragma mark -

- (IBAction)refresh:(id)sender
    {
    [[CAppService sharedInstance] retrieveAllStreams];
    }


@end
