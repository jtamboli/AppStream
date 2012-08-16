//
//  CPostWindowController.h
//  //  AppStream
//
//  Created by Jonathan Wight on 8/14/12.
//  Copyright (c) 2012 toxicsoftware. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CPost;

@interface CPostWindowController : NSWindowController

- (id)initWithSubjectPost:(CPost *)inSubjectPost;

@end
