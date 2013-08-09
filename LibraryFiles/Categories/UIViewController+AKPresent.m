//
//  UIViewController+AKPresent.m
//  LibraryTester
//
//  Created by Matthew Krueger on 7/19/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import "UIViewController+AKPresent.h"

@implementation UIViewController (AKPresent)

- (void)presentViewController:(UIViewController *)viewControllerToPresent
             presentationType:(AKPresentationType)presentationType
                   completion:(void (^)(void))completion
{    
    if (presentationType == AKPresentationTypeTopSlide) {
        
        [self addChildViewController:viewControllerToPresent];
        
        CGRect frame  = self.view.bounds;
        CGRect newFrame  = self.view.bounds;

        frame.origin.y -= frame.size.height;
        
        viewControllerToPresent.view.frame = frame;

        [self.view addSubview:viewControllerToPresent.view];
        [viewControllerToPresent didMoveToParentViewController:self];

        [UIView animateWithDuration:0.3 animations:^{
            viewControllerToPresent.view.frame = newFrame;
        } completion:^(BOOL finished) {
            if (finished) {
                if (completion) {
                    completion();
                }
            }
        }];
    }
}

- (void)dismissViewController:(UIViewController *)viewControllerToRemove
            presentationType:(AKPresentationType)presentationType
                  completion:(void (^)(void))completion
{
    if (presentationType == AKPresentationTypeTopSlide) {
        CGRect frame = self.view.bounds;
        frame.origin.y -= frame.size.height;
        
        [UIView animateWithDuration:0.3 animations:^{
            viewControllerToRemove.view.frame = frame;
        } completion:^(BOOL finished) {
            if (finished) {
                [viewControllerToRemove willMoveToParentViewController:nil];
                [viewControllerToRemove.view removeFromSuperview];
                [viewControllerToRemove removeFromParentViewController];
                if (completion) {
                    completion();
                }
            }
        }];
    }
}

@end
