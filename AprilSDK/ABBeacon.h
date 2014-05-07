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

typedef enum {
    ABTxPower0DBM = 0,
    ABTxPower4DBM = 1,
    ABTxPowerMinus6DBM = 2,
    ABTxPowerMinus23DBM = 3
} ABTxPower;

typedef void(^ABCompletionBlock)(NSError* error);
typedef void(^ABUnsignedShortCompletionBlock)(unsigned short value, NSError* error);
typedef void(^ABPowerCompletionBlock)(ABTxPower value, NSError* error);
typedef void(^ABBoolCompletionBlock)(BOOL value, NSError* error);
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
 * Delegate method that indicates error in beacon connection.
 *
 * @param beacon reference to beacon object
 * @param error information about reason of error
 *
 * @return void
 */
- (void)beaconConnectionDidFail:(ABBeacon*)beacon withError:(NSError*)error;

/**
 * Delegate method that indicates success in beacon connection.
 *
 * @param beacon reference to beacon object
 *
 * @return void
 */
- (void)beaconConnectionDidSucceeded:(ABBeacon*)beacon;

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

@interface ABBeacon : NSObject

@property (nonatomic, weak) id <ABBeaconDelegate> delegate;

@property (nonatomic, strong)   NSUUID*                 proximityUUID;
@property (nonatomic, strong)   NSString *              macAddress;
@property (nonatomic, strong)   NSNumber*               major;
@property (nonatomic, strong)   NSNumber*               minor;
@property (nonatomic)           NSInteger               rssi;
@property (nonatomic, strong)   NSNumber*               distance;
@property (nonatomic)           CLProximity             proximity;
@property (nonatomic, strong)   NSNumber*               measuredPower;
@property (nonatomic, strong)   CBPeripheral*           peripheral;
@property (nonatomic, readonly)   BOOL                  isConnected;
@property (nonatomic)   ABTxPower               txPower;
@property (nonatomic, strong)   NSNumber*               advInterval;
@property (nonatomic, strong)   NSNumber*               batteryLevel;
//@property (nonatomic, strong)   NSString*               hardwareVersion;//



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
 * Writes Proximity UUID param to bluetooth connected beacon. Please  remember that If you change the UUID to your very own value anyone can read it, copy it and spoof your beacons. So if you are working on a mission critical application where security is an issue - be sure to implement it on your end. We are also working on a secure mode for our beacons and it will be included in one of the next firmware updates.
 *
 * @param pUUID new Proximity UUID value
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
 * @param advertising interval of beacon (50 - 2000 ms)
 * @param completion block handling operation completion
 *
 * @return void
 */
- (void)writeBeaconAdvInterval:(unsigned short)interval
                withCompletion:(ABCompletionBlock)completion;

- (void)writeBeaconCommand:(NSString *)command
            withCompletion:(ABCompletionBlock)completion;

- (void)writeBeaconPasscode:(NSString *)passcode
             withCompletion:(ABCompletionBlock)completion;

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
