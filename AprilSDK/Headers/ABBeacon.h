//
//  ABBeacon.h
//  AprilBeaconSDK
//
//  Created by AprilBrother LLC on 14-4-1.
//  Copyright (c) 2014年 AprilBrother LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABDefinitions.h"

@import CoreBluetooth;
@import CoreLocation;

@class ABBeacon;

////////////////////////////////////////////////////////////////////
// April beacon delegate protocol

/**
 
 ABBeaconDelegate defines beacon connection delegate mathods. Connection is asynchronous operation so you need to be prepared that eg. beaconDidDisconnectWith: method can be invoked without previous action.
 
 */

@protocol ABBeaconDelegate <NSObject>

@optional


/**
 * Delegate method that beacon did connected with error.
 * if error is not nil, means beacon didn't be connected
 * or beacon connected
 *
 * @param beacon reference to beacon object
 * @param error beacon connect failed error or nil
 *
 * @return void
 */
- (void)beaconDidConnected:(ABBeacon*)beacon withError:(NSError *)error;

/**
 * Delegate method that beacon did disconnect with device.
 *
 * @param beacon reference to beacon object
 * @param error information about reason of error
 *
 * @return void
 */
- (void)beaconDidDisconnect:(ABBeacon*)beacon withError:(NSError*)error;

@end

/**
 
 ABBeacon defines properties of April beacon, you can get parameters of iBeacon from ABBeacon
 
 */

@interface ABBeacon : NSObject<NSCopying>

@property (nonatomic, weak) id <ABBeaconDelegate> delegate;

/// @name Publicly available properties

/**
 *  proximityUUID
 *
 *    Proximity identifier associated with the beacon.
 *
 */
@property (nonatomic, strong)   NSUUID*                 proximityUUID;


/**
 *  major
 *
 *    Most significant value associated with the region. If a major value wasn't specified, this will be nil.
 *
 */
@property (nonatomic, strong)   NSNumber*               major;

/**
 *  minor
 *
 *    Least significant value associated with the region. If a minor value wasn't specified, this will be nil.
 *
 */
@property (nonatomic, strong)   NSNumber*               minor;

/**
 *  rssi
 *
 *    Received signal strength in decibels of the specified beacon.
 *    This value is an average of the RSSI samples collected since this beacon was last reported.
 *
 */
@property (nonatomic)           NSInteger               rssi;

/**
 *  proximity
 *
 *    The value in this property gives a general sense of the relative distance to the beacon. Use it to quickly identify beacons that are nearer to the user rather than farther away.
 */
@property (nonatomic)           CLProximity             proximity;

/**
 *  macAddress
 *
 *  Discussion:
 *    Hardware MAC address of the beacon.
 */
@property (nonatomic, strong)   NSString *              macAddress;

/**
 *  proximity
 *
 *    The value in this property gives a general sense of the relative distance to the beacon. Use it to quickly identify beacons that are nearer to the user rather than farther away.
 */
@property (nonatomic, strong)   NSNumber*               distance;

/**
 *  measuredPower
 *
 *    rssi value measured from 1m. This value is used for device calibration.
 */
@property (nonatomic, strong)   NSNumber*               measuredPower;

/////////////////////////////////////////////////////
// properties filled when read characteristic

/// @name Properties available after connection

/**
 *  peripheral
 *
 *    peripheral object of beacon.
 */
@property (nonatomic, strong)   CBPeripheral*           peripheral;

/**
 *  firmwareUpdateInfo
 *
 *    Flag indicating connection status.
 */
@property (nonatomic, readonly)   BOOL                  isConnected;

/**
 *  beacon power
 *
 *    enum values of power, @see ABTxPower.
 */
@property (nonatomic)   ABTxPower               txPower;

/**
 *  advInterval
 *
 *    Advertising interval of the beacon. Value change from 100ms to 2000ms, The unit is 100ms. Value available after connection with the beacon
 */
@property (nonatomic, strong)   NSNumber*               advInterval;

/**
 *  batteryLevel
 *
 *    Battery strength in %. Battery level change from 100% - 0%. Value available after connection with the beacon
 */
@property (nonatomic, strong)   NSNumber*               batteryLevel;

/**
 *  firmwareRevision
 *
 *    Firmware revision of beacon. Value available after connection with the beacon
 */
@property (nonatomic, strong)   NSString*               firmwareRevision;

/**
 *  manufacturerName
 *
 *    Manufacturer name of beacon. Value available after connection with the beacon
 */
@property (nonatomic, strong)   NSString*               manufacturerName;

/**
 *  modelNumber
 *
 *    Model number of beacon. Value available after connection with the beacon
 */
@property (nonatomic, strong)   NSString*               modelNumber;

/**
 *  isSupportEddystone
 *
 *    is beacon support Google Eddystone protocol. Value available after connection with the beacon
 */
@property (nonatomic)   BOOL               isSupportEddystone;

/**
 *  broadcastType
 *
 *    if isSupportEddystone is true, use this to check the broadcast type. Value available after connection with the beacon
 *    ABBeaconBroadcastiBeacon Default type
 *    ABBeaconBroadcastEddystoneUid broadcast UUID is proximityUUID
 *    ABBeaconBroadcastEddystoneURL broadcast URL is eddyStoneURL
 */
@property (nonatomic)   ABBroadcastType               broadcastType;

/**
 *  eddyStoneURL
 *
 *    if broadcast type is ABBeaconBroadcastEddystoneURL, use this to get broadcast URL. Value available after connection with the beacon
 */
@property (nonatomic, strong)   NSString*               eddyStoneURL;


/// @name Connection handling methods


/**
 * Connect to particular beacon using bluetooth.
 * Connection is required to change values like
 * Major, Minor, Power and Advertising interval.
 *
 * @return void
 */
- (void)connectToBeacon;

/**
 * Disconnect device with particular beacon
 *
 * @return void
 */
- (void)disconnectBeacon;

/**
 *  Writes beacon info to connected beacon
 *  If you set the password to nil, it will use the default password
 *  If you set value to nil, it won't modify the value
 *
 *
 *  @param password  auth password, default 'AprilBrother'
 *  @param uuidString new Proximity UUID value
 *  @param major new major of iBeacon
 *  @param minor new minro of iBeacon
 *  @param txPower    @(ABTxPower) tx power
 *  @param advInterval advertise interval
 *  @param measuredPower measured power of iBeacon
 *  @param newpassword new password
 *  @param completion   callback
 *
 *  @return void
 */
- (void)writeBeaconInfoByPassword:(NSString *)password
                             uuid:(NSString *)uuidString
                            major:(NSNumber *)major
                            minor:(NSNumber *)minor
                          txPower:(NSNumber *)txPower
                      advInterval:(NSNumber *)advInterval
                    measuredPower:(NSNumber *)measuredPower
                      newpassword:(NSString *)newpassword
                   withCompletion:(ABCompletionBlock)completion;

/**
 *  Writes beacon info to connected beacon
 *  If you set the password to nil, it will use the default password
 *  If you set value to nil, it won't modify the value
 *
 *
 *  @param password  auth password, default 'AprilBrother', '195660' for EEK beacon
 *  @param uuidString new Proximity UUID value
 *  @param major new major of iBeacon
 *  @param minor new minro of iBeacon
 *  @param txPower    @(ABTxPower) tx power
 *  @param advInterval advertise interval
 *  @param measuredPower measured power of iBeacon
 *  @param newpassword new password
 *  @param completion   callback
 *  @param type broadcast type
 *
 *  @return void
 */
- (void)writeBeaconInfoByPassword:(NSString *)password
                             uuid:(NSString *)uuidString
                            major:(NSNumber *)major
                            minor:(NSNumber *)minor
                          txPower:(NSNumber *)txPower
                      advInterval:(NSNumber *)advInterval
                    measuredPower:(NSNumber *)measuredPower
                      newpassword:(NSString *)newpassword
                    broadcastType:(ABBroadcastType)type
                   withCompletion:(ABCompletionBlock)completion;

/**
 *  Writes beacon info to connected beacon
 *  If you set the password to nil, it will use the default password
 *  If you set value to nil, it won't modify the value
 *
 *
 *  @param url broadcast url
 *  @param type broadcast type
 *  @param password auth password, default 'AprilBrother', '195660' for EEK beacon
 *  @param completion   callback
 *
 *  @return void
 */
- (void)writeEddyStoneURLAndReset:(NSString *)url
                    broadcastType:(ABBroadcastType)type
                         password:(NSString *)password
                          txPower:(NSNumber *)txPower
                      advInterval:(NSNumber *)advInterval
                      newpassword:(NSString *)newpassword
                       completion:(ABCompletionBlock)completion;

/**
 *  Writes beacon info to connected beacon
 *  If you set the password to nil, it will use the default password
 *  If you set value to nil, it won't modify the value
 *
 *
 *  @param uuidString broadcast UUID
 *  @param type broadcast type
 *  @param password auth password, default 'AprilBrother', '195660' for EEK beacon
 *  @param completion   callback
 *
 *  @return void
 */
- (void)writeEddyStoneUidAndReset:(NSString *)uuidString
                    broadcastType:(ABBroadcastType)type
                         password:(NSString *)password
                          txPower:(NSNumber *)txPower
                      advInterval:(NSNumber *)advInterval
                      newpassword:(NSString *)newpassword
                       completion:(ABCompletionBlock)completion;

/**
 *  Writes AT command to connected beacon
 *
 *
 *  @param data writing data
 *  @param completion   callback
 *
 *  @return void
 */
- (void)writeCommandWithData:(NSData *)data
                  completion:(ABCompletionBlock)completion;

@end
