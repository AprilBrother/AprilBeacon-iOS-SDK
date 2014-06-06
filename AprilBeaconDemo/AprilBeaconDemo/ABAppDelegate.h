//
//  ABAppDelegate.h
//  AprilBeaconDemo
//
//  Created by liaojinhua on 14-5-7.
//  Copyright (c) 2014年 AprilBrother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AprilBeaconSDK.h>

@interface ABAppDelegate : UIResponder <UIApplicationDelegate, ABBeaconManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) ABBeaconManager *beaconManger;

@end
