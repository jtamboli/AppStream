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

@interface CTimelineViewController () <NSTableViewDelegate>
@property (readonly, nonatomic, strong) NSPredicate *filterPredicate;
@property (readonly, nonatomic, strong) NSArray *sortDescriptors;
@property (readonly, nonatomic, strong) IBOutlet NSArrayController *postsArrayController;

@end

@implementation CTimelineViewController

- (id)initWithStream:(CStream *)inStream
    {
    if ((self = [super initWithNibName:NSStringFromClass([self class]) bundle:NULL]) != NULL)
        {
        _stream = inStream;
        _filterPredicate = [NSPredicate predicateWithFormat:@"streams CONTAINS %@", _stream];
        _sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"posted" ascending:NO] ];
        }
    return self;
    }

- (void)loadView
    {
    [super loadView];
    //
    NSLog(@">>> %@", self.view);
    NSLog(@">>> %@", _postsArrayController);
    NSLog(@">>> %@", self.postsArrayController);

    [[CAppService sharedInstance] retrievePostsForStream:self.stream options:NULL success:NULL];
    }

- (NSManagedObjectContext *)managedObjectContext
    {
    return([CAppService sharedInstance].managedObjectContext);
    }

- (void)tableView:(NSTableView *)tableView didAddRowView:(NSTableRowView *)rowView forRow:(NSInteger)row NS_AVAILABLE_MAC(10_7);
    {
    for (int N = 0; N != rowView.numberOfColumns; ++N)
        {
        CTimelineTableCellView *theView = [rowView viewAtColumn:N];
        [theView reset];
        }
    }

- (IBAction)reply:(id)sender
    {
    NSLog(@"REPLY: %@", self.postsArrayController);
    }

@end
