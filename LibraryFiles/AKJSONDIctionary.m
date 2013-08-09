//
//  AKJSONDictionary.m
//  ArthrexKit
//
//  Created by Matthew Krueger on 7/31/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import "AKJSONDictionary.h"

@implementation NSDictionary (AKJSONDictionary)

// in case of [NSNull null] values a nil is returned ...
- (id)objectForKeyNotNull:(id)key
{
    id object = [self objectForKey:key];
    if (object == [NSNull null])
        return nil;
    
    return object;
}

- (NSArray *)arrayForKey:(id)key
{
    NSArray *array = nil;
    id obj = [self objectForKeyNotNull:key];
    if ([obj isKindOfClass:[NSArray class]]) {
        array = obj;
    }
    return array;
}

- (NSString *)stringForKey:(id)key
{
    NSString *string = nil;
    id obj = [self objectForKeyNotNull:key];
    if ([obj isKindOfClass:[NSString class]]) {
        string = obj;
    }
    return string;
}

- (NSNumber *)numberForKey:(id)key
{
    NSNumber *number = nil;
    id obj = [self objectForKeyNotNull:key];
    if ([obj isKindOfClass:[NSNumber class]]) {
        number = obj;
    }
    return number;
}

- (NSDictionary *)dictionaryForKey:(id)key
{
    NSDictionary *dictionary = nil;
    id obj = [self objectForKeyNotNull:key];
    if ([obj isKindOfClass:[NSDictionary class]]) {
        dictionary = obj;
    }
    return dictionary;
}

@end
