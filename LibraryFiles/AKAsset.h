//
//  Asset.h
//  ArthrexKit
//
//  Created by Matthew Krueger on 7/30/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import "AKObjectFromFMResult.h"
#import <Foundation/Foundation.h>

typedef enum {
    AssetTypeAudio,
    AssetTypeDocument,
    AssetTypeiBook,
    AssetTypePDF,
    AssetTypePowerPoint,
    AssetTypeSpreadSheet,
    AssetTypeVideo,
    AssetTypeZip,
    AssetTypeUnknown
} AKAssetType;

@interface AKAsset : NSObject <AKObjectFromFMResult>

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *thumbnailURL;
@property (nonatomic) AKAssetType type;
@property (nonatomic, strong) NSString *assettypes;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSString *literatureNumber;
@property (nonatomic, strong) NSString *revisionDate;
@property (nonatomic, strong) NSString *url;


@end
