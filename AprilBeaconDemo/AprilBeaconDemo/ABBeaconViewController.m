//
//  ABViewController.m
//  TestSDKPod
//
//  Created by liaojinhua on 14-5-7.
//  Copyright (c) 2014年 AprilBrother. All rights reserved.
//

#import "ABBeaconViewController.h"
#import "ABTransmitters.h"

@interface ABBeaconViewController ()

@property (nonatomic, strong) ABBeaconManager *beaconManager;
@property (nonatomic, strong) NSMutableDictionary *tableData;

@end

@implementation ABBeaconViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.beaconManager = [[ABBeaconManager alloc] init];
        self.beaconManager.delegate = self;
        
        [self.beaconManager requestAlwaysAuthorization];
        
        _tableData = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_tableData allValues][section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ABBeacon *beacon = [_tableData allValues][indexPath.section][indexPath.row];
    
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
    NSLog(@"beacons = %@", beacons);
    [self.refreshControl endRefreshing];
    [_tableData removeObjectForKey:region];
    [_tableData setObject:beacons forKey:region];
    [self.tableView reloadData];
}

- (void)beaconManager:(ABBeaconManager *)manager rangingBeaconsDidFailForRegion:(ABBeaconRegion *)region withError:(NSError *)error
{
    [self.refreshControl endRefreshing];
    [_tableData removeObjectForKey:region];
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
