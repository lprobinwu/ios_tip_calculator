//
//  TipViewController.h
//  tipcalculator
//
//  Created by Robin Wu on 9/22/15.
//  Copyright (c) 2015 Robin Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TipModel.h"

@interface TipViewController : UIViewController

@property (strong, nonatomic) TipModel *tipModel;

@property (nonatomic, strong) NSDictionary *regionDictionary;
@property (nonatomic, strong) NSDictionary *regionPlaceHolderDictionary;

@end

