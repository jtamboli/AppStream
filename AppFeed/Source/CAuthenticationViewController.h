//
//  CAuthenticationViewController.h
//  App
//
//  Created by Jonathan Wight on 8/12/12.
//  Copyright (c) 2012 toxicsoftware. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CAuthenticationViewController : NSViewController

- (id)initWithCompletionBlock:(void (^)(void))inCompletionBlock;

@end
