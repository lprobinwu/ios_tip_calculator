//
//  SettingViewController.h
//  tipcalculator
//
//  Created by Robin Wu on 9/23/15.
//  Copyright (c) 2015 Robin Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TipSettingModel.h"

@interface SettingViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *minimumTextField;
@property (weak, nonatomic) IBOutlet UITextField *customTextField;
@property (weak, nonatomic) IBOutlet UITextField *maximumTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *themeControl;
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;

@property (nonatomic, strong) TipSettingModel *tipSettingModel;

- (void) initModelWithMinimum:(NSString *)minimum
                       custom:(NSString *)custom
                      maximum:(NSString *)maximum
                        theme:(NSString *)theme
                       region:(NSString *)region;

@end
