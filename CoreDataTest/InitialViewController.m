//
//  InitialViewController.m
//  CoreDataTest
//
//  Created by Matthew Krueger on 8/5/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import "InitialViewController.h"
#import "DatabaseManager.h"
#import "Country.h"
#import "AssetType.h"
#import "Asset.h"
#import "Presenter.h"
#import "AssetPresenter.h"
#import "TeamViewController.h"

@interface InitialViewController ()

@end

@implementation InitialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (DatabaseManager *)databaseManager
{
    static DatabaseManager *_databaseManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _databaseManager = [[DatabaseManager alloc] init];
    });
    return _databaseManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)download:(id)sender
{
    [[self databaseManager] downloadDatabaseWithSuccess:^{
        
        NSLog(@"complete");
    } andFailure:^(NSError *error) {
        NSLog(@"failed");
    }];

}

- (IBAction)import:(id)sender
{
    
//[[self databaseManager] deleteAndRecreateStore];
    
    [[self databaseManager] importAssetClassificationsToCoreData];
    [[self databaseManager] importAssetPresentersToCoreData];
    [[self databaseManager] importAssetsToCoreData];
    [[self databaseManager] importAssetTypeAssetsToCoreData];
    [[self databaseManager] importAssetTypesToCoreData];
    [[self databaseManager] importClosuresToCoreData];
    [[self databaseManager] importCountriesToCoreData];
    [[self databaseManager] importLocalesToCoreData];
    [[self databaseManager] importPresentersToCoreData];
    [[self databaseManager] importTaxaToCoreData];
    [[self databaseManager] importTaxonGroupsToCoreData];
//    [[self databaseManager] addAllTaxa];
}

- (IBAction)read:(id)sender
{
 
    [[self databaseManager] linkAssetClassificationsToAssets];
    [[self databaseManager] linkAssetClassificationsToTaxas];
    [[self databaseManager] linkAssetPresentersToAssets];
    [[self databaseManager] linkAssetPresentersToPresenters];
    [[self databaseManager] linkAssetTypeAssetsToAssets];
    [[self databaseManager] linkAssetTypeAssetsToAssetTypes];
    [[self databaseManager] linkClosureAncestors];
    [[self databaseManager] linkClosureDescendants];
//
//    [[self databaseManager] checkAssetPresenters];    

//    NSArray *presenters = [[self databaseManager] presenters];
//    
//    for (Presenter *presenter in presenters) {
//        if (presenter.presenter) {
//            NSLog(@"presenter id %d has %d", presenter.id.intValue, presenter.presenter.count);
//        }
//        else {
//            NSLog(@"no set");
//        }
//    }
//    NSArray *assetPresenters = [[self databaseManager] assetPresenters];
//    
//    NSLog(@"count = %d", assetPresenters.count);
    
//    for (Asset *asset in assets) {
//        NSLog(@"id: %@", asset.id);
//        NSLog(@"version: %@", asset.version);
//        NSLog(@"renditionid: %@", asset.renditionId);
//        NSLog(@"filesize: %@", asset.fileSize);
//        NSLog(@"duration: %@", asset.duration);
//        NSLog(@"literaturenumber: %@", asset.literatureNumber);
//        NSLog(@"basesixtyfourid: %@", asset.baseSixtyFourId);
//        NSLog(@"hash: %@", asset.hashId);
//        NSLog(@"metadatahash: %@", asset.metadataHash);
//        NSLog(@"assetFileTypeId: %@", asset.assetFileTypeId);
//        NSLog(@"title: %@", asset.title);
//        NSLog(@"localeid: %@", asset.localeId);
//        NSLog(@"revisiondate: %@", asset.revisionDate);
//        NSLog(@"sortdate: %@", asset.sortDate);
//        NSLog(@"thumbnail: %@", asset.thumbnail128);
//        NSLog(@"url: %@", asset.url);
//    }

}

- (IBAction)teams:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    TeamViewController *teamViewController = [storyboard instantiateViewControllerWithIdentifier:@"TeamViewController"];
    [self.navigationController pushViewController:teamViewController animated:YES];
}
@end
