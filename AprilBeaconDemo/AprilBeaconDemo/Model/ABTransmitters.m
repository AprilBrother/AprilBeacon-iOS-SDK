//
//  ABTransmitters.m
//  AprilBeacon
//
//  Created by yy on 14-1-26.
//  Copyright (c) 2014年 AprilBrother. All rights reserved.
//

#import "ABTransmitters.h"

#define kTransmitterKey @"transmitters"

@implementation ABTransmitters

#pragma mark - public

+ (ABTransmitters *)sharedTransmitters {
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [self new];
    });
    
    return sharedInstance;
}

- (NSArray *)transmitters {
    return [self setupData];
}

#pragma mark - private

- (NSArray *)setupData {
    NSArray *data = @[
                      @{
                          @"name" : @"AprilBeacon",
                          @"uuid" : @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0",
                          @"major" : @0,
                          @"minor" : @0,
                          @"power" : @-59
                          },
                      
                      @{
                          @"name" : @"Apple AirLocate",
                          @"uuid" : @"5A4BCFCE-174E-4BAC-A814-092E77F6B7E5",
                          @"major" : @0,
                          @"minor" : @0,
                          @"power" : @-59
                          },
                      @{
                          @"name" : @"Apple Airlocate",
                          @"uuid" : @"74278BDA-B644-4520-8F0C-720EAF059935",
                          @"major" : @0,
                          @"minor" : @0,
                          @"power" : @-59
                          },
                      ];
    return data;
}

@end
