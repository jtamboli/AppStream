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

- (NSResponder *)nextResponder
    {
    return(self.viewController);
    }

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
            }
        }
    }

@end
