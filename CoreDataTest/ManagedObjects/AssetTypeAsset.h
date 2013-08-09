//
//  AssetTypeAsset.h
//  CoreDataTest
//
//  Created by Matthew Krueger on 8/5/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Asset, AssetType;

@interface AssetTypeAsset : NSManagedObject

@property (nonatomic, retain) NSString * assetId;
@property (nonatomic, retain) NSString * assetTypeId;
@property (nonatomic, retain) AssetType *assetType;
@property (nonatomic, retain) Asset *asset;

@end
