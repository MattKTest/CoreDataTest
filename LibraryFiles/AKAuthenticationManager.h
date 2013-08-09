//
//  AKLoginManager.h
//  ArthrexKit
//
//  Created by Matthew Krueger on 7/18/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPClient.h>

extern NSString *const AKUserWillNeedToAuthenticate;
extern NSString *const AKAuthenticationDidSucceed;

@protocol AKAuthenticationManagerDelegate <NSObject>

- (void)authenticationDidSucceed;

- (void)userWillNeedToAuthenticateWithMessage:(NSString *)message;

@end

@interface AKAuthenticationManager : NSObject

@property (strong, nonatomic) id<AKAuthenticationManagerDelegate> delegate;

+ (AKAuthenticationManager *)sharedManager;

- (void)loginWithUsername:(NSString *)username
              andPassword:(NSString *)password
                  success:(void(^)(void))success
                  failure:(void(^)(NSError *))failure;

- (UIViewController *)loginViewController;

- (void)authenticateUserWithMessage:(NSString *)message andCompletionBlock:(void(^)(void))completion;

- (void)clearToken;

- (NSString *)token;

- (void)userWillNeedToAuthenticateWithCompletionBlock:(void(^)(void))completion;

@end
