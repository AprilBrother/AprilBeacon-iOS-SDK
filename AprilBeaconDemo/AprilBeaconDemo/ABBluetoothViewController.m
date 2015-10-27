//
//  ABBluetoothViewController.m
//  TestSDKPod
//
//  Created by liaojinhua on 14-5-8.
//  Copyright (c) 2014年 AprilBrother. All rights reserved.
//

#import "ABBluetoothViewController.h"
#import "ABModifyViewController.h"

@interface ABBluetoothViewController () <ABBluetoothManagerDelegate>

@property (nonatomic, strong) ABBluetoothManager *beaconManager;
@property (nonatomic, strong) NSMutableArray *tableData;

@end

@implementation ABBluetoothViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.beaconManager = [[ABBluetoothManager alloc] init];
    self.beaconManager.delegate = self;
    
    _tableData = [NSMutableArray array];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(startRangeBeacons)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.beaconManager addCustomBeaconNameFilter:@"aikaka"];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ModifySegue"]) {
        ABModifyViewController *vc = segue.destinationViewController;
        vc.beacon = sender;
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
    CBPeripheral *peripheral = beacon.peripheral;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"beaconCell"];
    
    cell.textLabel.text = peripheral.name;
    NSMutableString *detailString = [[NSMutableString alloc] init];
    
    // fot the newest EEK iBeacon, you can get Major, Minor, Mac Address , battery level when scan iBeacons.
    if (beacon.major) {
        [detailString appendFormat:@"Major:%@ ",beacon.major];
    }
    if (beacon.minor) {
        [detailString appendFormat:@"Minor:%@ ",beacon.minor];
    }
    if (beacon.macAddress) {
        [detailString appendFormat:@"Mac:%@ ",beacon.macAddress];
    }
    if (beacon.batteryLevel) {
        [detailString appendFormat:@"Battery:%@ ", beacon.batteryLevel];
    }
    if (beacon.rssi == 127) {
        cell.userInteractionEnabled = NO;
        cell.textLabel.textColor = [UIColor lightGrayColor];
        
        [detailString appendFormat:@"rssi : "];
    } else {
        cell.userInteractionEnabled = YES;
        cell.textLabel.textColor = [UIColor blackColor];
        [detailString appendFormat:@"rssi : %ld", (long)beacon.rssi];
    }
    
    cell.detailTextLabel.text = detailString;
    cell.detailTextLabel.numberOfLines = 0;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"ModifySegue" sender:_tableData[indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


#pragma mark - ABBeaconManagerDelegate
- (void)beaconManager:(ABBeaconManager *)manager didDiscoverBeacons:(NSArray *)beacons{
    [self.refreshControl endRefreshing];
    [_tableData removeAllObjects];
    [_tableData addObjectsFromArray:beacons];
    [self.tableView reloadData];
}

#pragma mark - Custom methods

- (void)startRangeBeacons
{
    [self stopRangeBeacons];
    [_beaconManager startAprilBeaconsDiscovery];
//    [_beaconManager startAprilSensorsDiscovery]; // only find april sensors
//    [_beaconManager startAprilLightDiscovery]; // only find april lights
}

- (void)stopRangeBeacons
{
    [_beaconManager stopAprilBeaconDiscovery];
}


@end
