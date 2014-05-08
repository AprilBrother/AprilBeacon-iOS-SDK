//
//  ABSelectDeviceViewController.m
//  TestSDKPod
//
//  Created by liaojinhua on 14-5-8.
//  Copyright (c) 2014年 AprilBrother. All rights reserved.
//

#import "ABSelectDeviceViewController.h"
#import "ABTransmitters.h"
#import "ABNotificationViewController.h"

@interface ABSelectDeviceViewController ()

@property (nonatomic, strong) ABBeaconManager *beaconManager;
@property (nonatomic, strong) NSMutableArray *tableData;

@end

@implementation ABSelectDeviceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.beaconManager = [[ABBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    
    _tableData = [NSMutableArray array];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(startRangeBeacons)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startRangeBeacons];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopRangeBeacons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"notificationDemo"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ABBeacon *beacon = _tableData[indexPath.row];
        
        ABNotificationViewController *view = segue.destinationViewController;
        view.beacon = beacon;
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ABBeacon *beacon = _tableData[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"beaconCell"];
    
    cell.textLabel.text = [beacon.proximityUUID UUIDString];
    
    NSString *proximity;
    switch (beacon.proximity) {
        case CLProximityFar:
            proximity = @"Far";
            break;
        case CLProximityImmediate:
            proximity = @"Immediate";
            break;
        case CLProximityNear:
            proximity = @"Near";
            break;
        default:
            proximity = @"Unknown";
            break;
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Major: %@, Minor: %@, Acc: %.2fm, proximity=%@", beacon.major, beacon.minor, [beacon.distance floatValue], proximity];
    
    return cell;
}

#pragma mark - ABBeaconManagerDelegate
- (void)beaconManager:(ABBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ABBeaconRegion *)region
{
    [self.refreshControl endRefreshing];
    [_tableData removeAllObjects];
    [_tableData addObjectsFromArray:beacons];
    [self.tableView reloadData];
}

- (void)beaconManager:(ABBeaconManager *)manager rangingBeaconsDidFailForRegion:(ABBeaconRegion *)region withError:(NSError *)error
{
    [self.refreshControl endRefreshing];
    [self.refreshControl endRefreshing];
    [_tableData removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - Custom methods

- (void)startRangeBeacons
{
    [self stopRangeBeacons];
    
    ABTransmitters *tran = [ABTransmitters sharedTransmitters];
    [[tran transmitters] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:obj[@"uuid"]];
        NSString *regionIdentifier = obj[@"uuid"];
        
        ABBeaconRegion *beaconRegion;
        beaconRegion = [[ABBeaconRegion alloc] initWithProximityUUID:proximityUUID
                                                          identifier:regionIdentifier];
        beaconRegion.notifyOnEntry = YES;
        beaconRegion.notifyOnExit = YES;
        beaconRegion.notifyEntryStateOnDisplay = YES;
        [_beaconManager startRangingBeaconsInRegion:beaconRegion];
    }];
}

- (void)stopRangeBeacons
{
    ABTransmitters *tran = [ABTransmitters sharedTransmitters];
    [[tran transmitters] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:obj[@"uuid"]];
        NSString *regionIdentifier = obj[@"uuid"];
        
        ABBeaconRegion *beaconRegion;
        beaconRegion = [[ABBeaconRegion alloc] initWithProximityUUID:proximityUUID
                                                          identifier:regionIdentifier];
        [_beaconManager stopRangingBeaconsInRegion:beaconRegion];
    }];
    
}
@end
