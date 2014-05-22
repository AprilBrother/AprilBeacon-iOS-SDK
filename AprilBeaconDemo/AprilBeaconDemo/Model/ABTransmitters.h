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

@end
