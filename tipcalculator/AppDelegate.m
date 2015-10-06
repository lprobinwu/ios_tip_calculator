//
//  AppDelegate.m
//  tipcalculator
//
//  Created by Robin Wu on 9/22/15.
//  Copyright (c) 2015 Robin Wu. All rights reserved.
//

#import "AppDelegate.h"
#import "TipViewController.h"

@interface AppDelegate ()

@property (nonatomic) TipViewController *tipViewController;
@property (nonatomic) NSUserDefaults *userDefaults;

- (void)setLastValues;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"application didFinishLaunchingWithOptions");
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

    // set the last bill amount and date time
    [self setLastValues];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// Set the last bill amount and last access data
- (void)setLastValues {
    NSLog(@"AppDelegate setLastValues");
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    
    [self.userDefaults setObject:self.tipViewController.tipModel.bill forKey:@"lastBillAmount"];
    [self.userDefaults setObject:[NSDate date] forKey:@"lastAccessedDate"];
    [self.userDefaults synchronize];
}

// Register TipViewController here so that we can set the last bill amount before application resign active
- (void)registerViewController:(NSString *)name controller:(UIViewController *)controller {
    NSLog(@"registerViewController");
    
    if ([name isEqualToString:@"tip_view_controller"]) {
        self.tipViewController = (TipViewController *)controller;
    }    
}

@end
