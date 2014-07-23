//
//  ABModifyViewController.m
//  Examples
//
//  Created by liaojinhua on 14-7-2.
//  Copyright (c) 2014年 li shuai. All rights reserved.
//

#import "ABModifyViewController.h"

#define kTxPowerCellIndex 0

@interface ABModifyViewController ()

@property (nonatomic, strong) NSArray *txPowerIndex;

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

- (void)beaconConnectionDidSucceeded:(ABBeacon *)beacon
{
    _uuidField.text = self.beacon.proximityUUID.UUIDString;
    _majorField.text = [NSString stringWithFormat:@"%@", self.beacon.major];
    _minorField.text = [NSString stringWithFormat:@"%@", self.beacon.minor];
    _powerField.text = [NSString stringWithFormat:@"%@", self.beacon.measuredPower];
    _txPowerLabel.text = [NSString stringWithFormat:@"%@", _txPowerIndex[self.beacon.txPower]];
    _advIntervalField.text = [NSString stringWithFormat:@"%@", self.beacon.advInterval];
    NSLog(@"Firmware Revision: %@", self.beacon.firmwareRevision);
    NSLog(@"Manufacturer Nmae: %@", self.beacon.manufacturerName);
}

- (void)beaconDidDisconnect:(ABBeacon *)beacon withError:(NSError *)error
{
    
}

- (void)beaconConnectionDidFail:(ABBeacon *)beacon withError:(NSError *)error
{
    
}

- (IBAction)saveAction:(id)sender {
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


@end
