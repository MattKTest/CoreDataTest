//
//  AKAuthenicationClient.m
//  ArthrexKit
//
//  Created by Matthew Krueger on 7/23/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import "AKAuthenicationClient.h"
#import <AFJSONRequestOperation.h>
#import <NSData+Base64.h>

NSString *const kAuthenticationBaseURL = @"https://api.arthrex.com";
NSString *const kClientCredintials = @"mediacenter:mOjXjS73YB3vlgq6XMqRqcG8o";

@implementation AKAuthenicationClient

+ (AKAuthenicationClient *)sharedClient
{
    static AKAuthenicationClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kAuthenticationBaseURL]];
    });
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    if (self = [super initWithBaseURL:url]) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        
        NSData *clientData = [kClientCredintials dataUsingEncoding:NSUTF8StringEncoding];
        NSString *authValue = [NSString stringWithFormat:@"Basic %@", [clientData base64EncodedString]];
        [self setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Basic %@", authValue]];
        
        self.parameterEncoding = AFJSONParameterEncoding;
    }
    return self;
}

@end
