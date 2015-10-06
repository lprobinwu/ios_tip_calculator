//
//  TipModel.h
//  tipcalculator
//
//  Created by Robin Wu on 10/5/15.
//  Copyright © 2015 Robin Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TipSettingModel.h"

@interface TipModel : TipSettingModel

@property (nonatomic, strong) NSString *bill;
@property (nonatomic) NSInteger percentageIndex;

- (id) init;

@end
