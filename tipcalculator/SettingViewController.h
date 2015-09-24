//
//  SettingViewController.h
//  tipcalculator
//
//  Created by Robin Wu on 9/23/15.
//  Copyright (c) 2015 Robin Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *minimumTextField;
@property (weak, nonatomic) IBOutlet UITextField *customTextField;
@property (weak, nonatomic) IBOutlet UITextField *maximumTextField;

@property (nonatomic, strong) NSString *minimum;
@property (nonatomic, strong) NSString *custom;
@property (nonatomic, strong) NSString *maximum;

@end
