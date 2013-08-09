//
//  ResourceListViewController.m
//  ArthrexKit
//
//  Created by Matthew Krueger on 7/30/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import "AssetListViewController.h"
#import "DatabaseManager.h"
#import <UIImageView+AFNetworking.h>
#import "AKAsset.h"
#import "AKFileWebViewController.h"
#import "AKMoviePlayerViewController.h"
#import "Taxa.h"
#import "AssetClassification.h"
#import "Asset.h"
#import "Closure.h"

@interface AssetListViewController ()

@property (nonatomic) NSArray *assets;

@property (nonatomic) UIDocumentInteractionController *documentController;

@property (nonatomic, strong) AKMoviePlayerViewController *moviePlayerController;

@property (nonatomic, strong) AKFileWebViewController *fileViewController;

@property (nonatomic) NSMutableArray *searchResults;

@end

@implementation AssetListViewController

- (id)initWithTeam:(Taxa *)taxa
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    self = [storyboard instantiateViewControllerWithIdentifier:@"AssetListViewController"];
    
    if (self) {
        // we want to continue without waiting for our assets query to complete
        self.navigationItem.title = taxa.title;
        
        NSDate *start = [NSDate date];
        self.assets = taxa.assetArray;
        NSLog(@"%f", [start timeIntervalSinceNow]);

        NSLog(@"%d", self.assets.count);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*NSInteger rowCount = 0;
    if (tableView == self.tableView) {
        rowCount = MAX(self.assets.count, 1);
    }
    else if (tableView == self.searchDisplayController.searchResultsTableView) {
        rowCount = self.searchResults.count;
    }
    return rowCount;*/
    NSLog(@"Asset count = %d", self.assets.count);
    return self.assets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *LoadingCell = @"Cell";

    UITableViewCell *cell;
    
//    if (tableView == self.tableView) {
//        if (self.assets.count > indexPath.row) {
//            cell = [self cellForAsset:[self.assets objectAtIndex:indexPath.row]];
//        }
//        else {
//            cell = [tableView dequeueReusableCellWithIdentifier:LoadingCell forIndexPath:indexPath];
//            [(UIActivityIndicatorView *)[cell viewWithTag:101] startAnimating];
//        }
//    }
//    else if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell = [self cellForAsset:[self.assets objectAtIndex:indexPath.row]];
//    }
    return cell;
}

- (UITableViewCell *)cellForAsset:(Asset *)asset
{
    static NSString *ResourceCell = @"Cell";

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ResourceCell];
    [(UIImageView *)[cell viewWithTag:100] setImageWithURL:[NSURL URLWithString:asset.thumbnail128]];
    [(UILabel *)[cell viewWithTag:101] setText:asset.title];
    //[(UILabel *)[cell viewWithTag:102] setText:asset.assettypes];
    //[(UILabel *)[cell viewWithTag:103] setText:asset.language];
    [(UILabel *)[cell viewWithTag:104] setText:asset.literatureNumber];
    [(UILabel *)[cell viewWithTag:105] setText:asset.revisionDate];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AKAsset *asset;
    
    if (tableView == self.tableView) {
        if (self.assets.count > indexPath.row) {
            asset = [self.assets objectAtIndex:indexPath.row];
        }
    }
    else if (tableView == self.searchDisplayController.searchResultsTableView) {
        if (self.searchResults.count > indexPath.row) {
            asset = [self.searchResults objectAtIndex:indexPath.row];
        }
    }
    
    if (asset) {
        if (asset.type == AssetTypePDF ||
            asset.type == AssetTypeDocument ||
            asset.type == AssetTypePowerPoint ||
            asset.type == AssetTypeSpreadSheet) {
            
            self.fileViewController = [[AKFileWebViewController alloc] initWithAsset:asset];
            [self.navigationController pushViewController:self.fileViewController animated:YES];
        }
        else if (asset.type == AssetTypeVideo) {
            self.moviePlayerController.asset = asset;
            [self.navigationController pushViewController:self.moviePlayerController animated:YES];
        }
    }
}

- (AKMoviePlayerViewController *)moviePlayerController
{
    if (!_moviePlayerController) {
        _moviePlayerController = [[AKMoviePlayerViewController alloc] init];
    }
    return _moviePlayerController;
}

#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self.searchResults removeAllObjects];
        
    for (AKAsset *asset in self.assets) {
        NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
        NSRange titleNameRange = NSMakeRange(0, asset.title.length);
        NSRange foundRange = [asset.title rangeOfString:searchString options:searchOptions range:titleNameRange];
        if (foundRange.length > 0) {
            [self.searchResults addObject:asset];
        }
    }
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
 }

@end
