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
@property (readwrite, nonatomic, strong) NSArray *viewControllers;
@property (readwrite, nonatomic, strong) NSIndexSet *selectionIndexes;
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
        @{
            @"name": @"Global",
            @"predicate": [NSPredicate predicateWithFormat:@"streams CONTAINS %@", [CAppService sharedInstance].globalStreamEntity],
        },
        @{
            @"name": @"My Stream",
            @"predicate": [NSPredicate predicateWithFormat:@"streams CONTAINS %@", [CAppService sharedInstance].myStreamEntity],
        },
        @{
            @"name": @"Mentions",
            @"predicate": [NSPredicate predicateWithFormat:@"streams CONTAINS %@", [CAppService sharedInstance].mentionsStreamEntity],
        },
        @{
            @"name": @"My Posts",
            @"predicate": [NSPredicate predicateWithFormat:@"streams CONTAINS %@", [CAppService sharedInstance].myPostsStreamEntity],
        },
        @{
            @"name": @"Bookmarks",
            @"predicate": [NSPredicate predicateWithFormat:@"label = 'bookmark'"],
        },
        @{
            @"name": @"#AppStream",
            @"predicate": [NSPredicate predicateWithFormat:@"text CONTAINS '#AppStream'"],
        },
        @{
            @"name": @"schwa",
            @"predicate": [NSPredicate predicateWithFormat:@"text CONTAINS 'schwa'"],
        },
        ];

    NSMutableArray *theViewControllers = [NSMutableArray array];

    for (NSDictionary *thePrototype in thePrototypes)
        {
        NSString *theName = thePrototype[@"name"];
        NSPredicate *thePredicate = thePrototype[@"predicate"];

        CTimelineViewController *theTimelineViewController = [[CTimelineViewController alloc] initWithName:theName predicate:thePredicate];

        [theViewControllers addObject:theTimelineViewController];
        }

    for (CTimelineViewController *theViewController in theViewControllers)
        {
        CContainerView *theContainerView = [[CContainerView alloc] initWithFrame:CGRectZero];
        theContainerView.viewController = theViewController;

        NSTabViewItem *theTabViewItem = [[NSTabViewItem alloc] initWithIdentifier:theViewController.name];
        theTabViewItem.label = theViewController.name;
        theTabViewItem.view = theContainerView;

        [self.tabView addTabViewItem:theTabViewItem];
        }

    self.viewControllers = [theViewControllers copy];

    }

#pragma mark -

- (IBAction)refresh:(id)sender
    {
    [[CAppService sharedInstance] retrieveAllStreams];
    }


@end
