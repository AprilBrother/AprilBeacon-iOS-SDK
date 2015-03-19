//
//  ABTransmitters.h
//  AprilBeacon
//
//  Created by yy on 14-1-26.
//  Copyright (c) 2014年 AprilBrother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABTransmitters : NSObject

+ (ABTransmitters *)sharedTransmitters;

- (NSArray *)transmitters;
- (NSArray *)historyUUIDs;
- (void)addHistoryUUID:(NSString *)uuid;
- (BOOL)addTransmitter:(NSDictionary *)transmitter;
- (void)replaceAtIndex:(NSInteger)index withTransmitter:(NSDictionary *)transmitter;
- (void)removeTransmitterAtIndex:(NSInteger)index;

@end
