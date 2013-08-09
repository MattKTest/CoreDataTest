//
//  AKResizableButton.m
//  ArthrexKit
//
//  Created by Matthew Krueger on 7/18/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import "AKResizableButton.h"

@implementation AKResizableButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [super setImage:[self resizeImage:[self imageForState:UIControlStateNormal]]
               forState:UIControlStateNormal];
        [super setImage:[self resizeImage:[self imageForState:UIControlStateHighlighted]]
               forState:UIControlStateHighlighted];
        [super setImage:[self resizeImage:[self imageForState:UIControlStateSelected]]
               forState:UIControlStateSelected];
        [super setImage:[self resizeImage:[self imageForState:UIControlStateDisabled]]
               forState:UIControlStateDisabled];
        
        [super setBackgroundImage:[self resizeImage:[self backgroundImageForState:UIControlStateNormal]]
                         forState:UIControlStateNormal];
        [super setBackgroundImage:[self resizeImage:[self backgroundImageForState:UIControlStateHighlighted]]
                         forState:UIControlStateHighlighted];
        [super setBackgroundImage:[self resizeImage:[self backgroundImageForState:UIControlStateSelected]]
                         forState:UIControlStateSelected];
        [super setBackgroundImage:[self resizeImage:[self backgroundImageForState:UIControlStateDisabled]]
                         forState:UIControlStateDisabled];
    }
    return self;
}

- (UIImage *)resizeImage:(UIImage *)inImage
{
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(ceilf(inImage.size.height / 2),
                                               ceilf(inImage.size.width / 2),
                                               ceilf(inImage.size.height / 2),
                                               ceilf(inImage.size.width / 2));
    
    if ([inImage respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
        // iOS 5
        inImage = [inImage resizableImageWithCapInsets:edgeInsets];
    }
    else {
        inImage = [inImage stretchableImageWithLeftCapWidth:edgeInsets.left topCapHeight:edgeInsets.top];
    }
    return inImage;
}

@end
