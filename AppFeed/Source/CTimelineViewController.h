//
//  CTimelineViewController.h
//  App
//
//  Created by Jonathan Wight on 8/12/12.
//  Copyright (c) 2012 toxicsoftware. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CStream;

@interface CTimelineViewController : NSViewController

@property (readonly, nonatomic, strong) CStream *stream;
@property (readonly, nonatomic, strong) NSPredicate *filterPredicate;
@property (readonly, nonatomic, strong) NSArray *sortDescriptors;

- (id)initWithStream:(CStream *)inStream;

@end
