//
//  AKAPIClient.h
//  ArthrexKit
//
//  Created by Matthew Krueger on 7/18/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPClient.h>

@class AKAsset;

extern NSString *const kAPIBaseURL;

@interface AKAPIClient : AFHTTPClient

+ (AKAPIClient *)sharedClient;

- (NSURL *)streamURLForAsset:(AKAsset *)asset;

@end