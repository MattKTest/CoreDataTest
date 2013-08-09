//
//  AKAPDDatabaseClient.h
//  ArthrexKit
//
//  Created by Matthew Krueger on 7/25/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPClient.h>

@class AKAsset; 

@interface AKAPIFileClient : AFHTTPClient

+ (AKAPIFileClient *)sharedClient;

- (NSMutableURLRequest *)requestForAsset:(AKAsset *)asset;

@end
