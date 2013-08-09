//
//  ReadFromFMResult.h
//  ArthrexKit
//
//  Created by Matthew Krueger on 7/29/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>

@protocol AKObjectFromFMResult <NSObject>

- (id)initWithFMResult:(FMResultSet *)result;

@end
