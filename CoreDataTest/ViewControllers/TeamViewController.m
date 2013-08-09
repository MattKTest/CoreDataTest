//
//  SpecialtViewController.m
//  ArthrexKit
//
//  Created by Matthew Krueger on 7/26/13.
//  Copyright (c) 2013 Arthrex. All rights reserved.
//

#import "TeamViewController.h"
#import "DatabaseManager.h"
#import "TeamChildViewController.h"
#import "AssetListViewController.h"
#import "Taxa.h"

@interface TeamViewController ()

@property (nonatomic, strong) NSArray *teams;

@end

@implementation TeamViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.teams = [[self databaseManager] teams];
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
    //[self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setTitle:@"Specialties"];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Splty"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:nil
                                                                            action:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)leftBarButtonTouch
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToggleBottomViewVisibility" object:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.teams.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Taxa *team = (Taxa *)[self.teams objectAtIndex:indexPath.row];
    [cell.textLabel setText:team.title];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.teams.count > indexPath.row) {
        Taxa *taxa = [self.teams objectAtIndex:indexPath.row];
        UIViewController *nextViewController;
        if ([taxa.id isEqualToString:@"arthrex"]) {
            nextViewController = [[AssetListViewController alloc] initWithTeam:taxa];
        }
        else {
            nextViewController = [[TeamChildViewController alloc] initWithTeam:taxa];
        }
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
}

@end
