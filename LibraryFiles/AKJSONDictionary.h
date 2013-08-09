//
//  AKJSONDictionary.h
//  ArthrexKit
//
//  Created by Matthew Krueger on 7/31/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (AKJSONDictionary)

- (id)objectForKeyNotNull:(id)key;
- (NSArray *)arrayForKey:(id)key;
- (NSString *)stringForKey:(id)key;
- (NSNumber *)numberForKey:(id)key;
- (NSDictionary *)dictionaryForKey:(id)key;


@end
