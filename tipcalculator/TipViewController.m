//
//  TipViewController.m
//  tipcalculator
//
//  Created by Robin Wu on 9/22/15.
//  Copyright (c) 2015 Robin Wu. All rights reserved.
//

#import "TipModel.h"
#import "TipSettingModel.h"
#import "TipViewController.h"
#import "SettingViewController.h"
#import "AppDelegate.h"

@interface TipViewController ()

@property (weak, nonatomic) IBOutlet UITextField *billTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;

@property (weak, nonatomic) IBOutlet UIView *secondView;

@property (nonatomic) NSUserDefaults *userDefaults;

- (IBAction)onTap:(UITapGestureRecognizer *)sender;
- (IBAction)billEditingChanged:(UITextField *)sender;

- (void) setLastValues;
- (void) updateViewFromModel;
- (void) showViewAnimations;
- (void) setUserDefaultForTipModel;
- (void) updateSettingFromNotification:(NSNotification *)obj;
- (float) getTipPercentage;

@end

@implementation TipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"Tip View is Loaded");
    
    self.regionDictionary = @{
                         @"Canada" : @"en_CA",
                         @"United States" : @"en_US",
                         @"United Kingdom" : @"en_GB",
                         @"Germany" : @"de_DE",
                         };

    self.regionPlaceHolderDictionary = @{
                              @"Canada" : @"$",
                              @"United States" : @"$",
                              @"United Kingdom" : @"£",
                              @"Germany" : @"€",
                              };

    if (self.tipModel == nil) {
        self.tipModel = [[TipModel alloc] init];
    }
    
    // Load Settings
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    
    [self setLastValues];
    
    // used for update percentages when settings view controller closes
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateSettingFromNotification:)
                                                 name:@"update_setting" object:nil];
    
    // register this Tip View Controller to App Delegate
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate registerViewController:@"tip_view_controller" controller:self];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"Tip view will appear");
    
    self.billTextField.text = self.tipModel.bill;
    [self.tipControl setSelectedSegmentIndex:self.tipModel.percentageIndex];
    
    self.secondView.hidden = true;
    
    [self updateViewFromModel];
    
    [self.billTextField becomeFirstResponder];
    
    if ([self.tipModel.theme isEqualToString:@"Light"]) {
        // Light
        self.view.backgroundColor = [UIColor colorWithRed:(255/255.0) green:(204/255.0) blue:(255/255.0) alpha:1];
    } else {
        // Dark
        self.view.backgroundColor = [UIColor colorWithRed:(204/255.0) green:(102/255.0) blue:(0/255.0) alpha:1];
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTap:(UITapGestureRecognizer *)sender {
    NSLog(@"TipViewController onTap is called");
    
    self.tipModel.bill = self.billTextField.text;
    self.tipModel.percentageIndex = self.tipControl.selectedSegmentIndex;
    
    [self updateViewFromModel];
    [self showViewAnimations];
}

- (IBAction)billEditingChanged:(UITextField *)sender {
    NSLog(@"Tip view Controller billEditingChanged");

    self.tipModel.bill = self.billTextField.text;

    [self updateViewFromModel];
    [self showViewAnimations];
}

- (void) showViewAnimations {
    if ([self.billTextField.text isEqual:@""]) {
        if(self.secondView.hidden == false)
        {
            self.secondView.hidden = true;
            [UIView animateWithDuration:1.0
                                  delay:1.0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^ {
                                 self.secondView.alpha = 0.0;
                             } completion:^(BOOL finished) {
                                 
                             }];
        }
    } else {
        if(self.secondView.hidden == true)
        {
            self.secondView.hidden = false;
            [UIView animateWithDuration:1.0
                                  delay:1.0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^ {
                                 self.secondView.alpha = 1.0;
                             } completion:^(BOOL finished) {
                                 
                             }];
        }
    }
}

- (void) updateSegmentedControl {
    [self.tipControl setTitle:[self.tipModel.minimum stringByAppendingString:@"%"] forSegmentAtIndex:0];
    [self.tipControl setTitle:[self.tipModel.custom stringByAppendingString:@"%"] forSegmentAtIndex:1];
    [self.tipControl setTitle:[self.tipModel.maximum stringByAppendingString:@"%"] forSegmentAtIndex:2];
    [self.tipControl setSelectedSegmentIndex:self.tipModel.percentageIndex];
}

- (void) setLastValues {
    if ([self.userDefaults objectForKey:@"minimumPercentDefault"] == nil) {
        self.tipModel.minimum = @"10";
        self.tipModel.custom = @"15";
        self.tipModel.maximum = @"20";
        self.tipModel.percentageIndex = 1;
        self.tipModel.bill = @"";
        self.tipModel.theme = @"Light";
        self.tipModel.region = @"United States";
    } else {
        self.tipModel.minimum = [self.userDefaults objectForKey:@"minimumPercentDefault"];
        self.tipModel.custom = [self.userDefaults objectForKey:@"customPercentDefault"];
        self.tipModel.maximum = [self.userDefaults objectForKey:@"maximumPercentDefault"];
        self.tipModel.percentageIndex = [self.userDefaults integerForKey:@"percentageIndexDefault"];
        self.tipModel.theme = [self.userDefaults objectForKey:@"themeDefault"];
        self.tipModel.region = [self.userDefaults objectForKey:@"regionDefault"];
    }

    [self updateSegmentedControl];
    
    NSDate *lastAccessedDate = [self.userDefaults objectForKey:@"lastAccessedDate"];
    if (!lastAccessedDate) {
        return;
    }
    
    NSLog(@"Seconds between now and last accessed date: %f", -[lastAccessedDate timeIntervalSinceNow]);
    
    int secondsToHoldValues = 600;
    if (-[lastAccessedDate timeIntervalSinceNow] <= secondsToHoldValues) {
        self.tipModel.bill = [self.userDefaults objectForKey:@"lastBillAmount"];
    } else {
        self.tipModel.bill = @"";
    }
}

- (void) updateViewFromModel {
    NSString *placeHolderString = (NSString *) [self.regionPlaceHolderDictionary objectForKey:self.tipModel.region];
    self.billTextField.placeholder = placeHolderString;
    
    float billAmount = [self.tipModel.bill floatValue];
    float tipAmount = billAmount * [self getTipPercentage];
    float totalAmount = billAmount + tipAmount;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];

    NSString *localeString = (NSString *) [self.regionDictionary objectForKey:self.tipModel.region];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:localeString];
    [numberFormatter setLocale:locale];
    
    self.tipLabel.text = [numberFormatter stringFromNumber:[[NSNumber alloc] initWithFloat:tipAmount]];
    self.totalLabel.text = [numberFormatter stringFromNumber:[[NSNumber alloc] initWithFloat:totalAmount]];

    [self.tipControl setTitle:[self.tipModel.minimum stringByAppendingString:@"%"] forSegmentAtIndex:0];
    [self.tipControl setTitle:[self.tipModel.custom stringByAppendingString:@"%"] forSegmentAtIndex:1];
    [self.tipControl setTitle:[self.tipModel.maximum stringByAppendingString:@"%"] forSegmentAtIndex:2];
    
    [self setUserDefaultForTipModel];
}

- (float) getTipPercentage {
    if (self.tipControl.selectedSegmentIndex == 0) {
        return [self.tipModel.minimum floatValue] / 100;
    } else if (self.tipControl.selectedSegmentIndex == 1) {
        return [self.tipModel.custom floatValue] / 100;
    } else {
        return [self.tipModel.maximum floatValue] / 100;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prepareForSegue is called");
    
    if ([segue.identifier isEqualToString:@"showSettings"]) {
        NSLog(@"showSetting Seg is called");

        SettingViewController *destViewController = segue.destinationViewController;
        
        [destViewController initModelWithMinimum:self.tipModel.minimum
                                          custom:self.tipModel.custom
                                         maximum:self.tipModel.maximum
                                           theme:self.tipModel.theme
                                          region:self.tipModel.region];

    }
}

- (void) updateSettingFromNotification:(NSNotification *) obj{
    TipSettingModel *tipSettingModel=(TipSettingModel *) [obj object];
    
    self.tipModel.minimum = tipSettingModel.minimum;
    self.tipModel.custom = tipSettingModel.custom;
    self.tipModel.maximum = tipSettingModel.maximum;
    self.tipModel.theme = tipSettingModel.theme;
    self.tipModel.region = tipSettingModel.region;
    
    [self updateSegmentedControl];
    [self updateViewFromModel];
}

- (void) setUserDefaultForTipModel {
    [self.userDefaults setObject:self.tipModel.minimum forKey:@"minimumPercentDefault"];
    [self.userDefaults setObject:self.tipModel.custom forKey:@"customPercentDefault"];
    [self.userDefaults setObject:self.tipModel.maximum forKey:@"maximumPercentDefault"];
    [self.userDefaults setObject:self.tipModel.theme forKey:@"themeDefault"];
    [self.userDefaults setObject:self.tipModel.region forKey:@"regionDefault"];
    [self.userDefaults setInteger:self.tipModel.percentageIndex forKey:@"percentageIndexDefault"];

    [self.userDefaults synchronize];
}

@end
