//
//  AKHTTPRequestOperation.m
//  ArthrexKit
//
//  Created by Matthew Krueger on 7/31/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import "AKHTTPRequestOperation.h"

@implementation AKHTTPRequestOperation

- (id)initWithRequest:(NSURLRequest *)urlRequest andAssetId:(NSString *)assetId
{
    self = [super initWithRequest:urlRequest];
    if (self) {
        self.assetId = assetId;
    }
    return self;
}

@end
