//
//  CTimelineTableView.h
//  AppStream
//
//  Created by Jonathan Wight on 8/15/12.
//  Copyright (c) 2012 toxicsoftware. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol CTimelineTableViewDelegate;

@interface CTimelineTableView : NSTableView
@property (readwrite, nonatomic, assign) id <NSTableViewDelegate, CTimelineTableViewDelegate> delegate;
@end

@protocol CTimelineTableViewDelegate
@required
- (NSMenu *)timelineTableView:(CTimelineTableView *)inTableView menuForEvent:(NSEvent *)event;
@end