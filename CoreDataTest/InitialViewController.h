//
//  InitialViewController.h
//  CoreDataTest
//
//  Created by Matthew Krueger on 8/5/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InitialViewController : UIViewController

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

- (IBAction)download:(id)sender;
- (IBAction)import:(id)sender;
- (IBAction)read:(id)sender;
- (IBAction)teams:(id)sender;

@end
