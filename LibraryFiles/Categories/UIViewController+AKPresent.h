//
//  UIViewController+AKPresent.h
//  LibraryTester
//
//  Created by Matthew Krueger on 7/19/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    AKPresentationTypeTopSlide = 1
};
typedef NSUInteger AKPresentationType;

@interface UIViewController (AKPresent)

- (void)presentViewController:(UIViewController *)viewControllerToPresent
             presentationType:(AKPresentationType)presentationType
                   completion:(void (^)(void))completion;

- (void)dismissViewController:(UIViewController *)viewControllerToRemove
             presentationType:(AKPresentationType)presentationType
                   completion:(void (^)(void))completion;

@end
