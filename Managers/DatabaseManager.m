//
//  DatabaseManager.m
//  ArthrexKit
//
//  Created by Matthew Krueger on 7/26/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import "DatabaseManager.h"
#import "AssetManager.h"
#import "AKAsset.h"
#import "AKAPIFileClient.h"
#import <FMDatabase.h>
#import <FMDatabaseQueue.h>

#import "Country.h"
#import "AssetType.h"
#import "Asset.h"
#import "Closure.h"
#import "Taxa.h"
#import "AssetClassification.h"
#import "AssetPresenter.h"
#import "Presenter.h"
#import "AssetTypeAsset.h"
#import "Locale.h"
#import "TaxonGroup.h"

NSString *const kAPPDB = @"AppDb";

@implementation DatabaseManager

- (void)downloadDatabaseWithSuccess:(void (^)(void))success andFailure:(void (^)(NSError *error))failure
{
//    AssetManager *resourceManager = [[AssetManager alloc] init];
        [self setApiDatabaseName:@"9137F845867AC8904045DA08F578B977"];

    [self downloadDatabaseAtURL:@"https://arthrex-sqlite.s3.amazonaws.com/sqlite/9137F845867AC8904045DA08F578B977.zip?AWSAccessKeyId=AKIAJ6YLP7ZCZZQMU7JQ&Expires=1375895985&Signature=Ny0I8nNvuk9Ds2Pg3ZhlfJw%2Fky4%3D" withSuccess:^{
        if (success) {
            success();
        }
    } andFailure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];



//    [resourceManager fetchDatabaseNameAndURL:^(NSString *name, NSString *url) {
//        
//        // after we have the name and location of the db go get it
//        [self setApiDatabaseName:name];
//        [self downloadDatabaseAtURL:url withSuccess:^{
//                                            if (success) {
//                                                success();
//                                            }
//                                        } andFailure:^(NSError *error) {
//                                            if (failure) {
//                                                failure(error);
//                                            }
//                                        }];
//        
//    } andFailure:^(NSError *error) {
//        if (failure) {
//            failure(error);
//        }
//    }];
}

- (NSArray *)teams
{
    NSError *error;
    NSManagedObjectContext *objectContext = [self insertContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"taxonGroupId = 'team' or id = 'arthrex'"]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"title"
                                        ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Taxa"
                                              inManagedObjectContext:objectContext];
    [fetchRequest setEntity:entity];
    
    return [objectContext executeFetchRequest:fetchRequest error:&error];
}

//- (NSArray *)descendantsOfTaxa:(Taxa *)taxa
//{
//    NSError *error;
//    NSManagedObjectContext *objectContext = [self insertContext];
//    
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"taxonGroupId = 'team'"]];
//    
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
//                                        initWithKey:@"title"
//                                        ascending:YES];
//    [fetchRequest setSortDescriptors:@[sortDescriptor]];
//    
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Taxa"
//                                              inManagedObjectContext:objectContext];
//    [fetchRequest setEntity:entity];
//    
//    return [objectContext executeFetchRequest:fetchRequest error:&error];
//}


- (void)importCountriesToCoreData
{
    NSManagedObjectContext *insertContext = [self insertContext];
    
    FMDatabase *database = [FMDatabase databaseWithPath:[self apiDatabasePath]];
    
    [database open];
    
    FMResultSet *result = [database executeQuery:@"SELECT * FROM countries"];
    NSInteger count = 0;
    while ([result next]) {
        Country *country = [NSEntityDescription insertNewObjectForEntityForName:@"Country" inManagedObjectContext:insertContext];
        
        [country setId:[result stringForColumn:@"id"]];
        [country setName:[result stringForColumn:@"name"]];
        
        NSError *error;
        if (![insertContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        count++;
    }
    NSLog(@"Added %d countries", count);

    [database close];
}

- (void)importAssetTypesToCoreData
{
    NSManagedObjectContext *insertContext = [self insertContext];
    
    FMDatabase *database = [FMDatabase databaseWithPath:[self apiDatabasePath]];
    
    [database open];
    
    FMResultSet *result = [database executeQuery:@"SELECT * FROM assettypes"];
    NSInteger count = 0;
    while ([result next]) {
        AssetType *assetType = [NSEntityDescription insertNewObjectForEntityForName:@"AssetType" inManagedObjectContext:insertContext];
        
        [assetType setId:[result stringForColumn:@"id"]];
        [assetType setParent:[result stringForColumn:@"parent"]];
        [assetType setDesc:[result stringForColumn:@"description"]];
        [assetType setTitle:[result stringForColumn:@"title"]];
        
        NSError *error;
        if (![insertContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        count++;
    }
    NSLog(@"Added %d asset Types", count);

    [database close];
}

- (void)importAssetsToCoreData
{
    NSManagedObjectContext *insertContext = [self insertContext];
    
    FMDatabase *database = [FMDatabase databaseWithPath:[self apiDatabasePath]];
    
    [database open];
    
    FMResultSet *result = [database executeQuery:@"SELECT * FROM assets"];
    
    NSInteger count = 0;

    while ([result next]) {
        Asset *asset = [NSEntityDescription insertNewObjectForEntityForName:@"Asset" inManagedObjectContext:insertContext];
        
        [asset setId:[result stringForColumn:@"id"]];
        [asset setVersion:[result stringForColumn:@"version"]];
        [asset setRenditionId:[result objectForColumnName:@"renditionid"]];
        [asset setFileSize:[NSNumber numberWithDouble:[result doubleForColumn:@"filesize"]]];
        [asset setDuration:[NSNumber numberWithInt:[result intForColumn:@"duration"]]];
        [asset setLiteratureNumber:[result stringForColumn:@"literatureNumber"]];
        [asset setBaseSixtyFourId:[result stringForColumn:@"basesixtyfourid"]];
        [asset setHashId:[result stringForColumn:@"hash"]];
        [asset setMetadataHash:[result stringForColumn:@"metadatahash"]];
        [asset setAssetFileTypeId:[result stringForColumn:@"assetfiletypeid"]];
        [asset setTitle:[result stringForColumn:@"title"]];
        [asset setLocaleId:[result stringForColumn:@"localeid"]];
        [asset setRevisionDate:[result stringForColumn:@"revisiondate"]];
        [asset setSortDate:[NSNumber numberWithInt:[result intForColumn:@"sortdate"]]];
        [asset setThumbnail128:[result stringForColumn:@"thumbnail128"]];
        [asset setUrl:[result stringForColumn:@"url"]];
        
        NSError *error;
        if (![insertContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        count++;
    }
    NSLog(@"Added %d assets", count);

    [database close];
}

- (void)importClosuresToCoreData
{
    NSManagedObjectContext *insertContext = [self insertContext];
    
    FMDatabase *database = [FMDatabase databaseWithPath:[self apiDatabasePath]];
    
    [database open];
    
    FMResultSet *result = [database executeQuery:@"SELECT * FROM closures"];
    NSInteger count = 0;

    while ([result next]) {
        Closure *closure = [NSEntityDescription insertNewObjectForEntityForName:@"Closure" inManagedObjectContext:insertContext];
        
        [closure setAncestor:[result stringForColumn:@"ancestor"]];
        [closure setDescendant:[result stringForColumn:@"descendant"]];
        [closure setDistance:[NSNumber numberWithInt:[result intForColumn:@"distance"]]];
        
        NSError *error;
        if (![insertContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        count++;
    }
    NSLog(@"Added %d closures", count);

    [database close];
}

- (void)importTaxaToCoreData
{
    NSManagedObjectContext *insertContext = [self insertContext];
    
    FMDatabase *database = [FMDatabase databaseWithPath:[self apiDatabasePath]];
    
    [database open];
    
    FMResultSet *result = [database executeQuery:@"SELECT * FROM taxa"];
    NSInteger count = 0;

    while ([result next]) {
        Taxa *taxa = [NSEntityDescription insertNewObjectForEntityForName:@"Taxa" inManagedObjectContext:insertContext];
        
        [taxa setId:[result stringForColumn:@"id"]];
        [taxa setTitle:[result stringForColumn:@"title"]];
        [taxa setTaxonGroupId:[result stringForColumn:@"taxongroupid"]];
        
        NSError *error;
        if (![insertContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        count++;
    }
    NSLog(@"Added %d taxas", count);

    [database close];
}

- (void)addAllTaxa
{
//    NSManagedObjectContext *insertContext = [self insertContext];
//
//    Taxa *taxa = [NSEntityDescription insertNewObjectForEntityForName:@"Taxa" inManagedObjectContext:insertContext];
//    
//    [taxa setId:@"arthrex"];
//    [taxa setTitle:@"All"];
//    [taxa setTaxonGroupId:@"team"];
//    

    for (Taxa *taxa in [self teams]) {
        if ([taxa.title isEqualToString:@"All"]) {
            [[self insertContext] deleteObject:taxa];
        }
    }
    
    NSError *error;
    if (![[self insertContext] save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }

}

- (void)importAssetClassificationsToCoreData
{
    NSManagedObjectContext *insertContext = [self insertContext];
    
    FMDatabase *database = [FMDatabase databaseWithPath:[self apiDatabasePath]];
    
    [database open];
    
    FMResultSet *result = [database executeQuery:@"SELECT * FROM assetclassifications"];
    NSInteger count = 0;

    while ([result next]) {
        AssetClassification *assetClassification = [NSEntityDescription insertNewObjectForEntityForName:@"AssetClassification" inManagedObjectContext:insertContext];
        
        [assetClassification setAssetId:[result stringForColumn:@"assetid"]];
        [assetClassification setTaxonId:[result stringForColumn:@"taxonid"]];
        
        NSError *error;
        if (![insertContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        count++;
    }
    NSLog(@"Added %d asset classifications", count);

    [database close];
}

- (void)importAssetPresentersToCoreData
{
    NSManagedObjectContext *insertContext = [self insertContext];
    
    FMDatabase *database = [FMDatabase databaseWithPath:[self apiDatabasePath]];
    
    [database open];
    
    FMResultSet *result = [database executeQuery:@"SELECT * FROM assetpresenters"];
    NSInteger count = 0;

    while ([result next]) {
        AssetPresenter *assetPresenter = [NSEntityDescription insertNewObjectForEntityForName:@"AssetPresenter" inManagedObjectContext:insertContext];
        
        [assetPresenter setAssetId:[result stringForColumn:@"assetid"]];
        [assetPresenter setPresenterId:[NSNumber numberWithInt:[result intForColumn:@"presenterid"]]];
        
        NSError *error;
        if (![insertContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        count++;
    }
    NSLog(@"Added %d asset presenters", count);

    [database close];
}

- (void)importPresentersToCoreData
{
    NSManagedObjectContext *insertContext = [self insertContext];
    
    FMDatabase *database = [FMDatabase databaseWithPath:[self apiDatabasePath]];
    
    [database open];
    
    FMResultSet *result = [database executeQuery:@"SELECT * FROM presenters"];
    NSInteger count = 0;

    while ([result next]) {
        Presenter *presenter = [NSEntityDescription insertNewObjectForEntityForName:@"Presenter" inManagedObjectContext:insertContext];
        
        [presenter setId:[NSNumber numberWithInt:[result intForColumn:@"id"]]];
        [presenter setFirstName:[result stringForColumn:@"firstname"]];
        [presenter setLastName:[result stringForColumn:@"lastname"]];
        [presenter setSuffix:[result stringForColumn:@"suffix"]];
        [presenter setPrefix:[result stringForColumn:@"prefix"]];
 
        NSError *error;
        if (![insertContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        count++;
    }
    NSLog(@"Added %d presenters", count);

    [database close];
}

- (void)importAssetTypeAssetsToCoreData
{
    NSManagedObjectContext *insertContext = [self insertContext];
    
    FMDatabase *database = [FMDatabase databaseWithPath:[self apiDatabasePath]];
    
    [database open];
    
    FMResultSet *result = [database executeQuery:@"SELECT * FROM assettypeassets"];
    NSInteger count = 0;

    while ([result next]) {
        AssetTypeAsset *assetTypeAsset = [NSEntityDescription insertNewObjectForEntityForName:@"AssetTypeAsset" inManagedObjectContext:insertContext];
        
        [assetTypeAsset setAssetId:[result stringForColumn:@"assetid"]];
        [assetTypeAsset setAssetTypeId:[result stringForColumn:@"assettypeid"]];
        
        NSError *error;
        if (![insertContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        count++;
    }
    NSLog(@"Added %d assetTypeAssets", count);
    [database close];
}

- (void)importLocalesToCoreData
{
    NSManagedObjectContext *insertContext = [self insertContext];
    
    FMDatabase *database = [FMDatabase databaseWithPath:[self apiDatabasePath]];
    
    [database open];
    
    FMResultSet *result = [database executeQuery:@"SELECT * FROM locales"];
    
    NSInteger count = 0;

    while ([result next]) {
        Locale *locale = [NSEntityDescription insertNewObjectForEntityForName:@"Locale" inManagedObjectContext:insertContext];
        
        [locale setId:[result stringForColumn:@"id"]];
        [locale setLabel:[result stringForColumn:@"label"]];
        
        NSError *error;
        if (![insertContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        count++;
    }
    NSLog(@"Added %d locales", count);

    [database close];
}

- (void)importTaxonGroupsToCoreData
{
    NSManagedObjectContext *insertContext = [self insertContext];
    
    FMDatabase *database = [FMDatabase databaseWithPath:[self apiDatabasePath]];
    
    [database open];
    
    FMResultSet *result = [database executeQuery:@"SELECT * FROM taxongroups"];
    NSInteger count = 0;
    while ([result next]) {
        TaxonGroup *taxonGroup = [NSEntityDescription insertNewObjectForEntityForName:@"TaxonGroup" inManagedObjectContext:insertContext];
        
        [taxonGroup setId:[result stringForColumn:@"id"]];
        [taxonGroup setLabel:[result stringForColumn:@"label"]];
                
        NSError *error;
        if (![insertContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        count++;
    }
    
    NSError *error;
    if (![insertContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }

    NSLog(@"Added %d TaxonGroups", count);
    [database close];
}

#pragma mark - private

- (FMDatabase *)appDatabase
{
    BOOL dbExists = [self databaseExists:kAPPDB];
    
    FMDatabase *database = [FMDatabase databaseWithPath:[self localDatabasePathForDbNamed:kAPPDB]];

    if (!dbExists) {
        [database open];
        
        [database executeUpdate:@"CREATE TABLE IF NOT EXISTS assets (id TEXT PRIMARY KEY, hash TEXT, metadatahash TEXT, state TEXT, downloadindex INTEGER, filesize REAL, renditionid TEXT)"];
        
        [database close];
    }
    
    return database;
}


- (NSDictionary *)productGroupsDictionary
{
    static NSDictionary *_productGroupsDictionary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _productGroupsDictionary = @{@"product_category" : @"Product Category",
                                     @"product_family" : @"Product Family",
                                     @"product_group" : @"Product Group"};
    });
    return _productGroupsDictionary;
}

- (NSDictionary *)procedureGroupsDictionary
{
    static NSDictionary *_procedureGroupsDictionary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _procedureGroupsDictionary = @{@"diagnosis" : @"Diagnosis",
                                     @"procedure" : @"Procedure",
                                     @"surgical_technique" : @"Surgical Technique"};
    });
    return _procedureGroupsDictionary;
}

- (NSString *)groupInStringFromDictionary:(NSDictionary *)groups
{
    NSMutableString *groupIn = [[NSMutableString alloc] init];
    
    for (NSString *groupId in groups) {
        if (groupIn.length > 0) {
            [groupIn appendString:@","];
        }
        [groupIn appendString:@"'"];
        [groupIn appendString:groupId];
        [groupIn appendString:@"'"];
    }

    return groupIn;
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)insertContext
{
    static NSManagedObjectContext *_insertContext;
    if (_insertContext != nil) {
        _insertContext.undoManager = nil;
        return _insertContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _insertContext = [[NSManagedObjectContext alloc] init];
        [_insertContext setPersistentStoreCoordinator:coordinator];
        _insertContext.undoManager = nil;
    }
    return _insertContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    static NSManagedObjectModel *_managedObjectModel;
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreDataTest" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    static NSPersistentStoreCoordinator *_persistentStoreCoordinator;
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreDataTest.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSArray *)assetClassifications
{
    return [self fetchEntinityForName:@"AssetClassification"];
}

- (NSArray *)assetPresenters
{
    return [self fetchEntinityForName:@"AssetPresenter"];
}

- (NSArray *)assets
{
    return [self fetchEntinityForName:@"Asset"];
}

- (NSArray *)assetTypeAssets
{
    return [self fetchEntinityForName:@"AssetTypeAsset"];
}

- (NSArray *)assetTypes
{
    return [self fetchEntinityForName:@"AssetType"];
}

- (NSArray *)closures
{
    return [self fetchEntinityForName:@"Closure"];
}

- (NSArray *)countries
{
    return [self fetchEntinityForName:@"Country"];
}

- (NSArray *)locales
{
    return [self fetchEntinityForName:@"Locale"];
}

- (NSArray *)presenters
{
    return [self fetchEntinityForName:@"Presenter"];
}

- (NSArray *)taxas
{
    return [self fetchEntinityForName:@"Taxa"];
}

- (NSArray *)taxonGroups
{
    return [self fetchEntinityForName:@"TaxonGroup"];
}

- (NSArray *)fetchEntinityForName:(NSString *)name
{
    NSError *error;
    NSManagedObjectContext *objectContext = [self insertContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:name
                                              inManagedObjectContext:objectContext];
    [fetchRequest setEntity:entity];
    
    return [objectContext executeFetchRequest:fetchRequest error:&error];
}

- (void)checkAssetPresenters
{
    NSInteger count = 0;
    NSArray *assetClassifications = [self assetClassifications];
    for (AssetClassification *assetClassification in assetClassifications) {
        if (!assetClassification.taxa) {
            count++;
        }
    }
    NSLog(@"%d", count);
}

- (void)linkAssetPresentersToPresenters
{
    NSManagedObjectContext *insertContext = [self insertContext];
    
    NSString *predicateString = [NSString stringWithFormat:@"id == $PRESENTER_ID"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
       
    NSError *error;
        
    NSArray *assetPresenters = [self assetPresenters];
    
    NSInteger found = 0;
    NSInteger notFound = 0;
    
    for (AssetPresenter *assetPresenter in assetPresenters) {
        NSDictionary *variables = @{ @"PRESENTER_ID" : assetPresenter.presenterId };
        NSPredicate *localPredicate = [predicate predicateWithSubstitutionVariables:variables];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Presenter"
                                                  inManagedObjectContext:[self insertContext]];
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:localPredicate];
        
        NSArray *presenters = [insertContext executeFetchRequest:fetchRequest error:&error];
        
        if (presenters.count == 1) {
            assetPresenter.presenter = [presenters objectAtIndex:0];
            found++;
        }
        else {
            notFound++;
        }
        
        if (![insertContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
    NSLog(@"found:%d, didn't find:%d", found, notFound);
}

- (void)linkAssetPresentersToAssets
{
    NSManagedObjectContext *insertContext = [self insertContext];
    
    NSString *predicateString = [NSString stringWithFormat:@"id == $ASSET_ID"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    
    NSError *error;
    
    NSArray *assetPresenters = [self assetPresenters];
    NSInteger found = 0;
    NSInteger notFound = 0;

    for (AssetPresenter *assetPresenter in assetPresenters) {
        NSDictionary *variables = @{ @"ASSET_ID" : assetPresenter.assetId };
        NSPredicate *localPredicate = [predicate predicateWithSubstitutionVariables:variables];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Asset"
                                                  inManagedObjectContext:[self insertContext]];
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:localPredicate];
        
        NSArray *assets = [insertContext executeFetchRequest:fetchRequest error:&error];
        
        if (assets.count == 1) {
            assetPresenter.asset = [assets objectAtIndex:0];
            //NSLog(@"asset found");
            found++;
        }
        else {
            notFound++;
            //NSLog(@"asset presenter %@", assetPresenter.assetId);
        }
        
        if (![insertContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
    NSLog(@"found:%d, didn't find:%d", found, notFound);
}

- (void)linkAssetTypeAssetsToAssetTypes
{
    NSError *error;
    NSManagedObjectContext *insertContext = [self insertContext];
    
    NSString *predicateString = [NSString stringWithFormat:@"id == $ASSET_TYPE_ID"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    
    NSArray *assetTypeAssets = [self assetTypeAssets];
    
    NSInteger found = 0;
    NSInteger notFound = 0;

    for (AssetTypeAsset *assetTypeAsset in assetTypeAssets) {
        NSDictionary *variables = @{ @"ASSET_TYPE_ID" : assetTypeAsset.assetTypeId };
        NSPredicate *localPredicate = [predicate predicateWithSubstitutionVariables:variables];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"AssetType"
                                                  inManagedObjectContext:[self insertContext]];
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:localPredicate];
        
        NSArray *assetTypes = [insertContext executeFetchRequest:fetchRequest error:&error];
        
        if (assetTypes.count == 1) {
            assetTypeAsset.assetType = [assetTypes objectAtIndex:0];
            found++;
        }
        else {
            notFound++;
            //NSLog(@"asset type asset %@", assetTypeAsset.assetId);
        }

        
        if (![insertContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
    NSLog(@"found:%d, didn't find:%d", found, notFound);

}

- (void)linkAssetTypeAssetsToAssets
{
    NSError *error;
    NSManagedObjectContext *insertContext = [self insertContext];
    
    NSString *predicateString = [NSString stringWithFormat:@"id == $ASSET_ID"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    
    NSArray *assetTypeAssets = [self assetTypeAssets];
    
    NSInteger found = 0;
    NSInteger notFound = 0;
    
    for (AssetTypeAsset *assetTypeAsset in assetTypeAssets) {
        NSDictionary *variables = @{ @"ASSET_ID" : assetTypeAsset.assetId };
        NSPredicate *localPredicate = [predicate predicateWithSubstitutionVariables:variables];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Asset"
                                                  inManagedObjectContext:[self insertContext]];
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:localPredicate];
        
        NSArray *assets = [insertContext executeFetchRequest:fetchRequest error:&error];
        
        if (assets.count == 1) {
            assetTypeAsset.asset = [assets objectAtIndex:0];
            found++;
        }
        else {
            notFound++;
            //NSLog(@"asset %@", assetTypeAsset.assetId);
        }
        
        if (![insertContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
    NSLog(@"found:%d, didn't find:%d", found, notFound);
}

- (void)linkAssetClassificationsToAssets
{
    NSError *error;
    NSManagedObjectContext *insertContext = [self insertContext];
    
    NSString *assetPredicateString = [NSString stringWithFormat:@"id == $ASSET_ID"];
    NSPredicate *assetPredicate = [NSPredicate predicateWithFormat:assetPredicateString];
        
    NSArray *assetClassifications = [self assetClassifications];

    NSInteger assetsFound = 0;
    NSInteger assetsNotFound = 0;
        
    for (AssetClassification *assetClassification in assetClassifications) {
        NSDictionary *assetVariables = @{ @"ASSET_ID" : assetClassification.assetId };
        NSPredicate *localAssetPredicate = [assetPredicate predicateWithSubstitutionVariables:assetVariables];
        
        NSFetchRequest *assetFetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *assetEntity = [NSEntityDescription entityForName:@"Asset"
                                                  inManagedObjectContext:insertContext];
        [assetFetchRequest setEntity:assetEntity];
        [assetFetchRequest setPredicate:localAssetPredicate];
        
        NSArray *assets = [insertContext executeFetchRequest:assetFetchRequest error:&error];
        
        if (assets.count == 1) {
            assetClassification.asset = [assets objectAtIndex:0];
            assetsFound++;
        }
        else {
            assetsNotFound++;
            //NSLog(@"asset:%@ asset count:%d", assetClassification.assetId, assets.count);
        }
        
        if (![insertContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
    NSLog(@"assets found:%d, didn't find assets:%d", assetsFound, assetsNotFound);
}

- (void)linkAssetClassificationsToTaxas
{
    NSError *error;
    NSManagedObjectContext *insertContext = [self insertContext];
        
    NSString *taxaPredicateString = [NSString stringWithFormat:@"id == $TAXA_ID"];
    NSPredicate *taxaPredicate = [NSPredicate predicateWithFormat:taxaPredicateString];
    
    NSArray *assetClassifications = [self assetClassifications];
        
    NSInteger taxasFound = 0;
    NSInteger taxasNotFound = 0;
    
    for (AssetClassification *assetClassification in assetClassifications) {
        
        NSDictionary *taxaVariables = @{ @"TAXA_ID" : assetClassification.taxonId };
        NSPredicate *localTaxaPredicate = [taxaPredicate predicateWithSubstitutionVariables:taxaVariables];
        
        NSFetchRequest *taxaFetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *taxaEntity = [NSEntityDescription entityForName:@"Taxa"
                                                      inManagedObjectContext:insertContext];
        [taxaFetchRequest setEntity:taxaEntity];
        [taxaFetchRequest setPredicate:localTaxaPredicate];
        
        NSArray *taxas = [insertContext executeFetchRequest:taxaFetchRequest error:&error];
        
        if (taxas.count == 1) {
            assetClassification.taxa = [taxas objectAtIndex:0];
            taxasFound++;
        }
        else {
            taxasNotFound++;
            //NSLog(@"taxa %@", assetClassification.taxonId);
        }
        
        if (![insertContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
    NSLog(@"taxas found:%d, didn't find taxas:%d", taxasFound, taxasNotFound);
}


- (void)linkClosureAncestors
{
    NSError *error;
    NSManagedObjectContext *insertContext = [self insertContext];
    
    NSString *ancestorPredicateString = [NSString stringWithFormat:@"id == $ANCESTOR_ID"];
    NSPredicate *ancestorPredicate = [NSPredicate predicateWithFormat:ancestorPredicateString];
    
    NSArray *closures = [self closures];
        
    NSInteger ancestorsFound = 0;
    NSInteger ancestorsNotFound = 0;
    
    for (Closure *closure in closures) {
        
        NSDictionary *ancestorVariables = @{ @"ANCESTOR_ID" : closure.ancestor };
        NSPredicate *localAncestorPredicate = [ancestorPredicate predicateWithSubstitutionVariables:ancestorVariables];
        
        NSFetchRequest *ancestorFetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *ancestorEntity = [NSEntityDescription entityForName:@"Taxa"
                                                       inManagedObjectContext:insertContext];
        [ancestorFetchRequest setEntity:ancestorEntity];
        [ancestorFetchRequest setPredicate:localAncestorPredicate];
        
        NSArray *ancestorTaxas = [insertContext executeFetchRequest:ancestorFetchRequest error:&error];
        
        if ([closure.ancestor isEqualToString:@"arthrex"]) {
            if (ancestorTaxas.count == 1) {
                NSLog(@"found arthrex:");
            }
            else {
                NSLog(@"didn't find arthrex:%d", ancestorTaxas.count);
            }
        }
        if (ancestorTaxas.count == 1) {
            closure.taxaAncestor = [ancestorTaxas objectAtIndex:0];
            ancestorsFound++;
        }
        else {
            ancestorsNotFound++;
           // NSLog(@"ancestor:%@", closure.ancestor);
        }
        
        if (![insertContext save:&error]) {
            //NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
   // NSLog(@"found:%d, didn't find ancestors:%d", ancestorsFound, ancestorsNotFound);
}

- (void)linkClosureDescendants
{
    NSError *error;
    NSManagedObjectContext *insertContext = [self insertContext];
        
    NSString *descendantPredicateString = [NSString stringWithFormat:@"id == $DESCENDANT_ID"];
    NSPredicate *descendantPredicate = [NSPredicate predicateWithFormat:descendantPredicateString];
    
    NSArray *closures = [self closures];
    
    NSInteger descendantsFound = 0;
    NSInteger descendantsNotFound = 0;
    
    for (Closure *closure in closures) {
        
        NSDictionary *descendantsVariables = @{ @"DESCENDANT_ID" : closure.descendant };
        NSPredicate *localDescendantPredicate = [descendantPredicate predicateWithSubstitutionVariables:descendantsVariables];
        
        NSFetchRequest *descendantFetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *descendantEntity = [NSEntityDescription entityForName:@"Taxa"
                                                            inManagedObjectContext:insertContext];
        [descendantFetchRequest setEntity:descendantEntity];
        [descendantFetchRequest setPredicate:localDescendantPredicate];
        
        NSArray *descendantTaxas = [insertContext executeFetchRequest:descendantFetchRequest error:&error];
                
        if (descendantTaxas.count == 1) {
            closure.taxaDescendant = [descendantTaxas objectAtIndex:0];
            descendantsFound++;
        }
        else {
            descendantsNotFound++;
            //NSLog(@"taxa %@", assetClassification.taxonId);
        }
        
        if (![insertContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
    NSLog(@"descendants found:%d, didn't find descendants:%d", descendantsFound, descendantsNotFound);
}

-(void)deleteAndRecreateStore
{
    NSPersistentStore * store = [[self.persistentStoreCoordinator persistentStores] lastObject];
    NSError * error;
    [self.persistentStoreCoordinator removePersistentStore:store error:&error];
    [[NSFileManager defaultManager] removeItemAtURL:[store URL] error:&error];
    [self insertContext];
}



@end