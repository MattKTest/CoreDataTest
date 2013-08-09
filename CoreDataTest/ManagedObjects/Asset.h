//
//  Asset.h
//  CoreDataTest
//
//  Created by Matthew Krueger on 8/7/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AssetClassification, AssetPresenter, AssetTypeAsset, Taxa;

@interface Asset : NSManagedObject

@property (nonatomic, retain) NSString * assetFileTypeId;
@property (nonatomic, retain) NSString * baseSixtyFourId;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * fileSize;
@property (nonatomic, retain) NSString * hashId;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * literatureNumber;
@property (nonatomic, retain) NSString * localeId;
@property (nonatomic, retain) NSString * metadataHash;
@property (nonatomic, retain) NSString * renditionId;
@property (nonatomic, retain) NSString * revisionDate;
@property (nonatomic, retain) NSNumber * sortDate;
@property (nonatomic, retain) NSString * thumbnail128;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * version;
@property (nonatomic, retain) NSSet *assetClassifications;
@property (nonatomic, retain) NSSet *assetPresenters;
@property (nonatomic, retain) NSSet *assetTypeAssets;
@property (nonatomic, retain) NSSet *taxas;
@end

@interface Asset (CoreDataGeneratedAccessors)

- (void)addAssetClassificationsObject:(AssetClassification *)value;
- (void)removeAssetClassificationsObject:(AssetClassification *)value;
- (void)addAssetClassifications:(NSSet *)values;
- (void)removeAssetClassifications:(NSSet *)values;

- (void)addAssetPresentersObject:(AssetPresenter *)value;
- (void)removeAssetPresentersObject:(AssetPresenter *)value;
- (void)addAssetPresenters:(NSSet *)values;
- (void)removeAssetPresenters:(NSSet *)values;

- (void)addAssetTypeAssetsObject:(AssetTypeAsset *)value;
- (void)removeAssetTypeAssetsObject:(AssetTypeAsset *)value;
- (void)addAssetTypeAssets:(NSSet *)values;
- (void)removeAssetTypeAssets:(NSSet *)values;

- (void)addTaxasObject:(Taxa *)value;
- (void)removeTaxasObject:(Taxa *)value;
- (void)addTaxas:(NSSet *)values;
- (void)removeTaxas:(NSSet *)values;

@end
