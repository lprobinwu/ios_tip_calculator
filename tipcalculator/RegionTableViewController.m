//
//  RegionTableViewController.m
//  tipcalculator
//
//  Created by Robin Wu on 10/3/15.
//  Copyright © 2015 Robin Wu. All rights reserved.
//

#import "RegionTableViewController.h"

@interface RegionTableViewController ()

@end

@implementation RegionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.regions = @[@"United States", @"Canada", @"United Kingdom", @"Germany"];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"Region table view will appear");
    
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.regions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    NSString *region = [self.regions objectAtIndex:indexPath.row];
    cell.textLabel.text = region;
    
    if ([region isEqualToString:self.selectedRegion]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.lastSelectedIndex = indexPath;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.lastSelectedIndex) {
        UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:self.lastSelectedIndex];
        [lastCell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    
    self.lastSelectedIndex = indexPath;
    self.selectedRegion = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}

- (void) willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    
    if (!parent){
        NSLog(@"Region Table View Controller will be popped off the stack.");
        // Implement your save or any other code... shouldn't be async/long tasks
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"update_region" object:self.selectedRegion];
    }
}

@end
