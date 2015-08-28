//
//  ABSensorListViewController.m
//  AprilBeaconDemo
//
//  Created by liaojinhua on 14-8-15.
//  Copyright (c) 2014年 AprilBrother. All rights reserved.
//

#import "ABSensorListViewController.h"
#import <AprilBeaconSDK.h>
#import "ABSensorViewController.h"

@interface ABSensorListViewController () <ABBluetoothManagerDelegate>

@property (nonatomic, strong) ABBluetoothManager *bluetoothManager;
@property (nonatomic, strong) NSMutableArray *tableData;

@end

@implementation ABSensorListViewController

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
    if ([segue.identifier isEqualToString:@"ViewSensorSegue"]) {
        ABSensorViewController *vc = segue.destinationViewController;
        vc.sensor = sender;
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
    cell.detailTextLabel.text = [peripheral.identifier UUIDString];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"ViewSensorSegue" sender:_tableData[indexPath.row]];
}


#pragma mark - ABbluetoothManagerDelegate
- (void)beaconManager:(ABBluetoothManager *)manager didDiscoverBeacons:(NSArray *)beacons {
    [self.refreshControl endRefreshing];
    [_tableData removeAllObjects];
    [beacons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[ABSensor class]]) {
            [_tableData addObject:obj];
        }
    }];
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
