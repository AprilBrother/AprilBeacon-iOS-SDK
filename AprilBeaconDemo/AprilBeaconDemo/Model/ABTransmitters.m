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
    NSArray *result = [[NSUserDefaults standardUserDefaults] arrayForKey:kTransmitterKey];
    if(nil == result) {
        [self setupData];
        result = [[NSUserDefaults standardUserDefaults] arrayForKey:kTransmitterKey];
    }
    return result;
}

- (void)addTransmitter:(NSDictionary *)transmitter {
    NSMutableArray *mutableResult = [[self transmitters] mutableCopy];
    [mutableResult addObject:transmitter];
    
    [[NSUserDefaults standardUserDefaults] setObject:mutableResult forKey:kTransmitterKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)replaceAtIndex:(NSInteger)index withTransmitter:(NSDictionary *)transmitter {
    NSMutableArray *mutableResult = [[self transmitters] mutableCopy];
    [mutableResult replaceObjectAtIndex:index withObject:transmitter];
    [[NSUserDefaults standardUserDefaults] setObject:mutableResult forKey:kTransmitterKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeTransmitterAtIndex:(NSInteger)index {
    NSMutableArray *mutableResult = [[self transmitters] mutableCopy];
    [mutableResult removeObjectAtIndex:index];
    
    [[NSUserDefaults standardUserDefaults] setObject:mutableResult forKey:kTransmitterKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - private

- (void)setupData {
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
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kTransmitterKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
