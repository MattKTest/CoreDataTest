//
//  AKFileDownloadManager.m
//  ArthrexKit
//
//  Created by Matthew Krueger on 7/26/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import "AKFileDownloadManager.h"
#import "AKAPIFileClient.h"
#import "AKHTTPRequestOperation.h"
#import <SSZipArchive.h>
#import "AKAsset.h"

NSString *const kDatabaseKey = @"DatabaseKey";

@interface AKFileDownloadManager ()
{
    NSString *_apiDatabaseName, *_localStorageDirectory;
}

@property (nonatomic) NSMutableArray *operationsForAssetsBeingDownloaded;

@end

@implementation AKFileDownloadManager

- (id)init
{
    self = [super init];
    if (self) {
        // set some defaults
        _localStorageDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        _apiDatabaseName = [[NSUserDefaults standardUserDefaults] stringForKey:kDatabaseKey];
        self.operationsForAssetsBeingDownloaded = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)databaseExists:(NSString *)databaseName
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self localDatabasePathForDbNamed:databaseName]];
}

- (BOOL)apiDatabaseExists;
{
    return [self databaseExists:[self apiDatabaseName]];
}

- (NSString *)apiDatabaseName
{
    return _apiDatabaseName;
}

- (void)setApiDatabaseName:(NSString *)name
{
    [[NSUserDefaults standardUserDefaults] setValue:name forKey:kDatabaseKey];
    _apiDatabaseName = name;
}

- (NSString *)apiDatabasePath
{
    return [[self localStorageDirectory] stringByAppendingPathComponent:
            [NSString stringWithFormat:@"%@.db", [self apiDatabaseName]]];
}

- (NSString *)localDatabasePathForDbNamed:(NSString *)databaseName
{
    return [[self localStorageDirectory] stringByAppendingPathComponent:
                    [NSString stringWithFormat:@"%@.db", databaseName]];
}

- (NSString *)localStorageDirectory
{
    return _localStorageDirectory;
}

- (void)setLocalStorageDirectory:(NSString *)localDatabaseLocation
{
    _localStorageDirectory = localDatabaseLocation;
}

- (NSString *)apiDatabaseZipPath
{
    return [[self localStorageDirectory] stringByAppendingPathComponent:
            [NSString stringWithFormat:@"%@.zip", [self apiDatabaseName]]];
}

- (void)downloadDatabaseAtURL:(NSString *)url withSuccess:(void (^)(void))success andFailure:(void (^)(NSError *))failure
{
    NSMutableURLRequest *request = [[AKAPIFileClient sharedClient] requestWithMethod:@"GET" path:url parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    NSString *path = [self apiDatabaseZipPath];
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:path append:NO]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SSZipArchive unzipFileAtPath:path toDestination:[self localStorageDirectory]];
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        if (success) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    [operation start];
}

- (void)fetchAsset:(AKAsset *)asset
          withSuccess:(void (^)(NSString *filePath))success
             progress:(void (^)(CGFloat progressPercentage))progress
           andFailure:(void (^)(NSError *error))failure;
{
    NSString *path = [self localPathForAsset:asset];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"assetId == %@", asset.Id];
    
    //search our array of assets we are downloading for the asset being requested
    NSArray *operationsForAsset = [self.operationsForAssetsBeingDownloaded filteredArrayUsingPredicate:predicate];
    
    AKHTTPRequestOperation *operationForAsset;
    
    // if we are are downloading the asset already just attach to that operation
    if (operationsForAsset.count > 0) {
        NSLog(@"%@", @"attaching to existing operation");
        operationForAsset = [operationsForAsset objectAtIndex:0];
    }
    // we already have the file run the success block and return
    else if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        success(path);
        return;
    }
    // we need to download the file
    else {
        NSLog(@"%@", @"creating new operation");
        NSMutableURLRequest *request = [[AKAPIFileClient sharedClient] requestForAsset:asset];
        operationForAsset = [[AKHTTPRequestOperation alloc] initWithRequest:request andAssetId:asset.Id];
        [operationForAsset setOutputStream:[NSOutputStream outputStreamToFileAtPath:path append:NO]];
    }
    
    // attach to the progess block if one was passed in
    if (progress) {
        [operationForAsset setDownloadProgressBlock:^(NSUInteger bytesRead,
                                                      long long totalBytesRead,
                                                      long long totalBytesExpectedToRead) {
            progress((float)totalBytesRead/(float)totalBytesExpectedToRead);
        }];
    }
    
    // run the completion blocks when we complete and in either case remove the request from our array
    // of assets being downloaded
    [operationForAsset setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.operationsForAssetsBeingDownloaded removeObject:operation];
        if (success) {
            success(path);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.operationsForAssetsBeingDownloaded removeObject:operation];
        if (failure) {
            failure(error);
        }
    }];
    
    // be sure we don't start an operation that is already running or complete
    if (!operationForAsset.isExecuting && !operationForAsset.isFinished) {
        [self.operationsForAssetsBeingDownloaded addObject:operationForAsset];
        [operationForAsset start];
    }
}


- (NSString *)localPathForAsset:(AKAsset *)asset
{
    NSString *extension = @"";
    
    if (asset.type == AssetTypeAudio) {
        extension = @".mp3";
    }
    else if (asset.type == AssetTypeDocument) {
        extension = @".doc";
    }
    else if (asset.type == AssetTypeiBook) {
        extension = @".ibooks";
    }
    else if (asset.type == AssetTypePDF) {
        extension = @".pdf";
    }
    else if (asset.type == AssetTypePowerPoint) {
        extension = @".ppt";
    }
    else if (asset.type == AssetTypeSpreadSheet) {
        extension = @".xls";
    }
    else if (asset.type == AssetTypeVideo) {
        extension = @".mp4";
    }
    else if (asset.type == AssetTypeZip) {
        extension = @".zip";
    }
    return [[self localStorageDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", asset.Id, extension]];
}
    
    //    @throw [NSException exceptionWithName:NSInternalInconsistencyException
    //                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
    //                                 userInfo:nil];




//- (void)fetchAsset:(AKAsset *)asset
//       withSuccess:(void (^)(NSString *filePath))success
//          progress:(void (^)(CGFloat progressPercentage))progress
//        andFailure:(void (^)(NSError *error))failure;
//{
//    
//    NSString *path = [self localPathForAsset:asset];
//    
//    // we already have the file run the success block with its path
//    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
//        success(path);
//    }
//    else {
//        
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"assetId == %@", asset.Id];
//        
//        //search our array of assets we are downloading for the asset being requested
//        NSArray *operationsForAsset = [self.operationsForAssetsBeingDownloaded filteredArrayUsingPredicate:predicate];
//        
//        AKHTTPRequestOperation *operationForAsset;
//        
//        // if we are are downloading the asset already just attach to that operation
//        if (operationsForAsset.count > 0) {
//            NSLog(@"%@", @"attaching to existing operation");
//            operationForAsset = [operationsForAsset objectAtIndex:0];
//        }
//        else {
//            NSLog(@"%@", @"creating new operation");
//            
//            NSMutableURLRequest *request = [[AKAPIFileClient sharedClient] requestForAsset:asset];
//            operationForAsset = [[AKHTTPRequestOperation alloc] initWithRequest:request andAssetId:asset.Id];
//            [operationForAsset setOutputStream:[NSOutputStream outputStreamToFileAtPath:path append:NO]];
//        }
//        
//        // attach to the progess block if one was passed in
//        if (progress) {
//            [operationForAsset setDownloadProgressBlock:^(NSUInteger bytesRead,
//                                                          long long totalBytesRead,
//                                                          long long totalBytesExpectedToRead) {
//                progress((float)totalBytesRead/(float)totalBytesExpectedToRead);
//            }];
//        }
//        
//        // run the completion blocks when we complete and in either case remove the request from our array
//        // of assets being downloaded
//        [operationForAsset setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//            [self.operationsForAssetsBeingDownloaded removeObject:operation];
//            if (success) {
//                success(path);
//            }
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            [self.operationsForAssetsBeingDownloaded removeObject:operation];
//            if (failure) {
//                failure(error);
//            }
//        }];
//        
//        // be sure we don't start an operation that is already running or complete
//        if (!operationForAsset.isExecuting && !operationForAsset.isFinished) {
//            [self.operationsForAssetsBeingDownloaded addObject:operationForAsset];
//            [operationForAsset start];
//        }
//    }
//}


@end
