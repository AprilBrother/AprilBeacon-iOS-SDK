//
//  ABModifyViewController.m
//  Examples
//
//  Created by liaojinhua on 14-7-2.
//  Copyright (c) 2014年 li shuai. All rights reserved.
//

#import "ABModifyViewController.h"

#define kTxPowerCellIndex 0

typedef enum {
    BBTxPower0DBM = 0,
    BBTxPower4DBM = 1,
    BBTxPowerMinus6DBM = 2,
    BBTxPowerMinus23DBM = 3
} BBTxPower;

@interface ABModifyViewController () <UIActionSheetDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSArray *txPowerIndex;

@property (nonatomic) UInt8 deviceTxPower;

@property (nonatomic, strong) NSMutableArray *modifyingArray;

@end

@implementation ABModifyViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _txPowerIndex = @[@"0dBm", @"4dBm", @"-6dBm", @"-23dBm"];
    _uuidField.inputAccessoryView = _uuidToolbar;
    self.beacon.delegate = self;
    [self.beacon connectToBeacon];
    
    _modifyingArray = [NSMutableArray array];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.beacon disconnectBeacon];
    self.beacon.delegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ABBeaconDelegate

- (void)beaconDidConnected:(ABBeacon *)beacon withError:(NSError *)error
{
    if (error) {
        [self showAlertWithMessage:@"connect failed"];
        return;
    }
    _uuidField.text = self.beacon.proximityUUID.UUIDString;
    _majorField.text = [NSString stringWithFormat:@"%@", self.beacon.major];
    _minorField.text = [NSString stringWithFormat:@"%@", self.beacon.minor];
    _powerField.text = [NSString stringWithFormat:@"%@", self.beacon.measuredPower];
    _txPowerLabel.text = [NSString stringWithFormat:@"%@", _txPowerIndex[self.beacon.txPower]];
    _deviceTxPower = self.beacon.txPower;
    _advIntervalField.text = [NSString stringWithFormat:@"%@", self.beacon.advInterval];
    NSLog(@"Firmware Revision: %@", self.beacon.firmwareRevision);
    NSLog(@"Manufacturer Nmae: %@", self.beacon.manufacturerName);
    NSLog(@"Model Number:%@", self.beacon.modelNumber);
}

- (void)beaconDidDisconnect:(ABBeacon *)beacon withError:(NSError *)error
{
    
}


- (IBAction)saveAction:(id)sender
{
    [self.beacon authBeaconWithPassword:@"AprilBrother" withCompletion:^(NSError *error) {
        if (!error) {
            [self doModify];
        }
    }];
    
}

- (void)removeObjectFromModifyingArray:(id)obj
{
    [_modifyingArray removeObject:obj];
    if (_modifyingArray.count == 0) {
        [self.beacon resetBeaconWithCompletion:^(NSError *error) {
            // do something when get error
            [self showAlertWithMessage:@"Modify done"];
        }];
    }
}

- (void)doModify
{
    if (![self.uuidField.text isEqualToString:self.beacon.proximityUUID.UUIDString]) {
        if ([self isValidUUID:self.uuidField.text]) {
            [self.beacon writeBeaconProximityUUID:self.uuidField.text withCompletion:^(NSError *error) {
                // do something when error is not nil
                [self removeObjectFromModifyingArray:self.uuidField];
                _uuidField.text = self.beacon.proximityUUID.UUIDString;
            }];
        } else {
            // uuid value is not valid
        }
    }
    
    if ([self.majorField.text intValue] != [self.beacon.major intValue]) {
        if (!([_majorField.text intValue] < 0 || [_majorField.text intValue] > 65535)) {
            [_modifyingArray addObject:_majorField];
            [self.beacon writeBeaconMajor:[_majorField.text intValue] withCompletion:^(NSError *error) {
                // do something when error is not nil
                [self removeObjectFromModifyingArray:_majorField];
                _majorField.text = [NSString stringWithFormat:@"%@", self.beacon.major];
            }];
        } else {
            // major value is not valid
        }
    }
    
    if ([self.minorField.text intValue] != [self.beacon.minor intValue]) {
        if (!([_minorField.text intValue] < 0 || [_minorField.text intValue] > 65535)) {
            [_modifyingArray addObject:_minorField];
            [self.beacon writeBeaconMinor:[_minorField.text intValue] withCompletion:^(NSError *error) {
                // do something when error is not nil
                [self removeObjectFromModifyingArray:_minorField];
                _minorField.text = [NSString stringWithFormat:@"%@", self.beacon.minor];
            }];
        } else {
            // minor value is not valid
        }
    }
    
    if ([self.powerField.text intValue] != [self.beacon.measuredPower intValue]) {
        if ([_powerField.text intValue] >= -255 && [_powerField.text intValue] <= -1) {
            [_modifyingArray addObject:_powerField];
            [self.beacon writeBeaconMeasuredPower:[_powerField.text intValue] withCompletion:^(NSError *error) {
                // do something when error is not nil
                [self removeObjectFromModifyingArray:_powerField];
                _powerField.text = [NSString stringWithFormat:@"%@", self.beacon.measuredPower];
            }];
        } else {
            // measured power value is not valid
        }
    }
    
    if ([self.advIntervalField.text intValue] != [self.beacon.advInterval intValue]) {
        if (!([_advIntervalField.text intValue] < 1 || [_advIntervalField.text intValue] > 100)) {
            [_modifyingArray addObject:_advIntervalField];
            [self.beacon writeBeaconAdvInterval:[_advIntervalField.text intValue] withCompletion:^(NSError *error) {
                // do something when error is not nil
                [self removeObjectFromModifyingArray:_advIntervalField];
                _advIntervalField.text = [NSString stringWithFormat:@"%@", self.beacon.advInterval];
            }];
        } else {
            // adv interval value is not valid
        }
    }
    
    if (_passcodeField.text.length == 12) {
        [_modifyingArray addObject:_passcodeField];
        [self.beacon writeBeaconPasscode:_passcodeField.text withCompletion:^(NSError *error) {
            // do something when error is not nil
            [self removeObjectFromModifyingArray:_passcodeField];
        }];
    } else {
        // passcode value is not valid
    }
    
    if (_deviceTxPower != self.beacon.txPower) {
        [_modifyingArray addObject:_txPowerLabel];
        [self.beacon writeBeaconTxPower:_deviceTxPower withCompletion:^(NSError *error) {
            // do something when error is not nil
            [self removeObjectFromModifyingArray:_txPowerLabel];
            _txPowerLabel.text = [NSString stringWithFormat:@"%@", _txPowerIndex[self.beacon.txPower]];
            _deviceTxPower = self.beacon.txPower;
        }];
    }
}

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}

- (BOOL)isValidUUID:(NSString *)uuidString
{
    uuidString = [uuidString uppercaseString];
    NSString * regex  = @"[0-9A-Z]{8}-[0-9A-Z]{4}-[0-9A-Z]{4}-[0-9A-Z]{4}-[0-9A-Z]{12}";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:uuidString];
}

- (NSString *)getTxPowerWithIndex:(NSInteger)index
{
    if ((index > BBTxPowerMinus23DBM) || (index < BBTxPower0DBM)) {
        index = 0;
    }
    NSString *power = _txPowerIndex[index];
    return [NSString stringWithFormat:@"Tx Power: %@", power];
}
#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == kTxPowerCellIndex) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.tableView endEditing:YES];
        
        UIActionSheet *action = [[UIActionSheet alloc] init];
        action.delegate = self;
        action.title = @"Tx Power";
        
        for (NSString *i in _txPowerIndex) {
            [action addButtonWithTitle:i];
        }
        
        action.cancelButtonIndex = [action addButtonWithTitle:@"cancel"];
        
        [action showInView:self.tableView];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    _deviceTxPower = buttonIndex;
    _txPowerLabel.text = [self getTxPowerWithIndex:_deviceTxPower];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
