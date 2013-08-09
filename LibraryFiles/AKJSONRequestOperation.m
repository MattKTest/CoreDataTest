//
//  AKJSONRequestOperation.m
//  ArthrexKit
//
//  Created by Matthew Krueger on 7/24/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import "AKJSONRequestOperation.h"
#import "AKAuthenticationManager.h"

@implementation AKJSONRequestOperation

+ (instancetype)JSONRequestOperationWithRequest:(NSURLRequest *)urlRequest
										success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
										failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure
{
    AFJSONRequestOperation *requestOperation = [(AFJSONRequestOperation *)[self alloc] initWithRequest:urlRequest];
    
    //__weak AFJSONRequestOperation *request = requestOperation;
    
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation.request, operation.response, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {            
            failure(operation.request, operation.response, error, [(AFJSONRequestOperation *)operation responseJSON]);
        }
        
        
#warning need to handle the various errors here
        
        NSLog(@"%@", @"hit our authentication call back");
        
        //if no internet
        
        //else if invalid 
//        [[AKAuthenticationManager sharedManager] userWillNeedToAuthenticateWithCompletionBlock:^{
//            [request start];
//        }];

    }];
    
    return (AKJSONRequestOperation *)requestOperation;
}

+ (NSSet *)acceptableContentTypes
{
    return [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"application/zip", nil];
}

@end
