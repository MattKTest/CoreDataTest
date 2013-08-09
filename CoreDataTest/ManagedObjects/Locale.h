//
//  Locale.h
//  CoreDataTest
//
//  Created by Matthew Krueger on 8/5/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Locale : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * label;

@end
