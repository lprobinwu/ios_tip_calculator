//
//  SettingViewController.m
//  tipcalculator
//
//  Created by Robin Wu on 9/23/15.
//  Copyright (c) 2015 Robin Wu. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()
- (IBAction)onTap:(UITapGestureRecognizer *)sender;
- (void) initializeTextFields;
- (void) updateValues;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"Settings View is Loaded");
    
    [self initializeTextFields];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"Settings view will appear");
    
    [self.minimumTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTap:(UITapGestureRecognizer *)sender {
    NSLog(@"Settings View onTap is called");
    
    [self updateValues];
}

- (void) initializeTextFields {
    self.minimumTextField.text = self.minimum;
    self.customTextField.text = self.custom;
    self.maximumTextField.text = self.maximum;
}

- (void) updateValues {
    self.minimum = self.minimumTextField.text;
    self.custom = self.customTextField.text;
    self.maximum = self.maximumTextField.text;
}

- (void) willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    
    if (!parent){
        NSLog(@"SettingViewController will be popped off the stack.");
        // Implement your save or any other code... shouldn't be async/long tasks
        
        // Use NSNotificationCenter to send the percentage data to TipViewController
        NSArray *sharedPercentages = @[self.minimum, self.custom, self.maximum];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"update_percentage" object:sharedPercentages];
    }
}

@end
