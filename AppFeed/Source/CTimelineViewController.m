//
//  CTimelineViewController.m
//  App
//
//  Created by Jonathan Wight on 8/12/12.
//  Copyright (c) 2012 toxicsoftware. All rights reserved.
//

#import "CTimelineViewController.h"

#import "CAppService.h"

@interface CTimelineViewController ()

@end

@implementation CTimelineViewController

- (id)initWithStream:(NSManagedObject *)inStream
    {
    if ((self = [super initWithNibName:NSStringFromClass([self class]) bundle:NULL]) != NULL)
        {
        _stream = inStream;
        _filterPredicate = [NSPredicate predicateWithFormat:@"stream == %@", _stream];
        }
    return self;
    }

- (void)loadView;
    {
    [super loadView];
    //
    [[CAppService sharedInstance] retrieveGlobalStream:NULL success:NULL];
    }

- (NSManagedObjectContext *)managedObjectContext
    {
    return([CAppService sharedInstance].managedObjectContext);
    }

@end
