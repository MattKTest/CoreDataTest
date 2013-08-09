//
//  Taxa.h
//  CoreDataTest
//
//  Created by Matthew Krueger on 8/7/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Asset, AssetClassification, Closure;

@interface Taxa : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * taxonGroupId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *assetClassifications;
@property (nonatomic, retain) NSSet *closureAncestors;
@property (nonatomic, retain) NSSet *closureDescendants;
@property (nonatomic, retain) NSSet *assets;
@end

@interface Taxa (CoreDataGeneratedAccessors)

- (void)addAssetClassificationsObject:(AssetClassification *)value;
- (void)removeAssetClassificationsObject:(AssetClassification *)value;
- (void)addAssetClassifications:(NSSet *)values;
- (void)removeAssetClassifications:(NSSet *)values;

- (void)addClosureAncestorsObject:(Closure *)value;
- (void)removeClosureAncestorsObject:(Closure *)value;
- (void)addClosureAncestors:(NSSet *)values;
- (void)removeClosureAncestors:(NSSet *)values;

- (void)addClosureDescendantsObject:(Closure *)value;
- (void)removeClosureDescendantsObject:(Closure *)value;
- (void)addClosureDescendants:(NSSet *)values;
- (void)removeClosureDescendants:(NSSet *)values;

- (void)addAssetsObject:(Asset *)value;
- (void)removeAssetsObject:(Asset *)value;
- (void)addAssets:(NSSet *)values;
- (void)removeAssets:(NSSet *)values;

- (NSArray *)productGroups;
- (NSArray *)procedureGroups;
- (NSArray *)assetArray;

@end
