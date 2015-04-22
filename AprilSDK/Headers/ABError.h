//
//  ABError.h
//  AprilBeaconSDK
//
//  Created by liaojinhua on 15/3/13.
//  Copyright (c) 2015年 li shuai. All rights reserved.
//

#import <Foundation/Foundation.h>

/// April Beacon Error Domain
extern NSString * const ABErrorDomain;

/// April Beacon Error Info Key
extern NSString * const ABErrorInfoKey;

/// Error message
extern NSString * const ABErrorNotConnectedString;

/// April Beacon Error Definition
typedef NS_ENUM(NSInteger, ABError) {
    /** Unknown error */
    ABErrorUnknown = 0,
    /** Value of parameter is not valid */
    ABErrorInvalidParameters = 1,
    /** Can't write data when Beacon is not connected */
    ABErrorNotConnected = 2,
};