//
//  SpecialtyChildViewController.h
//  ArthrexKit
//
//  Created by Matthew Krueger on 7/29/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Taxa;

@interface TeamChildViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

- (id)initWithTeam:(Taxa *)Taxa;

@property (weak, nonatomic) IBOutlet UIView *tableViewHeader;

@property (weak, nonatomic) IBOutlet UISegmentedControl *scopeBar;

- (IBAction)scopebarValueChanged:(id)sender;

@end
