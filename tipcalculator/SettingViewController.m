//
//  SettingViewController.m
//  tipcalculator
//
//  Created by Robin Wu on 9/23/15.
//  Copyright (c) 2015 Robin Wu. All rights reserved.
//

#import "SettingViewController.h"
#import "RegionTableViewController.h"

@interface SettingViewController ()
- (IBAction)onTap:(UITapGestureRecognizer *)sender;
- (void) initializeTextFields;
- (void) updateValues;
- (void) updateRegionData:(NSNotification *)obj;
- (IBAction)themeChanged:(UISegmentedControl *)sender;
- (IBAction)customEditingChanged:(UITextField *)sender;
- (IBAction)minimumEditingChanged:(UITextField *)sender;
- (IBAction)maximumEditingChanged:(UITextField *)sender;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"Settings View is Loaded");
    
    // used for update region when region table view controller closes
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateRegionData:)
                                                 name:@"update_region" object:nil];

    [self initializeTextFields];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"Settings view will appear");
    
//    [self.minimumTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTap:(UITapGestureRecognizer *)sender {
    NSLog(@"Settings View onTap is called");
    
    [self updateValues];
    
    [self.view endEditing:YES];
}

- (void) initializeTextFields {
    self.minimumTextField.text = self.minimum;
    self.customTextField.text = self.custom;
    self.maximumTextField.text = self.maximum;
    
    // theme
    if ([self.theme isEqualToString:@"Light"]) {
        [self.themeControl setSelectedSegmentIndex:0];
    } else {
        [self.themeControl setSelectedSegmentIndex:1];
    }
    
    // region
    self.regionLabel.text = self.region;
    
}

- (void) updateValues {
    self.minimum = self.minimumTextField.text;
    self.custom = self.customTextField.text;
    self.maximum = self.maximumTextField.text;
    
    self.theme = [self.themeControl titleForSegmentAtIndex:self.themeControl.selectedSegmentIndex];
    self.region = self.regionLabel.text;
}

- (void) willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    
    if (!parent){
        NSLog(@"SettingViewController will be popped off the stack.");
        // Implement your save or any other code... shouldn't be async/long tasks
        
        // Use NSNotificationCenter to send the percentage data to TipViewController
        NSArray *sharedPercentages = @[self.minimum, self.custom, self.maximum, self.theme, self.region];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"update_percentage" object:sharedPercentages];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"SettingViewController prepareForSegue is called");
    
    if ([segue.identifier isEqualToString:@"showRegion"]) {
        NSLog(@"showSetting Seg is called");
        
        RegionTableViewController *destViewController = segue.destinationViewController;
        destViewController.selectedRegion = self.region;
    }
}

- (void) updateRegionData:(NSNotification *)obj{
    NSString *sharedData=(NSString *) [obj object];
    
    self.region = sharedData;
    self.regionLabel.text = sharedData;
}

- (IBAction)themeChanged:(UISegmentedControl *)sender {
    NSLog(@"SettingViewController themeChanged");
    self.theme = [self.themeControl titleForSegmentAtIndex:self.themeControl.selectedSegmentIndex];
}

- (IBAction)customEditingChanged:(UITextField *)sender {
    NSLog(@"SettingViewController customEditingChanged");
    self.custom = self.customTextField.text;
}

- (IBAction)minimumEditingChanged:(UITextField *)sender {
    NSLog(@"SettingViewController minimumEditingChanged");
    self.minimum = self.minimumTextField.text;
}

- (IBAction)maximumEditingChanged:(UITextField *)sender {
    NSLog(@"SettingViewController maximumEditingChanged");
    self.maximum = self.maximumTextField.text;
}


//#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 3;
//}

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
