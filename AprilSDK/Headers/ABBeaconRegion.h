//
//  ABBeaconRegion.h
//  AprilBeaconSDK
//
//  Created by AprilBrother LLC on 14-4-1.
//  Copyright (c) 2014 AprilBrother LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@import CoreLocation;

/**
 
 A ABBeaconRegion object defines a type of region that is based on the device’s proximity to a Bluetooth beacon, as opposed to a geographic location. A beacon region looks for devices whose identifying information matches the information you provide. When that device comes in range, the region triggers the delivery of an appropriate notification.
 
 You can monitor beacon regions in two ways. To receive notifications when a device enters or exits the vicinity of a beacon, use the startMonitoringForRegion: method of your location manager object. While a beacon is in range, you can also call the startRangingBeaconsInRegion: method to begin receiving notifications when the relative distance to the beacon changes.
 
 ABBeaconRegion extends basic CLBeaconRegion Core Location object, 
 
 */

@interface ABBeaconRegion : CLBeaconRegion

@end
