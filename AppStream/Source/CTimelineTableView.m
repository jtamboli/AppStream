//
//  CTimelineTableView.m
//  AppStream
//
//  Created by Jonathan Wight on 8/15/12.
//  Copyright (c) 2012 toxicsoftware. All rights reserved.
//

#import "CTimelineTableView.h"

@implementation CTimelineTableView

@dynamic delegate;

- (NSMenu *)menuForEvent:(NSEvent *)event;
    {
    return([self.delegate timelineTableView:self menuForEvent:event]);
    }

@end
