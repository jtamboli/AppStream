//
//  CContainerView.h
//  SceneKitTest
//
//  Created by Jonathan Wight on 2/18/12.
//  Copyright (c) 2012 toxicsoftware.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CContainerView : NSView

@property (readwrite, nonatomic, strong) NSViewController *viewController;

@end
