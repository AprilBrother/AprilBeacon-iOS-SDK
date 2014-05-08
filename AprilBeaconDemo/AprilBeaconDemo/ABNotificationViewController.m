//
//  ABNotificationViewController.m
//  TestSDKPod
//
//  Created by liaojinhua on 14-5-8.
//  Copyright (c) 2014年 AprilBrother. All rights reserved.
//

#import "ABNotificationViewController.h"

@interface ABNotificationViewController ()

@property (nonatomic, strong) ABBeaconManager *beaconManager;
@property (weak, nonatomic) IBOutlet UISwitch *enterSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *exitSwitch;

@property (nonatomic, strong) ABBeaconRegion *region;

@end

@implementation ABNotificationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.beaconManager = [[ABBeaconManager alloc] init];
    _beaconManager.delegate = self;
    
    [self startMonitoringForRegion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startMonitoringForRegion
{
    if (!_region) {
        self.region = [[ABBeaconRegion alloc] initWithProximityUUID:_beacon.proximityUUID
                                                                     major:[_beacon.major intValue]
                                                                     minor:[_beacon.minor intValue]
                                                                identifier:_beacon.proximityUUID.UUIDString];
    } else {
        [_beaconManager stopMonitoringForRegion:self.region];
    }
    self.region.notifyOnEntry = _enterSwitch.on;
    self.region.notifyOnExit = _exitSwitch.on;
    self.region.notifyEntryStateOnDisplay = YES;
    [_beaconManager startMonitoringForRegion:self.region];
}

- (IBAction)enterSwitchChanaged:(UISwitch *)sender
{
    [self startMonitoringForRegion];
}

- (IBAction)exitSwitchChanged:(UISwitch *)sender
{
    [self startMonitoringForRegion];
}

- (void)beaconManager:(ABBeaconManager *)manager didEnterRegion:(ABBeaconRegion *)region
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"Enter monitoring region";
    notification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void)beaconManager:(ABBeaconManager *)manager didExitRegion:(ABBeaconRegion *)region
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"Exit monitoring region";
    notification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

@end
