//
//  AKLoginManager.m
//  ArthrexKit
//
//  Created by Matthew Krueger on 7/18/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import "AKAuthenticationManager.h"
#import "AKAuthenicationClient.h"
#import "AKLoginViewController.h"
#import <AFNetworking.h>
#import <KeychainItemWrapper.h>
#import "AKJSONDictionary.h"

NSString *const AKUserWillNeedToAuthenticate = @"AKUserWillNeedToAuthenticate";
NSString *const AKAuthenticationDidSucceed = @"AKAuthenticationDidSucceed";

typedef void (^LoginCompletion)(void);

@interface AKAuthenticationManager ()
{
    LoginCompletion _loginCompletion;
}

@end

@implementation AKAuthenticationManager

+ (AKAuthenticationManager *)sharedManager
{    
    static AKAuthenticationManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (KeychainItemWrapper *) tokenWrapper
{
    static KeychainItemWrapper *_tokenWrapper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tokenWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"OAuthToken" accessGroup:nil];
    });
    return _tokenWrapper;
}

- (void)loginWithUsername:(NSString *)username
              andPassword:(NSString *)password
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *))failure
{        
    NSString *path = [NSString stringWithFormat:@"auth/token/oauth2?grant_type=password&_method=GET&"
                                                @"username=%@&password=%@", username, password];
    
    NSMutableURLRequest *request = [[AKAuthenicationClient sharedClient] requestWithMethod:@"GET" path:path parameters:nil];
    
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                            // save token in keychain
                            NSString *token = [JSON stringForKey:@"oauth2token"];
                            
                            [[self tokenWrapper] setObject:token forKey:(__bridge id)kSecValueData];
                            
                            if (_loginCompletion) {
                                _loginCompletion();
                            }
                           
                            if (success) {
                                success();
                            }
                        }
                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                            if (failure) {
                                failure(error);
                            }
                        }];
    [operation start];
}

- (void)authenticateUserWithMessage:(NSString *)message andCompletionBlock:(void(^)(void))completion;
{
    _loginCompletion = completion;
    
#warning Need logic to determine if token is valid
    
    // did we already save a token
    if ([self token].length > 0) {
        
        if (_loginCompletion) {
            _loginCompletion();
        }
        
        if ([self.delegate respondsToSelector:@selector(authenticationDidSucceed)]) {
            [self.delegate authenticationDidSucceed];
        }
    }
    else {
        
        if ([self.delegate respondsToSelector:@selector(userWillNeedToAuthenticateWithMessage:)]) {
            [self.delegate userWillNeedToAuthenticateWithMessage:message];
        }
    }
}

- (void)clearToken
{
    [[self tokenWrapper] resetKeychainItem];
}

- (UIViewController *)loginViewController
{
    return [[AKLoginViewController alloc] initWithNibName:@"AKLoginViewController" bundle:[NSBundle mainBundle]];
}

- (NSString *)token
{
    return [[self tokenWrapper] objectForKey:(__bridge id)(kSecValueData)];
}

- (void)userWillNeedToAuthenticateWithCompletionBlock:(void(^)(void))completion
{
    if ([self.delegate respondsToSelector:@selector(userWillNeedToAuthenticateWithMessage:)]) {
        [self.delegate userWillNeedToAuthenticateWithMessage:nil];
    }
}

@end
