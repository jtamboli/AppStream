//
//  CTimelineViewController.h
//  App
//
//  Created by Jonathan Wight on 8/12/12.
//  Copyright (c) 2012 toxicsoftware. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CTimelineViewController : NSViewController

@property (readonly, nonatomic, strong) NSManagedObject *stream;
@property (readonly, nonatomic, strong) NSPredicate *filterPredicate;

- (id)initWithStream:(NSManagedObject *)inStream;

@end
