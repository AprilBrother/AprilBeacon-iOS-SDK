//
//  ABBeacon.h
//  AprilBeaconSDK
//
//  Created by AprilBrother LLC on 14-4-1.
//  Copyright (c) 2014年 AprilBrother LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreBluetooth;
@import CoreLocation;


/// April Beacon power value definition
typedef NS_ENUM(NSInteger, ABTxPower)  {
    /** Default value for tx power */
    ABTxPower0DBM = 0,
    /** The max value for tx power */
    ABTxPower4DBM = 1,
    /** Small value for tx power */
    ABTxPowerMinus6DBM = 2,
    /** The min value for tx power */
    ABTxPowerMinus23DBM = 3
};

/**
 *    callback method.
 *
 *    @param error nil or specific error.
 */
typedef void(^ABCompletionBlock)(NSError* error);

/**
 *    unsigned short value callback method.
 *
 *    @param value unsigned short return value.
 *    @param error nil or specific error.
 */
typedef void(^ABUnsignedShortCompletionBlock)(unsigned short value, NSError* error);

/**
 *    power callback method.
 *
 *    @param value power value.
 *    @param error nil or specific error.
 */
typedef void(^ABPowerCompletionBlock)(ABTxPower value, NSError* error);

/**
 *    bool value callback method.
 *
 *    @param value bool return value.
 *    @param error nil or specific error.
 */
typedef void(^ABBoolCompletionBlock)(BOOL value, NSError* error);

/**
 *    string value callback method.
 *
 *    @param value string return value.
 *    @param error nil or specific error.
 */
typedef void(^ABStringCompletionBlock)(NSString* value, NSError* error);


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
 *  macAddress
 *
 *  Discussion:
 *    Hardware MAC address of the beacon.
 */
@property (nonatomic, strong)   NSString *              macAddress;

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
@property (nonatomic, strong)   NSNumber*               distance;

/**
 *  proximity
 *
 *    The value in this property gives a general sense of the relative distance to the beacon. Use it to quickly identify beacons that are nearer to the user rather than farther away.
 */
@property (nonatomic)           CLProximity             proximity;

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
 *    Advertising interval of the beacon. Value change from 50ms to 2000ms. Value available after connection with the beacon
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


/// @name Methods for reading beacon configuration

/**
 * Read Proximity UUID of connected beacon (Previous connection
 * required)
 *
 * @param completion block with Proximity UUID value as param
 *
 * @return void
 */
- (void)readBeaconProximityUUIDWithCompletion:(ABStringCompletionBlock)completion;

/**
 * Read macAddress of connected beacon (Previous connection
 * required)
 *
 * @param completion block with macAddress value as param
 *
 * @return void
 */
- (void)readBeaconMacAddressWithCompletion:(ABStringCompletionBlock)completion;

/**
 * Read major of connected beacon (Previous connection
 * required)
 *
 * @param completion block with major value as param
 *
 * @return void
 */
- (void)readBeaconMajorWithCompletion:(ABUnsignedShortCompletionBlock)completion;

/**
 * Read minor of connected beacon (Previous connection
 * required)
 *
 * @param completion block with minor value as param
 *
 * @return void
 */
- (void)readBeaconMinorWithCompletion:(ABUnsignedShortCompletionBlock)completion;




/**
 * Read advertising interval of connected beacon (Previous connection
 * required)
 *
 * @param completion block with advertising interval value as param
 *
 * @return void
 */
- (void)readBeaconAdvIntervalWithCompletion:(ABUnsignedShortCompletionBlock)completion;


/**
 * Read power of connected beacon (Previous connection
 * required)
 *
 * @param completion block with power value as param
 *
 * @return float value of beacon power
 */
- (void)readBeaconMeasuredPowerWithCompletion:(ABPowerCompletionBlock)completion;

/**
 * Read Tx power of connected beacon (Previous connection
 * required)
 *
 * @param completion block with power value as param
 *
 * @return ABTxPower of beacon Tx power
 */
- (void)readBeaconTxPowerWithCompletion:(ABPowerCompletionBlock)completion;

/**
 * Read battery level of connected beacon (Previous connection
 * required)
 *
 * @param completion block with battery level value as param
 *
 * @return void
 */
- (void)readBeaconBatteryWithCompletion:(ABUnsignedShortCompletionBlock)completion;


/// @name Methods for writing beacon configuration

/**
 * check password of connected beacon before write values. 
 * new method for writeBeaconPassword
 *
 * @param password password of beacon
 * @param completion block handling operation completion
 *
 * @return void
 */
- (void)authBeaconWithPassword:(NSString *)password
                withCompletion:(ABCompletionBlock)completion;

/**
 * Reset connected beacon.
 *
 * @param completion block handling operation completion
 *
 * @return void
 */
- (void)resetBeaconWithCompletion:(ABCompletionBlock)completion;

/**
 * Writes Proximity UUID param to bluetooth connected beacon. Please  remember that If you change the UUID to your very own value anyone can read it, copy it and spoof your beacons. So if you are working on a mission critical application where security is an issue - be sure to implement it on your end. We are also working on a secure mode for our beacons and it will be included in one of the next firmware updates.
 *
 * @param uuid new Proximity UUID value
 * @param completion block handling operation completion
 *
 * @return void
 */
- (void)writeBeaconProximityUUID:(NSString *)uuid
                  withCompletion:(ABCompletionBlock)completion;

/**
 * Writes major param to bluetooth connected beacon.
 *
 * @param major major beacon value
 * @param completion block handling operation completion
 *
 * @return void
 */
- (void)writeBeaconMajor:(unsigned short)major
          withCompletion:(ABCompletionBlock)completion;

/**
 * Writes minor param to bluetooth connected beacon.
 *
 * @param minor minor beacon value
 * @param completion block handling operation completion
 *
 * @return void
 */
- (void)writeBeaconMinor:(unsigned short)minor
          withCompletion:(ABCompletionBlock)completion;

/**
 * Writes advertising interval (in milisec) of connected beacon.
 *
 * @param interval interval of beacon (50 - 2000 ms)
 * @param completion block handling operation completion
 *
 * @return void
 */
- (void)writeBeaconAdvInterval:(unsigned short)interval
                withCompletion:(ABCompletionBlock)completion;

/**
 * Writes command to connected beacon.
 *
 * @param command command of beacon
 * @param completion block handling operation completion
 *
 * @return void
 */
- (void)writeBeaconCommand:(NSString *)command
            withCompletion:(ABCompletionBlock)completion;

/**
 * Writes passcode to connected beacon.
 *
 * @param passcode passcode of beacon
 * @param completion block handling operation completion
 *
 * @return void
 */
- (void)writeBeaconPasscode:(NSString *)passcode
             withCompletion:(ABCompletionBlock)completion;


/**
 * Writes power to connected beacon.
 *
 * @param power new power of beacon
 * @param completion block handling operation completion
 *
 * @return void
 */
- (void)writeBeaconMeasuredPower:(unsigned short)power
                  withCompletion:(ABCompletionBlock)completion;

/**
 * Writes power of bluetooth connected beacon.
 *
 * @param power advertising beacon power (can take value from ABBeaconPowerLevel1 / waak to ABBeaconPowerLevel8 / strong)
 * @param completion block handling operation completion
 *
 * @return void
 */
- (void)writeBeaconTxPower:(ABTxPower)power
            withCompletion:(ABCompletionBlock)completion;

@end
