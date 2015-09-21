//
//  ABBeaconManager.h
//  AprilBeaconSDK
//
//  Created by AprilBrother LLC on 14-4-1.
//  Copyright (c) 2014年 AprilBrother LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABBeaconRegion.h"

@import CoreBluetooth;
@import CoreLocation;

@class ABBeaconManager;
@class ABBeacon;
/**
 
 The ABBeaconManagerDelegate protocol defines the delegate methods to respond for related events.
 */

@protocol ABBeaconManagerDelegate <NSObject>

@optional

/**
 * Delegate method invoked during ranging.
 * Allows to retrieve NSArray of all discoverd beacons
 * represented with ABBeacon objects.
 *
 * @param manager April beacon manager
 * @param beacons all beacons as ABBeacon objects
 * @param region April beacon region
 *
 * @return void
 */
- (void)beaconManager:(ABBeaconManager *)manager
      didRangeBeacons:(NSArray *)beacons
             inRegion:(ABBeaconRegion *)region;

/**
 * Delegate method invoked when ranging fails
 * for particular region. Related NSError object passed.
 *
 * @param manager April beacon manager
 * @param region April beacon region
 * @param error object containing error info
 *
 * @return void
 */
- (void)beaconManager:(ABBeaconManager *)manager
rangingBeaconsDidFailForRegion:(ABBeaconRegion *)region
           withError:(NSError *)error;


/**
 * Delegate method invoked when monitoring fails
 * for particular region. Related NSError object passed.
 *
 * @param manager April beacon manager
 * @param region April beacon region
 * @param error object containing error info
 *
 * @return void
 */
- (void)beaconManager:(ABBeaconManager *)manager
monitoringDidFailForRegion:(ABBeaconRegion *)region
           withError:(NSError *)error;
/**
 * Method triggered when iOS device enters April
 * beacon region during monitoring.
 *
 * @param manager April beacon manager
 * @param region April beacon region
 *
 * @return void
 */
- (void)beaconManager:(ABBeaconManager *)manager
      didEnterRegion:(ABBeaconRegion *)region;


/**
 * Method triggered when iOS device leaves April
 * beacon region during monitoring.
 *
 * @param manager April beacon manager
 * @param region April beacon region
 *
 * @return void
 */
- (void)beaconManager:(ABBeaconManager *)manager
       didExitRegion:(ABBeaconRegion *)region;

/**
 * Method triggered when April beacon region state
 * was determined using requestStateForRegion:
 *
 * @param manager April beacon manager
 * @param state April beacon region state
 * @param region April beacon region
 *
 * @return void
 */
- (void)beaconManager:(ABBeaconManager *)manager
   didDetermineState:(CLRegionState)state
           forRegion:(ABBeaconRegion *)region;

/**
 * Method triggered when device starts advertising
 * as iBeacon.
 *
 * @param manager April beacon manager
 * @param error info about any error
 *
 * @return void
 */
- (void)beaconManagerDidStartAdvertising:(ABBeaconManager *)manager
                                   error:(NSError *)error;

@end



/**
 
 The ABBeaconManager class defines the interface for handling and configuring the April beacons and get related events to your application. You use an instance of this class to establish the parameters that describes each beacon behavior. You can also use a beacon manager object to retrieve all beacons in range.
 
 A beacon manager object provides support for the following location-related activities:
 
 * Monitoring distinct regions of interest and generating location events when the user enters or leaves those regions (works in background mode).
 * Reporting the range to nearby beacons and ther distance for the device.
 
 */

@interface ABBeaconManager : NSObject 

@property (nonatomic, weak) id <ABBeaconManagerDelegate> delegate;

/**
 Allows to avoid beacons with unknown state (proximity == 0), when ranging. Default value is NO.
 */
@property (nonatomic) BOOL avoidUnknownStateBeacons;

/*
 *  monitoredRegions
 *
 *  Discussion:
 *       Retrieve a set of objects for the regions that are currently being monitored.  If any Beacon manager
 *       has been instructed to monitor a region, during this or previous launches of your application, it will
 *       be present in this set.
 */
- (NSSet *)monitoredRegions;

/*
 *  rangedRegions
 *
 *  Discussion:
 *       Retrieve a set of objects representing the regions for which this Beacon manager is actively providing ranging.
 */
- (NSSet *)rangedRegions;


/*
 *  authorizationStatus
 *
 *  Discussion:
 *      Returns the current authorization status of the calling application.
 */
+ (CLAuthorizationStatus)authorizationStatus;

/*
 *  requestWhenInUseAuthorization
 *
 *  Discussion:
 *      When +authorizationStatus == kCLAuthorizationStatusNotDetermined,
 *      calling this method will trigger a prompt to request "when-in-use"
 *      authorization from the user.  If possible, perform this call in response
 *      to direct user request for a location-based service so that the reason
 *      for the prompt will be clear.  Any authorization change as a result of
 *      the prompt will be reflected via the usual delegate callback:
 *      -locationManager:didChangeAuthorizationStatus:.
 *
 *      If received, "when-in-use" authorization grants access to the user's
 *      location via -startUpdatingLocation/-startRangingBeaconsInRegion while
 *      in the foreground.  If updates have been started when going to the
 *      background, then a status bar banner will be displayed to maintain
 *      visibility to the user, and updates will continue until stopped
 *      normally, or the app is killed by the user.
 *
 *      "When-in-use" authorization does NOT enable monitoring API on regions,
 *      significant location changes, or visits, and -startUpdatingLocation will
 *      not succeed if invoked from the background.
 *
 *      When +authorizationStatus != kCLAuthorizationStatusNotDetermined, (ie
 *      generally after the first call) this method will do nothing.
 *
 *      If the NSLocationWhenInUseUsageDescription key is not specified in your
 *      Info.plist, this method will do nothing, as your app will be assumed not
 *      to support WhenInUse authorization.
 */
- (void)requestWhenInUseAuthorization __OSX_AVAILABLE_STARTING(__MAC_NA, __IPHONE_8_0);

/*
 *  requestAlwaysAuthorization
 *
 *  Discussion:
 *      When +authorizationStatus == kCLAuthorizationStatusNotDetermined,
 *      calling this method will trigger a prompt to request "always"
 *      authorization from the user.  If possible, perform this call in response
 *      to direct user request for a location-based service so that the reason
 *      for the prompt will be clear.  Any authorization change as a result of
 *      the prompt will be reflected via the usual delegate callback:
 *      -locationManager:didChangeAuthorizationStatus:.
 *
 *      If received, "always" authorization grants access to the user's
 *      location via any CLLocationManager API, and grants access to
 *      launch-capable monitoring API such as geofencing/region monitoring,
 *      significante location visits, etc.  Even if killed by the user, launch
 *      events triggered by monitored regions or visit patterns will cause a
 *      relaunch.
 *
 *      "Always" authorization presents a significant risk to user privacy, and
 *      as such requesting it is discouraged unless background launch behavior
 *      is genuinely required.  Do not call +requestAlwaysAuthorization unless
 *      you think users will thank you for doing so.
 *
 *      When +authorizationStatus != kCLAuthorizationStatusNotDetermined, (ie
 *      generally after the first call) this method will do nothing.
 *
 *      If the NSLocationAlwaysUsageDescription key is not specified in your
 *      Info.plist, this method will do nothing, as your app will be assumed not
 *      to support Always authorization.
 */
- (void)requestAlwaysAuthorization __OSX_AVAILABLE_STARTING(__MAC_NA, __IPHONE_8_0);

/// @name CoreLocation based iBeacon monitoring and ranging methods

/**
 * Range all April beacons that are visible in range.
 * Delegate method beaconManager:didRangeBeacons:inRegion:
 * is used to retrieve found beacons. Returned NSArray contains
 * ABBeacon objects.
 *
 * @param region April beacon region
 *
 * @return void
 */
- (void)startRangingBeaconsInRegion:(ABBeaconRegion*)region;

/**
 * Stops ranging April beacons.
 *
 * @param region April beacon region
 *
 * @return void
 */
- (void)stopRangingBeaconsInRegion:(ABBeaconRegion*)region;

/**
 * Start monitoring for particular region.
 * Functionality works in the background mode as well.
 * Every time you enter or leave region appropriet
 * delegate method inovked: beaconManager:didEnterRegtion:
 * and beaconManager:didExitRegion:
 *
 * @param region April beacon region
 *
 * @return void
 */
- (void)startMonitoringForRegion:(ABBeaconRegion*)region;

/**
 * Unsubscribe application from iOS monitoring of
 * April beacon region.
 *
 * @param region April beacon region
 *
 * @return void
 */
- (void)stopMonitoringForRegion:(ABBeaconRegion *)region;

/**
 * Allows to validate current state for particular region
 *
 * @param region April beacon region
 *
 * @return void
 */
- (void)requestStateForRegion:(ABBeaconRegion *)region;

/// @name Turning device into iBeacon

/**
 * Allows to turn device into virtual April beacon.
 *
 * @param proximityUUID proximity UUID beacon value
 * @param major minor beacon value
 * @param minor major beacon value
 * @param identifier unique identifier for you region
 *
 * @return void
 */
- (void)startAdvertisingWithProximityUUID:(NSUUID *)proximityUUID
                                   major:(CLBeaconMajorValue)major
                                   minor:(CLBeaconMinorValue)minor
                              identifier:(NSString*)identifier;

/**
 * Stop beacon advertising
 *
 * @return void
 */
- (void)stopAdvertising;

@end