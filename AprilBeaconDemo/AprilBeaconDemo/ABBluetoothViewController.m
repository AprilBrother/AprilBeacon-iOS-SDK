//
//  ABBluetoothViewController.m
//  TestSDKPod
//
//  Created by liaojinhua on 14-5-8.
//  Copyright (c) 2014年 AprilBrother. All rights reserved.
//

#import "ABBluetoothViewController.h"
#import "ABModifyViewController.h"

@interface ABBluetoothViewController ()

@property (nonatomic, strong) ABBluetoothManager *bluetoothManager;
@property (nonatomic, strong) NSMutableArray *tableData;

@end

@implementation ABBluetoothViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bluetoothManager = [[ABBluetoothManager alloc] init];
    self.bluetoothManager.delegate = self;
    
    _tableData = [NSMutableArray array];
    
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(startRangeBeacons)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.bluetoothManager addCustomBeaconNameFilter:@"AprilBeacon"];
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
    cell.detailTextLabel.text = [NSString stringWithFormat:@"RSSI:%ld", (long)beacon.rssi];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"ModifySegue" sender:_tableData[indexPath.row]];
}


#pragma mark - ABBluetoothManagerDelegate
- (void)beaconManager:(ABBluetoothManager *)manager didDiscoverBeacons:(NSArray *)beacons{
    [self.refreshControl endRefreshing];
    [_tableData removeAllObjects];
    [_tableData addObjectsFromArray:beacons];
    [self.tableView reloadData];
}

#pragma mark - Custom methods

- (void)startRangeBeacons
{
    [self stopRangeBeacons];
     [self.bluetoothManager startAprilBeaconsDiscovery];
}

- (void)stopRangeBeacons
{
    [self.bluetoothManager stopAprilBeaconDiscovery];
}


@end
