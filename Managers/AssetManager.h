//
//  ResourceCommunicator.h
//  ArthrexKit
//
//  Created by Matthew Krueger on 7/23/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKAsset.h"

@interface AssetManager : NSObject

- (void)fetchDatabaseNameAndURL:(void(^)(NSString *name, NSString *url))success andFailure:(void (^)(NSError *error))failure;

@end
