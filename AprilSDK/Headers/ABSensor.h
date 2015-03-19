//
//  ABSensor.h
//  AprilBeaconSDK
//
//  Created by liaojinhua on 14-7-1.
//  Copyright (c) 2014年 li shuai. All rights reserved.
//

#import "ABBeacon.h"

/**
 *  ABAcceleration
 *
 *  Discussion:
 *    A structure containing 3-axis acceleration data.
 *
 *  Fields:
 *    x:
 *      X-axis acceleration in G's.
 *    y:
 *      Y-axis acceleration in G's.
 *	  z:
 *	    Z-axis acceleration in G's.
 */
typedef struct {
    double x;
    double y;
    double z;
} ABAcceleration;

/**
 *    Accelerometer value callback method.
 *
 *    @param acceleration @see ABAcceleration
 */
typedef void(^ABAccValueChangedBlock)(ABAcceleration acceleration);

/**
 *    Light value callback method.
 *
 *    @param light value.
 */
typedef void(^ABLightValueChangedBlock)(double light);


@interface ABSensor : ABBeacon
/**
 * Turn on/off accelerometer.
 * Accelerometer is on default
 *
 * @param on status of accelerometer
 * @param completion block handling operation completion
 *
 * @return void
 */
- (void)setAccelerometerOn:(BOOL)on WithCompletion:(ABCompletionBlock)completion;


/**
 * Turn on/off light sensor.
 * Light sensor is on default
 *
 * @param on status of light sensor
 * @param completion block handling operation completion
 *
 * @return void
 */
- (void)setLightSensorOn:(BOOL)on WithCompletion:(ABCompletionBlock)completion;

/**
 * Set block to receive acc value changed
 *
 * @param block the block to callback when value changed
 *
 * @return void
 */
- (void)setAccValueChangedBlock:(ABAccValueChangedBlock)block;

/**
 * Set block to receive light value changed
 *
 * @param block the block to callback when value changed
 *
 * @return void
 */
- (void)setLightValueChangedBlock:(ABLightValueChangedBlock)block;


@end
