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
- (IBAction)themeChanged:(UISegmentedControl *)sender;
- (IBAction)customEditingChanged:(UITextField *)sender;
- (IBAction)minimumEditingChanged:(UITextField *)sender;
- (IBAction)maximumEditingChanged:(UITextField *)sender;

- (void) updateViewFromModel;
- (void) updateModelFromView;
- (void) updateRegionFromNotification:(NSNotification *)obj;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"Settings View is Loaded");
    
    // used for update region when region table view controller closes
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateRegionFromNotification:)
                                                 name:@"update_region" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"Settings view will appear");
    
    [self updateViewFromModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initModelWithMinimum:(NSString *)minimum
                       custom:(NSString *)custom
                      maximum:(NSString *)maximum
                        theme:(NSString *)theme
                       region:(NSString *)region {
    if (self.tipSettingModel == nil) {
        self.tipSettingModel = [[TipSettingModel alloc] init];
    }
    
    self.tipSettingModel.minimum = minimum;
    self.tipSettingModel.custom = custom;
    self.tipSettingModel.maximum = maximum;
    self.tipSettingModel.theme = theme;
    self.tipSettingModel.region = region;
}

- (IBAction)onTap:(UITapGestureRecognizer *)sender {
    NSLog(@"Settings View onTap is called");
    
    [self updateModelFromView];
    
    [self.view endEditing:YES];
}

- (void) updateViewFromModel {
    // percentage text fields
    self.minimumTextField.text = self.tipSettingModel.minimum;
    self.customTextField.text = self.tipSettingModel.custom;
    self.maximumTextField.text = self.tipSettingModel.maximum;
    
    // theme
    if ([self.tipSettingModel.theme isEqualToString:@"Light"]) {
        [self.themeControl setSelectedSegmentIndex:0];
    } else {
        [self.themeControl setSelectedSegmentIndex:1];
    }
    
    // region
    self.regionLabel.text = self.tipSettingModel.region;
}

- (void) updateModelFromView {
    self.tipSettingModel.minimum = self.minimumTextField.text;
    self.tipSettingModel.custom = self.customTextField.text;
    self.tipSettingModel.maximum = self.maximumTextField.text;
    
    self.tipSettingModel.theme = [self.themeControl titleForSegmentAtIndex:self.themeControl.selectedSegmentIndex];
    self.tipSettingModel.region = self.regionLabel.text;
}

- (void) willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    
    if (!parent){
        NSLog(@"SettingViewController will be popped off the stack.");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"update_setting" object:self.tipSettingModel];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"SettingViewController prepareForSegue is called");
    
    if ([segue.identifier isEqualToString:@"showRegion"]) {
        NSLog(@"showSetting Seg is called");
        
        RegionTableViewController *destViewController = segue.destinationViewController;
        destViewController.selectedRegion = self.tipSettingModel.region;
    }
}

- (void) updateRegionFromNotification:(NSNotification *)obj{
    NSString *sharedData=(NSString *) [obj object];
    
    self.tipSettingModel.region = sharedData;
    self.regionLabel.text = self.tipSettingModel.region;
}

- (IBAction)themeChanged:(UISegmentedControl *)sender {
    NSLog(@"SettingViewController themeChanged");
    self.tipSettingModel.theme = [self.themeControl titleForSegmentAtIndex:self.themeControl.selectedSegmentIndex];
}

- (IBAction)customEditingChanged:(UITextField *)sender {
    NSLog(@"SettingViewController customEditingChanged");
    self.tipSettingModel.custom = self.customTextField.text;
}

- (IBAction)minimumEditingChanged:(UITextField *)sender {
    NSLog(@"SettingViewController minimumEditingChanged");
    self.tipSettingModel.minimum = self.minimumTextField.text;
}

- (IBAction)maximumEditingChanged:(UITextField *)sender {
    NSLog(@"SettingViewController maximumEditingChanged");
    self.tipSettingModel.maximum = self.maximumTextField.text;
}

@end
