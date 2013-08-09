//
//  FileWebViewController.m
//  ArthrexKit
//
//  Created by Matthew Krueger on 8/1/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import "AKFileWebViewController.h"
#import "AKAsset.h"
#import "AKFileDownloadManager.h"

@interface AKFileWebViewController ()

@property (nonatomic) NSString *filePath;

@end

@implementation AKFileWebViewController

- (id)initWithAsset:(AKAsset *)asset
{
    self = [self init];
    if (self) {
        self.asset = asset;
    }
    return self;
}

- (id)init
{
    self = [[AKFileWebViewController alloc] initWithNibName:@"AKFileWebViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        
    }
    return self;
}

- (void)setAsset:(AKAsset *)asset
{
    if (_asset != asset) {
        _asset = asset;
        
        self.progressView.progress = 0;
        self.filePath = nil;
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:@"about:blank"]]];
        [self.webView reload];
        self.webView.hidden = YES;

        self.navigationItem.title = asset.title;
        [[self fileDownloadManager] fetchAsset:asset withSuccess:^(NSString *filePath) {
            self.filePath = filePath;
            [self reloadWebView];
        } progress:^(CGFloat progressPercentage) {
            [self.progressView setProgress:progressPercentage animated:YES];
        } andFailure:^(NSError *error) {
            // handle an error
            NSLog(@"%@", error.description);
        }];
    }
}

- (AKFileDownloadManager *)fileDownloadManager
{
    static AKFileDownloadManager *_fileDownloadManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _fileDownloadManager = [[AKFileDownloadManager alloc] init];
    });
    return _fileDownloadManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.filePath.length > 0 && self.webView.hidden) {
        [self reloadWebView];
    }
}

- (void)reloadWebView
{
    if (self.filePath.length > 0) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:self.filePath]]];
        self.webView.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
