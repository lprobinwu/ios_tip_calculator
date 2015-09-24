//
//  TipViewController.m
//  tipcalculator
//
//  Created by Robin Wu on 9/22/15.
//  Copyright (c) 2015 Robin Wu. All rights reserved.
//

#import "TipViewController.h"
#import "SettingViewController.h"

@interface TipViewController ()
@property (weak, nonatomic) IBOutlet UITextField *billTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;

- (IBAction)onTap:(UITapGestureRecognizer *)sender;
- (void) updateValues;
- (void) updateSegmentedControl;
- (float) getTipPercentage;

@end

@implementation TipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"Tip View is Loaded");
    
    self.minimum = @"10";
    self.custom = @"15";
    self.maximum = @"20";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateSegmentedControl:)
                                                 name:@"update_percentage" object:nil];
    
    [self updateSegmentedControl];
    [self updateValues];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTap:(UITapGestureRecognizer *)sender {

    NSLog(@"onTap is called");
    [self.view endEditing:YES];
    [self updateValues];
}

- (void) updateSegmentedControl {
    [self.tipControl setTitle:[self.minimum stringByAppendingString:@"%"] forSegmentAtIndex:0];
    [self.tipControl setTitle:[self.custom stringByAppendingString:@"%"] forSegmentAtIndex:1];
    [self.tipControl setTitle:[self.maximum stringByAppendingString:@"%"] forSegmentAtIndex:2];
}

- (void) updateValues {
    float billAmount = [self.billTextField.text floatValue];
    
    float tipAmount = billAmount * [self getTipPercentage];
    
    float totalAmount = billAmount + tipAmount;
    
    self.tipLabel.text = [NSString stringWithFormat:@"$%0.2f", tipAmount];
    self.totalLabel.text = [NSString stringWithFormat:@"$%0.2f", totalAmount];
}

- (float) getTipPercentage {
    if (self.tipControl.selectedSegmentIndex == 0) {
        return [self.minimum floatValue] / 100;
    } else if (self.tipControl.selectedSegmentIndex == 1) {
        return [self.custom floatValue] / 100;
    } else {
        return [self.maximum floatValue] / 100;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prepareForSegue is called");
    
    if ([segue.identifier isEqualToString:@"showSettings"]) {
        NSLog(@"showSetting Seg is called");

        SettingViewController *destViewController = segue.destinationViewController;

        destViewController.minimum = self.minimum;
        destViewController.custom = self.custom;
        destViewController.maximum = self.maximum;
    }
}

- (void) updateSegmentedControl:(NSNotification *) obj{
    NSArray *sharedData=(NSArray *) [obj object];
    
    self.minimum = sharedData[0];
    self.custom = sharedData[1];
    self.maximum = sharedData[2];
    
    [self updateSegmentedControl];
    [self updateValues];
}

@end
