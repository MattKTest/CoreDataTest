//
//  AssetClassification.h
//  CoreDataTest
//
//  Created by Matthew Krueger on 8/5/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Asset, Taxa;

@interface AssetClassification : NSManagedObject

@property (nonatomic, retain) NSString * assetId;
@property (nonatomic, retain) NSString * taxonId;
@property (nonatomic, retain) Taxa *taxa;
@property (nonatomic, retain) Asset *asset;

@end
