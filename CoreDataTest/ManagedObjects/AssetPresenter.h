//
//  AssetPresenter.h
//  CoreDataTest
//
//  Created by Matthew Krueger on 8/5/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Asset, Presenter;

@interface AssetPresenter : NSManagedObject

@property (nonatomic, retain) NSString * assetId;
@property (nonatomic, retain) NSNumber * presenterId;
@property (nonatomic, retain) Presenter *presenter;
@property (nonatomic, retain) Asset *asset;

@end
