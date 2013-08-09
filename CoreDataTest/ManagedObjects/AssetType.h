//
//  AssetType.h
//  CoreDataTest
//
//  Created by Matthew Krueger on 8/5/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AssetTypeAsset;

@interface AssetType : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * parent;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *assetTypeAssets;
@end

@interface AssetType (CoreDataGeneratedAccessors)

- (void)addAssetTypeAssetsObject:(AssetTypeAsset *)value;
- (void)removeAssetTypeAssetsObject:(AssetTypeAsset *)value;
- (void)addAssetTypeAssets:(NSSet *)values;
- (void)removeAssetTypeAssets:(NSSet *)values;

@end
