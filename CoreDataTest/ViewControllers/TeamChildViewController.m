//
//  SpecialtyChildViewController.m
//  ArthrexKit
//
//  Created by Matthew Krueger on 7/29/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import "TeamChildViewController.h"
#import "DatabaseManager.h"
#import "AssetListViewController.h"
#import "Taxa.h"
#import "Closure.h"

@interface TeamChildViewController ()

@property (nonatomic) NSArray *productTaxonGroups;
@property (nonatomic) NSArray *procedureTaxonGroups;
@property (nonatomic) NSMutableArray *searchResults;

@end

@implementation TeamChildViewController

- (id)initWithTeam:(Taxa *)taxa
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    self = [storyboard instantiateViewControllerWithIdentifier:@"TeamChildViewController"];
    if (self) {
        self.productTaxonGroups = [taxa productGroups];
        self.procedureTaxonGroups = [taxa.closureDescendants allObjects];
    }
    return self;
}

- (DatabaseManager *)databaseManager
{
    static DatabaseManager *_databaseManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _databaseManager = [[DatabaseManager alloc] init];
    });
    return _databaseManager;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    BOOL procedureExists = NO;
//    
//    for (TaxonGroup *group in self.procedureTaxonGroups) {
//        if (group.teamChildren.count > 0) {
//            procedureExists = YES;
//            break;
//        }
//    }
//    
//    if (procedureExists) {
//        self.scopeBar.segmentedControlStyle = 7;
//    }
//    else {
//        [self hideScopebar];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
//    TeamChild *teamChild;
//    
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
//        teamChild = [self.searchResults objectAtIndex:indexPath.row];
//    }
//    else if (self.scopeBar.selectedSegmentIndex == 0) {
//        teamChild = [[[self.procedureTaxonGroups objectAtIndex:indexPath.section] teamChildren] objectAtIndex:indexPath.row];
//    }
//    else if (self.scopeBar.selectedSegmentIndex == 1) {
//        teamChild = [[[self.productTaxonGroups objectAtIndex:indexPath.section] teamChildren] objectAtIndex:indexPath.row];
//    }
//    
//    CGFloat rowHeight = [teamChild.title sizeWithFont:[UIFont systemFontOfSize:17]
//                                    constrainedToSize:CGSizeMake(self.view.frame.size.width - 60, CGFLOAT_MAX)
//                                        lineBreakMode:NSLineBreakByWordWrapping].height + 23;
//    
//    return MAX(rowHeight, 44);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
//    NSInteger sectionCount = 1;
//    if (tableView == self.tableView) {
//        if (self.scopeBar.selectedSegmentIndex == 0) {
//            sectionCount = self.procedureTaxonGroups.count;
//        }
//        else {
//            sectionCount = self.productTaxonGroups.count;
//        }
//    }
//    return sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSInteger rowCount = 0;
//    
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
//        rowCount = self.searchResults.count;
//    }
//	else if (self.scopeBar.selectedSegmentIndex == 0) {
//        rowCount = [(TaxonGroup *)[self.procedureTaxonGroups objectAtIndex:section] teamChildren].count;
//    }
//    else if (self.scopeBar.selectedSegmentIndex == 1) {
//        rowCount = [(TaxonGroup *)[self.productTaxonGroups objectAtIndex:section] teamChildren].count;
//    }
//
//    return rowCount;
    NSLog(@"%d", self.productTaxonGroups.count);
    return self.productTaxonGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Closure *closure = [self.productTaxonGroups objectAtIndex:indexPath.row];
    [cell.textLabel setText:closure.taxaDescendant.title];
//    TeamChild *child;
//    
//	if (tableView == self.searchDisplayController.searchResultsTableView) {
//        child = [self.searchResults objectAtIndex:indexPath.row];
//    }
//    else if (self.scopeBar.selectedSegmentIndex == 0) {
//        child = [[(TaxonGroup *)[self.procedureTaxonGroups objectAtIndex:indexPath.section] teamChildren] objectAtIndex:indexPath.row];
//    }
//    else if (self.scopeBar.selectedSegmentIndex == 1) {
//        child = [[(TaxonGroup *)[self.productTaxonGroups objectAtIndex:indexPath.section] teamChildren] objectAtIndex:indexPath.row];
//    }
//
//    [(UILabel *)[cell viewWithTag:101] setText:child.title];    
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSString *title = nil;
//    if (tableView == self.tableView) {
//        if (self.scopeBar.selectedSegmentIndex == 0) {
//            title = [(TaxonGroup *)[self.procedureTaxonGroups objectAtIndex:section] title];
//        }
//        else if (self.scopeBar.selectedSegmentIndex == 1) {
//            title = [(TaxonGroup *)[self.productTaxonGroups objectAtIndex:section] title];
//        }
//    }
//    
//    return title;
//}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    TeamChild *teamChild;
//    if (tableView == self.tableView) {
//        if (self.scopeBar.selectedSegmentIndex == 0) {
//            teamChild = [[[self.procedureTaxonGroups objectAtIndex:indexPath.section] teamChildren] objectAtIndex:indexPath.row];
//        }
//        else if (self.scopeBar.selectedSegmentIndex == 1) {
//            teamChild = [[[self.productTaxonGroups objectAtIndex:indexPath.section] teamChildren] objectAtIndex:indexPath.row];
//        }
//    }
//    else if (tableView == self.searchDisplayController.searchResultsTableView) {
//        teamChild = [self.searchResults objectAtIndex:indexPath.row];
//    }
//    
//    if (teamChild) {
    
    Closure *closure = [self.productTaxonGroups objectAtIndex:indexPath.row];
    AssetListViewController *assetListViewController = [[AssetListViewController alloc] initWithTeam:closure.taxaDescendant];
    [self.navigationController pushViewController:assetListViewController animated:YES];
    
//    }
}

#pragma mark - UISearchDisplayController Delegate Methods

//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
//{    
//    [self.searchResults removeAllObjects]; 
//    
//    NSArray *taxonGroups = self.scopeBar.selectedSegmentIndex == 0 ? self.procedureTaxonGroups : self.productTaxonGroups;
//    
//    for (TaxonGroup *group in taxonGroups) {
//        for (TeamChild *child in group.teamChildren) {
//            NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
//            NSRange titleNameRange = NSMakeRange(0, child.title.length);
//            NSRange foundRange = [child.title rangeOfString:searchString options:searchOptions range:titleNameRange];
//            if (foundRange.length > 0) {
//                [self.searchResults addObject:child];
//            }
//        }
//    }
//    
//    // Return YES to cause the search result table view to be reloaded.
//    return YES;
//}

#pragma mark - scope bar

- (IBAction)scopebarValueChanged:(id)sender
{
    [self.tableView reloadData];
}

- (void)hideScopebar
{
    self.scopeBar.hidden = YES;
    
    CGRect frame = self.searchDisplayController.searchBar.frame;
    frame.origin.y = 0;
    self.searchDisplayController.searchBar.frame = frame;
    
    frame = self.tableViewHeader.frame;
    frame.size.height = 44;
    self.tableViewHeader.frame = frame;
}

@end
