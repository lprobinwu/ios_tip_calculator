//
//  TipViewController.m
//  tipcalculator
//
//  Created by Robin Wu on 9/22/15.
//  Copyright (c) 2015 Robin Wu. All rights reserved.
//

#import "TipViewController.h"
#import "SettingViewController.h"
#import "AppDelegate.h"

@interface TipViewController ()

@property (weak, nonatomic) IBOutlet UITextField *billTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;

@property (nonatomic) NSUserDefaults *userDefaults;

- (IBAction)onTap:(UITapGestureRecognizer *)sender;
- (void) setLastValues;
- (void) updateValues;
- (void) updateSegmentedControl;
- (float) getTipPercentage;

@end

@implementation TipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"Tip View is Loaded");
    
    // Load Settings
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    [self initUserDefaultsIfNotExists];
    
    [self setLastValues];
    
    self.billTextField.text = self.billAmountInString;

    [self updateValues];
    
    // used for update percentages when settings view controller closes
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateSegmentedControl:)
                                                 name:@"update_percentage" object:nil];
    
    // register this Tip View Controller to App Delegate
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate registerViewController:@"tip_view_controller" controller:self];

}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"Tip view will appear");
    
    [self.billTextField becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"Tip view did appear");
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"Tip view will disappear");
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"Tip view did disappear");
}

- (void) initUserDefaultsIfNotExists {
    if ([self.userDefaults stringForKey:@"minimumPercentDefault"] == nil) {
        [self.userDefaults setObject:@"10" forKey:@"minimumPercentDefault"];
    }
    if ([self.userDefaults stringForKey:@"customPercentDefault"] == nil) {
        [self.userDefaults setObject:@"15" forKey:@"customPercentDefault"];
    }
    if ([self.userDefaults stringForKey:@"maximumPercentDefault"] == nil) {
        [self.userDefaults setObject:@"20" forKey:@"maximumPercentDefault"];
    }
    if ([self.userDefaults stringForKey:@"selectedSegmentIndexDefault"] == nil) {
        [self.userDefaults setInteger:1 forKey:@"selectedSegmentIndexDefault"];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTap:(UITapGestureRecognizer *)sender {
    NSLog(@"TipViewController onTap is called");
    
    [self updateValues];
}

- (void) updateSegmentedControl {
    [self.tipControl setTitle:[self.minimum stringByAppendingString:@"%"] forSegmentAtIndex:0];
    [self.tipControl setTitle:[self.custom stringByAppendingString:@"%"] forSegmentAtIndex:1];
    [self.tipControl setTitle:[self.maximum stringByAppendingString:@"%"] forSegmentAtIndex:2];
    [self.tipControl setSelectedSegmentIndex:[self.userDefaults integerForKey:@"selectedSegmentIndexDefault"]];
}

- (void) setLastValues {
    self.minimum = [self.userDefaults stringForKey:@"minimumPercentDefault"];
    self.custom = [self.userDefaults stringForKey:@"customPercentDefault"];
    self.maximum = [self.userDefaults stringForKey:@"maximumPercentDefault"];
    
    [self updateSegmentedControl];
    
    NSDate *lastAccessedDate = [self.userDefaults objectForKey:@"lastAccessedDate"];
    if (!lastAccessedDate) {
        return;
    }
    
    NSLog(@"Seconds between now and last accessed date: %f", -[lastAccessedDate timeIntervalSinceNow]);
    
    int secondsToHoldValues = 600;
    if (-[lastAccessedDate timeIntervalSinceNow] <= secondsToHoldValues) {
        self.billAmountInString = [self.userDefaults stringForKey:@"lastBillAmount"];
    }
}

- (void) updateValues {
    self.billAmountInString = self.billTextField.text;
    
    float billAmount = [self.billTextField.text floatValue];
    
    float tipAmount = billAmount * [self getTipPercentage];
    
    float totalAmount = billAmount + tipAmount;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    self.tipLabel.text = [numberFormatter stringFromNumber:[[NSNumber alloc] initWithFloat:tipAmount]];
    self.totalLabel.text = [numberFormatter stringFromNumber:[[NSNumber alloc] initWithFloat:totalAmount]];
    
    [self.userDefaults setInteger:self.tipControl.selectedSegmentIndex forKey:@"selectedSegmentIndexDefault"];
    [self.userDefaults synchronize];
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
    
    [self.userDefaults setObject:self.minimum forKey:@"minimumPercentDefault"];
    [self.userDefaults setObject:self.custom forKey:@"customPercentDefault"];
    [self.userDefaults setObject:self.maximum forKey:@"maximumPercentDefault"];
    [self.userDefaults synchronize];
    
    [self updateSegmentedControl];
    [self updateValues];
}

@end
