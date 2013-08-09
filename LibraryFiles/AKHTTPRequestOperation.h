//
//  AKHTTPRequestOperation.h
//  ArthrexKit
//
//  Created by Matthew Krueger on 7/31/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import "AFHTTPRequestOperation.h"

@interface AKHTTPRequestOperation : AFHTTPRequestOperation

@property (nonatomic) NSString *assetId;

- (id)initWithRequest:(NSURLRequest *)urlRequest andAssetId:(NSString *)assetId;

@end
