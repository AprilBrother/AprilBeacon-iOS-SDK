//
//  ABModifyViewController.h
//  Examples
//
//  Created by liaojinhua on 14-7-2.
//  Copyright (c) 2014年 li shuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AprilBeaconSDK.h>
#import "JVFloatLabeledTextField.h"
#import "ABUUIDTextField.h"

@interface ABModifyViewController : UITableViewController<ABBeaconDelegate>

@property (nonatomic, strong) ABBeacon *beacon;

@end
