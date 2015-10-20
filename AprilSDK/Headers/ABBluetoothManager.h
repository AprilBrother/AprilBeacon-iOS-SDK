//
//  ABBluetoothManager.h
//  ConfigTool
//
//  Created by gongliang on 15/7/21.
//  Copyright (c) 2015年 April Brother. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ABBeacon;

@class ABBluetoothManager;

@protocol ABBluetoothManagerDelegate <NSObject>

@optional

/**
 * Delegate method invoked to handle discovered
 * ABBeacon objects using CoreBluetooth framework
 * in particular region.
 *
 * @param manager April beacon manager
 * @param beacons all beacons as ABBeacon objects
 *
 * @return void
 */
- (void)beaconManager:(ABBluetoothManager *)manager
   didDiscoverBeacons:(NSArray *)beacons;

/**
 * Delegate method invoked to handle discovered
 * ABBeacon objects using CoreBluetooth framework
 * in particular region.
 *
 * @param manager April beacon manager
 * @param beacon
 *
 * @return void
 */
- (void)beaconManager:(ABBluetoothManager *)manager
    didDiscoverBeacon:(ABBeacon *)beacon;

@end

@interface ABBluetoothManager : NSObject

@property (nonatomic, weak) id <ABBluetoothManagerDelegate> delegate;

/**
 * Start beacon discovery process based on CoreBluetooth
 * framework. Method is useful for older beacons discovery
 * that are not advertising as iBeacons.
 *
 * @return void
 */
- (void)startAprilBeaconsDiscovery;

/**
 * Start sensor discovery process based on CoreBluetooth
 * framework. Method is useful for older beacons discovery
 * that are not advertising as iBeacons.
 *
 * @return void
 */
- (void)startAprilSensorsDiscovery;


/**
 * Stops CoreBluetooth based beacon discovery process.
 *
 * @return void
 */
- (void)stopAprilBeaconDiscovery;

/**
 *  Clear beacons Data and Stops CoreBluetooth based beacon discovery process.
 */
- (void)stopAndClearDataAprilBeaconDiscovery;

/**
 * Beacons whose name begin with specified name can be found.
 *
 * @param beaconPrefixName name want to discovered
 * @return void
 */
- (void)addCustomBeaconNameFilter:(NSString *)beaconPrefixName;

/**
 * Remove filter of specified name.
 *
 * @param beaconPrefixName name want to removed from filter;
 * @return void
 */
- (void)removeCustomBeaconNameFilter:(NSString *)beaconPrefixName;


@end
