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
        self.region = [[ABBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"]
                                                              major:10086
                                                              minor:10010
                                                         identifier:@"test"];
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

@end
