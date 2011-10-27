//
//  DataLogger.h
//  CoreMotionLogger
//
//  Created by Patrick O'Keefe on 10/27/11.
//  Copyright (c) 2011 Patrick O'Keefe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@interface DataLogger : NSObject {

    CMMotionManager *_motionManager;
    
    NSOperationQueue *_deviceMotionQueue;
    NSOperationQueue *_accelQueue;
    NSOperationQueue *_gyroQueue;
    
    NSString *_attitudeString;
    NSString *_gravityString;
    NSString *_magneticFieldString;
    NSString *_rotationRateString;
    NSString *_userAccelerationString;
    NSString *_rawGyroscopeString;
    NSString *_rawAccelerometerString;


    bool _logAttitudeData;
    bool _logGravityData;
    bool _logMagneticFieldData;
    bool _logRotationRateData;
    bool _logUserAccelerationData;
    bool _logRawGyroscopeData;
    bool _logRawAccelerometerData;

}

- (void) startLoggingMotionData;
- (void) stopLoggingMotionData;

// Setters
- (void) setLogAttitudeData:(bool)newValue;
- (void) setLogGravityData:(bool)newValue;
- (void) setLogMagneticFieldData:(bool)newValue;
- (void) setLogRotationRateData:(bool)newValue;
- (void) setLogUserAccelerationData:(bool)newValue;
- (void) setLogRawGyroscopeData:(bool)newValue;
- (void) setLogRawAccelerometerData:(bool)newValue;


@end
