//
//  AKMoviePlayerViewController.m
//  ArthrexKit
//
//  Created by Matthew Krueger on 8/1/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import "AKMoviePlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AKAsset.h"
#import "AKAPIClient.h"

@interface AKMoviePlayerViewController ()

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) MPMoviePlayerController* moviePlayer;
@property (nonatomic, strong) UIActivityIndicatorView* loadingIndicator;

@end

@implementation AKMoviePlayerViewController

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
    self = [super init];
    if (self) {
        self.moviePlayer = [[MPMoviePlayerController alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didExitFullScreen:)
                                                     name:MPMoviePlayerDidExitFullscreenNotification
                                                   object:self.moviePlayer];
                    
        self.moviePlayer.shouldAutoplay = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.view addSubview:self.loadingIndicator];

    CGRect bounds = self.view.bounds;
    self.loadingIndicator.center = CGPointMake(bounds.size.width / 2, bounds.size.height / 2);

    [self.loadingIndicator setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin |
                                                 UIViewAutoresizingFlexibleRightMargin |
                                                 UIViewAutoresizingFlexibleTopMargin |
                                                 UIViewAutoresizingFlexibleBottomMargin];

    if (self.moviePlayer.loadState != MPMovieLoadStatePlayable) {
        [self.loadingIndicator startAnimating];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didExitFullScreen:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setAsset:(AKAsset *)asset
{
    _asset = asset;
    [self.loadingIndicator startAnimating];
    
    // we need to listen to when the 
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerLoadStateChanged:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:self.moviePlayer];
    
    [self.moviePlayer.view removeFromSuperview];
    
    self.url = [[AKAPIClient sharedClient] streamURLForAsset:asset];
    self.navigationItem.title = asset.title;
    self.moviePlayer.contentURL = self.url;
    [self.moviePlayer prepareToPlay];
}

- (void) moviePlayerLoadStateChanged:(NSNotification*)notification
{
    switch ([self.moviePlayer loadState]) {
        case MPMovieLoadStateUnknown:
            break;
        case MPMovieLoadStatePlayable:
            // Remove observer
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:MPMoviePlayerLoadStateDidChangeNotification
                                                          object:nil];
            
            [self.moviePlayer.view setFrame:self.view.bounds];
            [self.moviePlayer.view setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin |
                                                        UIViewAutoresizingFlexibleHeight |
                                                        UIViewAutoresizingFlexibleLeftMargin |
                                                        UIViewAutoresizingFlexibleRightMargin |
                                                        UIViewAutoresizingFlexibleTopMargin |
                                                        UIViewAutoresizingFlexibleWidth];
            
            [self.view addSubview:self.moviePlayer.view];
            [self.moviePlayer play];
            [self.loadingIndicator stopAnimating];
            break;
    }
}

@end
