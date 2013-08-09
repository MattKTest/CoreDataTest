//
//  AKAPDDatabaseClient.m
//  ArthrexKit
//
//  Created by Matthew Krueger on 7/25/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import "AKAPIFileClient.h"
#import "AKAPIClient.h"
#import <AFHTTPRequestOperation.h>
#import "AKAuthenticationManager.h"
#import "AKAsset.h"

@implementation AKAPIFileClient

+ (AKAPIFileClient *)sharedClient
{
    static AKAPIFileClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kAPIBaseURL]];
    });
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    if (self = [super initWithBaseURL:url]) {
        [self registerHTTPOperationClass:[AFHTTPRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"text/html"];
        self.parameterEncoding = AFJSONParameterEncoding;
    }
    return self;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters
{
    // we need to grab this token every time we create a request to ensure we have the current token.
    [self setDefaultHeader:@"Authorization" value:nil];
    return [super requestWithMethod:method path:path parameters:parameters];
}

- (NSMutableURLRequest *)requestForAsset:(AKAsset *)asset
{
    NSMutableString *path = [NSMutableString stringWithFormat:@"/assets/%@/download?cdn=false", asset.Id];
    
    // look up country and language
    [path appendString:@"&currentCountry=US&currentLanguage=en"];
    
    [self setDefaultHeader:@"Authorization"
                     value:[NSString stringWithFormat:@"Bearer %@", [AKAuthenticationManager sharedManager].token]];
    
    return [super requestWithMethod:@"GET" path:path parameters:nil];
}


@end
