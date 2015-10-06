//
//  RegionTableViewController.h
//  tipcalculator
//
//  Created by Robin Wu on 10/3/15.
//  Copyright © 2015 Robin Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegionTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *regions;
@property (nonatomic, strong) NSIndexPath *lastSelectedIndex;
@property (nonatomic, strong) NSString *selectedRegion;

@end
