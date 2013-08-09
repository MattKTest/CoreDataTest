//
//  DatabaseManager.h
//  ArthrexKit
//
//  Created by Matthew Krueger on 7/26/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import "AKFileDownloadManager.h"

extern NSString *const kAPPDB;

@interface DatabaseManager : AKFileDownloadManager

- (void)downloadDatabaseWithSuccess:(void (^)(void))success andFailure:(void (^)(NSError *error))failure;

- (void)importCountriesToCoreData;
- (void)importAssetTypesToCoreData;
- (void)importAssetsToCoreData;
- (void)importClosuresToCoreData;
- (void)importTaxaToCoreData;
- (void)importAssetClassificationsToCoreData;
- (void)importAssetPresentersToCoreData;
- (void)importPresentersToCoreData;
- (void)importAssetTypeAssetsToCoreData;
- (void)importLocalesToCoreData;
- (void)importTaxonGroupsToCoreData;

- (void)addAllTaxa;

- (NSArray *)assetClassifications;
- (NSArray *)assetPresenters;
- (NSArray *)assets;
- (NSArray *)assetTypeAssets;
- (NSArray *)assetTypes;
- (NSArray *)closures;
- (NSArray *)countries;
- (NSArray *)locales;
- (NSArray *)presenters;
- (NSArray *)taxas;
- (NSArray *)taxonGroups;

- (void)linkAssetClassificationsToAssets;
- (void)linkAssetClassificationsToTaxas;
- (void)linkAssetPresentersToPresenters;
- (void)linkAssetPresentersToAssets;
- (void)linkAssetTypeAssetsToAssetTypes;
- (void)linkAssetTypeAssetsToAssets;
- (void)linkClosureAncestors;
- (void)linkClosureDescendants;

- (NSArray *)teams;

-(void)deleteAndRecreateStore;

- (void)checkAssetPresenters;

@end