//
//  AKAuthenicationClient.h
//  ArthrexKit
//
//  Created by Matthew Krueger on 7/23/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPClient.h>

extern NSString *const kAuthenticationBaseURL;
extern NSString *const kClientCredintials;

@interface AKAuthenicationClient : AFHTTPClient

+ (AKAuthenicationClient *)sharedClient;

@end
