//
//  TipSettingModel.h
//  tipcalculator
//
//  Created by Robin Wu on 10/6/15.
//  Copyright © 2015 Robin Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TipSettingModel : NSObject

@property (nonatomic, strong) NSString *minimum;
@property (nonatomic, strong) NSString *custom;
@property (nonatomic, strong) NSString *maximum;

@property (nonatomic, strong) NSString *theme;
@property (nonatomic, strong) NSString *region;

- (id) init;

@end
