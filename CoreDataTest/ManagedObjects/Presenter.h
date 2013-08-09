//
//  Presenter.h
//  CoreDataTest
//
//  Created by Matthew Krueger on 8/5/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AssetPresenter;

@interface Presenter : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * prefix;
@property (nonatomic, retain) NSString * suffix;
@property (nonatomic, retain) NSSet *assetPresenters;
@end

@interface Presenter (CoreDataGeneratedAccessors)

- (void)addAssetPresentersObject:(AssetPresenter *)value;
- (void)removeAssetPresentersObject:(AssetPresenter *)value;
- (void)addAssetPresenters:(NSSet *)values;
- (void)removeAssetPresenters:(NSSet *)values;

@end
