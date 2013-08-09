//
//  Asset.m
//  ArthrexKit
//
//  Created by Matthew Krueger on 7/30/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import "AKAsset.h"
#import <FMDatabase.h>

@implementation AKAsset

- (id)initWithFMResult:(FMResultSet *)result
{
    self = [super init];
    if (self) {
        self.Id = [result stringForColumn:@"id"];
        self.title = [result stringForColumn:@"title"];
        self.thumbnailURL = [result stringForColumn:@"thumbnail128"];
        self.assettypes = [result stringForColumn:@"assettypes"];
        self.language = [self languageForLocaleId:[result stringForColumn:@"localeid"]];
        self.literatureNumber = [result stringForColumn:@"literaturenumber"];
        self.revisionDate = [result stringForColumn:@"revisiondate"];
        self.url = [result stringForColumn:@"url"];
        self.type = [self assetTypeFromString:[result stringForColumn:@"assetfiletypeid"]];
    }
    return self;
}

- (NSString *)languageForLocaleId:(NSString *)localeId
{
    NSString *language;
    if ([localeId isEqualToString:localeId]) {
        language = @"English";
    }
    return language;
}

- (AKAssetType)assetTypeFromString:(NSString *)type
{
    AKAssetType assetType = AssetTypeUnknown;
    if ([type isEqualToString:@"pdf"]) {
        assetType = AssetTypePDF;
    }
    else if ([type isEqualToString:@"vid"]) {
        assetType = AssetTypeVideo;
    }
    else if ([type isEqualToString:@"aud"]) {
        assetType = AssetTypeAudio;
    }
    else if ([type isEqualToString:@"doc"]) {
        assetType = AssetTypeDocument;
    }
    else if ([type isEqualToString:@"xls"]) {
        assetType = AssetTypeSpreadSheet;
    }
    else if ([type isEqualToString:@"ppt"]) {
        assetType = AssetTypePowerPoint;
    }
    else if ([type isEqualToString:@"zip"]) {
        assetType = AssetTypeZip;
    }
    else if ([type isEqualToString:@"ebk"]) {
        assetType = AssetTypeiBook;
    }
    
    return assetType;
}

@end
