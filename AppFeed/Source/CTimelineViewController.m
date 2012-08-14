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

@interface CTimelineViewController ()

@end

@implementation CTimelineViewController

- (id)initWithStream:(CStream *)inStream
    {
    if ((self = [super initWithNibName:NSStringFromClass([self class]) bundle:NULL]) != NULL)
        {
        _stream = inStream;
        _filterPredicate = [NSPredicate predicateWithFormat:@"streams CONTAINS %@", _stream];
        }
    return self;
    }

- (void)loadView;
    {
    [super loadView];
    //
    [[CAppService sharedInstance] retrievePostsForStream:self.stream options:NULL success:NULL];
    }

- (NSManagedObjectContext *)managedObjectContext
    {
    return([CAppService sharedInstance].managedObjectContext);
    }

@end
