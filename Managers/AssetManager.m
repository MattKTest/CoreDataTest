//
//  ResourceCommunicator.m
//  ArthrexKit
//
//  Created by Matthew Krueger on 7/23/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import "AssetManager.h"
#import "AKAPIClient.h"
#import "AKJSONRequestOperation.h"

@interface AssetManager ()
{
    NSString *_filename;
}

@end

@implementation AssetManager

- (void)fetchDatabaseNameAndURL:(void(^)(NSString *name, NSString *url))success andFailure:(void (^)(NSError *error))failure;
{
    NSMutableURLRequest *request = [[AKAPIClient sharedClient] requestWithMethod:@"GET"
                                                                            path:@"sqlite/mediacenter?currentCountry=US&currentLanguage=en"
                                                                      parameters:nil];
    
    AKJSONRequestOperation *operation =
        [AKJSONRequestOperation JSONRequestOperationWithRequest:request
                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                            if (success) {
                                                                success([JSON objectForKey:@"filename"],
                                                                        [JSON objectForKey:@"url"]);
                                                            }
                                                        }
                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                            
                                                        }];
    [operation start];
}

@end
