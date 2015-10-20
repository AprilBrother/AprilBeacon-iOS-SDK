//
//  ABDefinitions.h
//  ConfigTool
//
//  Created by gongliang on 15/7/21.
//  Copyright (c) 2015年 April Brother. All rights reserved.
//

#import <Foundation/Foundation.h>

/// April Beacon power value definition
typedef NS_ENUM(NSInteger, ABTxPower)  {
    /** Default value for tx power */
    ABTxPower0DBM = 0,
    /** The max value for tx power */
    ABTxPower4DBM = 1,
    /** Small value for tx power */
    ABTxPowerMinus6DBM = 2,
    /** The value for tx power */
    ABTxPowerMinus23DBM = 3,
    /** Tx power definition, only used in EEK beacon */
    ABTxPowerMinus20DBM = 4
};

/// April beacon broadcast type definition
typedef NS_ENUM(NSInteger, ABBroadcastType) {
    /** Default broadcast type */
    ABBeaconBroadcastiBeacon,
    /** Google Eddystone Uid type */
    ABBeaconBroadcastEddystoneUid,
    /** Google Eddystone URL type */
    ABBeaconBroadcastEddystoneURL
};

/**
 *    callback method.
 *
 *    @param error nil or specific error.
 */
typedef void(^ABCompletionBlock)(NSError* error); 

