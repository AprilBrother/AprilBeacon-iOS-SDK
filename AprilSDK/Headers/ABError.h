//
//  ABError.h
//  AprilBeaconSDK
//
//  Created by liaojinhua on 15/3/13.
//  Copyright (c) 2015年 li shuai. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const ABErrorDomain;

extern NSString * const ABErrorInfoKey;

extern NSString * const ABErrorNotConnectedString;

typedef NS_ENUM(NSInteger, ABError) {
    ABErrorUnknown = 0,
    ABErrorInvalidParameters = 1,
    ABErrorNotConnected = 2,
};