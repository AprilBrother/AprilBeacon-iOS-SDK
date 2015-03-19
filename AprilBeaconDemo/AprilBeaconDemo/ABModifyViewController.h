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

@interface ABModifyViewController : UITableViewController<ABBeaconDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@property (strong, nonatomic) IBOutlet ABUUIDTextField *uuidField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *majorField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *minorField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *powerField;
@property (strong, nonatomic) IBOutlet UILabel *txPowerLabel;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *advIntervalField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *passcodeField;

@property (nonatomic, strong) ABBeacon *beacon;

@end
