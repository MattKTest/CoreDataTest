//
//  AKDatabaseManager.h
//  ArthrexKit
//
//  Created by Matthew Krueger on 7/26/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AKAsset;

extern NSString *const kDatabaseKey;

@interface AKFileDownloadManager : NSObject

- (BOOL)databaseExists:(NSString *)databaseName;
- (BOOL)apiDatabaseExists;

@property (nonatomic, strong) NSString *apiDatabaseName;

@property (nonatomic, strong) NSString *localDatabaseLocation;

- (void)fetchAsset:(AKAsset *)asset
       withSuccess:(void (^)(NSString *filePath))success
          progress:(void (^)(CGFloat progressPercentage))progress
        andFailure:(void (^)(NSError *error))failure;

- (void)downloadDatabaseAtURL:(NSString *)url withSuccess:(void (^)(void))success andFailure:(void (^)(NSError *error))failure;

- (NSString *)apiDatabasePath;

- (NSString *)localDatabasePathForDbNamed:(NSString *)databaseName;

@end
