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
@property (weak, nonatomic) IBOutlet UIView *secondView;

@property (nonatomic) NSUserDefaults *userDefaults;

- (IBAction)onTap:(UITapGestureRecognizer *)sender;
- (IBAction)billEditingChanged:(UITextField *)sender;

- (void) setLastValues;
- (void) updateValues;
- (void) updateSegmentedControls:(NSNotification *)obj;
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

    // Load Settings
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    [self initUserDefaultsIfNotExists];
    
    [self setLastValues];
    
    self.billTextField.text = self.billAmountInString;
    
    self.secondView.hidden = true;
    
    [self updateValues];
    
    // used for update percentages when settings view controller closes
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateSegmentedControls:)
                                                 name:@"update_percentage" object:nil];
    
    // register this Tip View Controller to App Delegate
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate registerViewController:@"tip_view_controller" controller:self];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"Tip view will appear");
    
    [self.billTextField becomeFirstResponder];
    
    if ([self.theme isEqualToString:@"Light"]) {
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
    if ([self.userDefaults stringForKey:@"themeDefault"] == nil) {
        [self.userDefaults setObject:@"Light" forKey:@"themeDefault"];
    }
    if ([self.userDefaults stringForKey:@"regionDefault"] == nil) {
        [self.userDefaults setObject:@"United States" forKey:@"regionDefault"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTap:(UITapGestureRecognizer *)sender {
    NSLog(@"TipViewController onTap is called");
    
    [self updateValues];
    
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

- (IBAction)billEditingChanged:(UITextField *)sender {
    NSLog(@"Tip view Controller billEditingChanged");
    
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

        [self updateValues];
    }
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
    
    self.theme = [self.userDefaults stringForKey:@"themeDefault"];
    self.region = [self.userDefaults stringForKey:@"regionDefault"];
    
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
    NSString *placeHolderString = (NSString *) [self.regionPlaceHolderDictionary objectForKey:self.region];
    self.billTextField.placeholder = placeHolderString;
    
    self.billAmountInString = self.billTextField.text;
    
    float billAmount = [self.billTextField.text floatValue];
    
    float tipAmount = billAmount * [self getTipPercentage];
    
    float totalAmount = billAmount + tipAmount;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];

    NSString *localeString = (NSString *) [self.regionDictionary objectForKey:self.region];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:localeString];
    [numberFormatter setLocale:locale];
    
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
        destViewController.theme = self.theme;
        destViewController.region = self.region;
    }
}

- (void) updateSegmentedControls:(NSNotification *) obj{
    NSArray *sharedData=(NSArray *) [obj object];
    
    self.minimum = sharedData[0];
    self.custom = sharedData[1];
    self.maximum = sharedData[2];
    self.theme = sharedData[3];
    self.region = sharedData[4];
    
    [self.userDefaults setObject:self.minimum forKey:@"minimumPercentDefault"];
    [self.userDefaults setObject:self.custom forKey:@"customPercentDefault"];
    [self.userDefaults setObject:self.maximum forKey:@"maximumPercentDefault"];
    [self.userDefaults setObject:self.theme forKey:@"themeDefault"];
    [self.userDefaults setObject:self.region forKey:@"regionDefault"];
    [self.userDefaults synchronize];
    
    [self updateSegmentedControl];
    [self updateValues];
}

@end
