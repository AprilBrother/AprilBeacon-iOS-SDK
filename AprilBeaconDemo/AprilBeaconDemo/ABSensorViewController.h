//
//  ABSensorViewController.h
//  Examples
//
//  Created by liaojinhua on 14-7-3.
//  Copyright (c) 2014年 li shuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AprilBeaconSDK.h>

@import GLKit;
@import OpenGLES.ES2;

@interface ABSensorViewController : GLKViewController<ABBeaconDelegate>

@property (nonatomic, strong) ABSensor *sensor;

@end
