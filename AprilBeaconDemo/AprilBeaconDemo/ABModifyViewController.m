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

@interface ABModifyViewController ()


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
    self.beacon.delegate = self;
    [self.beacon connectToBeacon];
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
        NSLog(@"connect error: %@", error);
    }
}

- (void)beaconDidDisconnect:(ABBeacon *)beacon withError:(NSError *)error
{
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *defaultPassword = @"AprilBrother";
    
    if (indexPath.row == 0) {
        // if the iBeacon supports Eddystone, you can use this method to change the broadcast to iBeacon and modify the parameters
        // if the iBeacon doesn't support Eddystone, you can use both the new and old method to modify parameters.
        // if you use new method to modify parameters for beacons not support Eddystone, you should set the boradcastType to ABBeaconBroadcastiBeacon, or you will get an error.
        // The default password is AprilBrother for AprilBeacon and 195660 for EEK iBeacon,
        // advInterval's unit is 100ms.if you set it to 5, then actually it is 500ms
        // if you just want to modify some of the parmaters, just set the no modified value to nil. as newpassword below.
        [self.beacon writeBeaconInfoByPassword:defaultPassword
                                          uuid:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"
                                         major:@(100)
                                         minor:@(101)
                                       txPower:@(ABTxPower0DBM)
                                   advInterval:@(5)
                                 measuredPower:@(-58)
                                   newpassword:nil
                                 broadcastType:ABBeaconBroadcastiBeacon
                                withCompletion:^(NSError *error) {
                                    if (error == nil) {
                                        NSLog(@"修改成功");
                                    } else {
                                        NSLog(@"修改失败%@", error);
                                    }
                                }];
    } else if (indexPath.row == 1) {
        [self.beacon writeEddyStoneUidAndReset:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"
                                 broadcastType:ABBeaconBroadcastEddystoneUid
                                      password:defaultPassword
                                       txPower:nil
                                   advInterval:@(5)
                                   newpassword:nil
                                    completion:^(NSError *error) {
                                        if (error == nil) {
                                            NSLog(@"修改成功");
                                        } else {
                                            NSLog(@"修改失败%@", error);
                                        }
                                    }];
        
    } else {
        [self.beacon writeEddyStoneURLAndReset:@"http://apbrother.com"
                                 broadcastType:ABBeaconBroadcastEddystoneURL
                                      password:defaultPassword
                                       txPower:ABTxPower0DBM
                                   advInterval:@(5)
                                   newpassword:nil
                                    completion:^(NSError *error) {
                                        if (error == nil) {
                                            NSLog(@"修改成功");
                                        } else {
                                            NSLog(@"修改失败%@", error);
                                        }
                                    }];
    }
}

@end
