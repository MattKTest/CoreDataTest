//
//  FileWebViewController.h
//  ArthrexKit
//
//  Created by Matthew Krueger on 8/1/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AKAsset;

@interface AKFileWebViewController : UIViewController

- (id)initWithAsset:(AKAsset *)asset;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (nonatomic, strong) AKAsset *asset;

@end
