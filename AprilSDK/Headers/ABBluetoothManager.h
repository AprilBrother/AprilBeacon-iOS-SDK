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

/**
 
 The ABBluetoothManagerDelegate protocol defines the delegate methods to respond for related events.
 */

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
 * ABBeacon object using CoreBluetooth framework
 * in particular region.
 *
 * @param manager April beacon manager
 * @param beacon return single beacon once, not all beacons, 
 * diffent from beaconManager:manager didDiscoverBeacons:
 *
 * @return void
 */
- (void)beaconManager:(ABBluetoothManager *)manager
    didDiscoverBeacon:(ABBeacon *)beacon;

@end

/**
 
 ABBluetoothManager defines method to discover April beacons
 
 */

@interface ABBluetoothManager : NSObject

@property (nonatomic, weak) id <ABBluetoothManagerDelegate> delegate;

/**
 * Start beacon discovery process based on CoreBluetooth
 * framework. Method is useful for finding all April beacons
 *
 * @return void
 */
- (void)startAprilBeaconsDiscovery;

/**
 * Start sensor discovery process based on CoreBluetooth
 * framework. Method is useful for finding april sensors only
 *
 * @return void
 */
- (void)startAprilSensorsDiscovery;


/**
 * Start light discovery process based on CoreBluetooth
 * framework. Method is useful for finding april light only
 *
 * @return void
 */
- (void)startAprilLightDiscovery;

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
