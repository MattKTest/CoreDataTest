//
//  AKMoviePlayerViewController.h
//  ArthrexKit
//
//  Created by Matthew Krueger on 8/1/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AKAsset;

@interface AKMoviePlayerViewController : UIViewController

- (id)initWithAsset:(AKAsset *)asset;

@property (nonatomic, strong) AKAsset *asset;

@end
