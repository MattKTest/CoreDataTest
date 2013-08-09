//
//  Taxa.m
//  CoreDataTest
//
//  Created by Matthew Krueger on 8/7/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import "Taxa.h"
#import "Asset.h"
#import "AssetClassification.h"
#import "Closure.h"

@implementation Taxa

@dynamic id;
@dynamic taxonGroupId;
@dynamic title;
@dynamic assetClassifications;
@dynamic closureAncestors;
@dynamic closureDescendants;
@dynamic assets;

- (NSArray *)productGroups
{
    NSDictionary *d = @{@"product_category" : @"Product Category",
                        @"product_family" : @"Product Family",
                        @"product_group" : @"Product Group"};
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taxaDescendant.taxonGroupId IN %@", d.allKeys];
    
    return [[self.closureAncestors filteredSetUsingPredicate:predicate] allObjects];
}

- (NSArray *)procedureGroups
{
    return nil;
}

- (NSArray *)assetArray
{
    if (self.assets.count < 1) {
        NSMutableArray *assets = [[NSMutableArray alloc] init];
        
        for (Closure *closure in self.closureAncestors) {
            for (AssetClassification *assetClassification in closure.taxaDescendant.assetClassifications) {
                if (assetClassification.asset) {
                    if (![assets containsObject:assetClassification.asset]) {
                        [assets addObject:assetClassification.asset];
                    }
                }
            }
        }
        
        self.assets = [NSSet setWithArray:assets];
    }
    
    return [self.assets allObjects];
}

@end
