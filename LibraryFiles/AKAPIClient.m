//
//  AKAPIClient.m
//  ArthrexKit
//
//  Created by Matthew Krueger on 7/18/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import "AKAPIClient.h"
#import "AKJSONRequestOperation.h"
#import "AKAuthenticationManager.h"
#import "AKAsset.h"

NSString *const kAPIBaseURL = @"https://api.arthrex.com";

@implementation AKAPIClient

+ (AKAPIClient *)sharedClient
{
    static AKAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kAPIBaseURL]];
    });
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    if (self = [super initWithBaseURL:url]) {
        [self registerHTTPOperationClass:[AKJSONRequestOperation class]];
        self.parameterEncoding = AFJSONParameterEncoding;
    }
    return self;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters
{
    // we need to grab this token every time we create a request to ensure we have the current token.
    [self setDefaultHeader:@"Authorization"
                     value:[NSString stringWithFormat:@"Bearer %@", [AKAuthenticationManager sharedManager].token]];
    return [super requestWithMethod:method path:path parameters:parameters];
}

- (NSURL *)streamURLForAsset:(AKAsset *)asset
{
    NSURL *url = nil;
    
    if (asset.type == AssetTypeVideo) {
        
        NSMutableString *path = [NSMutableString stringWithString:kAPIBaseURL];
        
        [path appendFormat:@"/assets/%@/download?format=m3u8&quality=high&access_token=%@", asset.Id, [AKAuthenticationManager sharedManager].token];
        
        url = [NSURL URLWithString:path];
    }
    
    return url;
}

@end
