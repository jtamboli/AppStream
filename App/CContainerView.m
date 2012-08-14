//
//  CContainerView.m
//  SceneKitTest
//
//  Created by Jonathan Wight on 2/18/12.
//  Copyright (c) 2012 toxicsoftware.com. All rights reserved.
//

#import "CContainerView.h"

@interface CContainerView ()
@property (readwrite, nonatomic, strong) NSView *contentView;
@end

#pragma mark -

@implementation CContainerView

- (void)setViewController:(NSViewController *)viewController
    {
    if (_viewController != viewController)
        {
		if (_viewController && _viewController.view.superview == self)
			{
			[_viewController.view removeFromSuperview];
			}


		_viewController = viewController;
		self.contentView = _viewController.view;
        if (self.contentView)
            {
            self.contentView.frame = self.bounds;
            self.contentView.translatesAutoresizingMaskIntoConstraints = NO;

            NSDictionary *theViews = @{ @"contentView": self.contentView };


            [self addSubview:self.contentView];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[contentView]-0-|" options:0 metrics:NULL views:theViews]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[contentView]-0-|" options:0 metrics:NULL views:theViews]];


    //		NSLog(@"%d", self.contentView.translatesAutoresizingMaskIntoConstraints);
    //		NSLog(@"%@", self.contentView.constraints);
    //		self.contentView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    //		NSLog(@"%@", self.contentView.constraints);
    //		NSLog(@"%d", self.contentView.translatesAutoresizingMaskIntoConstraints);

            
            NSLog(@"%d", self.hasAmbiguousLayout);
            }
        }
    }

//- (void)drawRect:(NSRect)dirtyRect
//	{
//	[[NSColor redColor] set];
//	NSFrameRect(self.bounds);
//	}

//#if 0
//- (void)updateConstraints
//	{
//	[super updateConstraints];
//
//
//	if (self.contentView != NULL)
//		{
//		NSLog(@"FOO");
//		
//		NSArray *theConstraints = @[ 
//			[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0],
//			[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0],
//			];
////		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
////		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
//
//		for (NSLayoutConstraint *theConstraint in theConstraints)
//			{
//			theConstraint.priority = NSLayoutPriorityDefaultHigh;
//			}
//		[self addConstraints:theConstraints];
//
////		NSDictionary *theViewsDictionary = @{ @"view": self.contentView };
////		NSMutableArray *theConstraints = [NSMutableArray array];
////		[theConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:NULL views:theViewsDictionary]];
////		[theConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:NULL views:theViewsDictionary]];
////		[self addConstraints:theConstraints];
//		}
//
//	NSLog(@"%@", self.constraints);
//	}
//#endif

@end
