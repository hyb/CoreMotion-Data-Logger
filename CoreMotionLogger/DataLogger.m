//
//  DataLogger.m
//  CoreMotionLogger
//
//  Created by Patrick O'Keefe on 10/27/11.
//  Copyright (c) 2011 Patrick O'Keefe.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this
//  software and associated documentation files (the "Software"), to deal in the Software
//  without restriction, including without limitation the rights to use, copy, modify,
//  merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies
//  or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
//  PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
//  CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
//  THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "DataLogger.h"

@implementation DataLogger

@interface DataLogger (hidden)
- (void) processMotion:(CMDeviceMotion*)motion withError:(NSError*)error;
- (void) processAccel:(CMAccelerometerData*)accelData withError:(NSError*)error;
- (void) processGyro:(CMGyroData*)gyroData withError:(NSError*)error;
- (void) writeDataToDisk;
@end

- (id)init {

    self = [super init];
    if (self) {

        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.deviceMotionUpdateInterval = 0.01; //100 Hz
        _motionManager.accelerometerUpdateInterval = 0.01;
        _motionManager.gyroUpdateInterval = 0.01;

        // Limiting the concurrent ops to 1 is a cheap way to avoid two handlers editing the same
        // string at the same time.
        _deviceMotionQueue = [[NSOperationQueue alloc] init];
        [_deviceMotionQueue setMaxConcurrentOperationCount:1];

        _accelQueue = [[NSOperationQueue alloc] init];
        [_accelQueue setMaxConcurrentOperationCount:1];

        _gyroQueue = [[NSOperationQueue alloc] init];
        [_gyroQueue setMaxConcurrentOperationCount:1];

        _logAttitudeData = false;
        _logGravityData = false;
        _logMagneticFieldData = false;
        _logRotationRateData = false;
        _logUserAccelerationData = false;
        _logRawGyroscopeData = false;
        _logRawAccelerometerData = false;

        _attitudeString = [[NSString alloc] init];
        _gravityString = [[NSString alloc] init];
        _magneticFieldString = [[NSString alloc] init];
        _rotationRateString = [[NSString alloc] init];
        _userAccelerationString = [[NSString alloc] init];
        _rawGyroscopeString = [[NSString alloc] init];
        _rawAccelerometerString = [[NSString alloc] init];

    }

    return self;
}

- (void) startLoggingMotionData {

    NSLog(@"Starting to log motion data.");

    CMDeviceMotionHandler motionHandler = ^(CMDeviceMotion *motion, NSError *error) {
        [self processMotion:motion withError:error];
    };

    CMGyroHandler gyroHandler = ^(CMGyroData *gyroData, NSError *error) {
        [self processGyro:gyroData withError:error];
    };

    CMAccelerometerHandler accelHandler = ^(CMAccelerometerData *accelerometerData, NSError *error) {
        [self processAccel:accelerometerData withError:error];
    };


    if (_logAttitudeData || _logGravityData || _logMagneticFieldData || _logRotationRateData || _logUserAccelerationData ) {
        [_motionManager startDeviceMotionUpdatesToQueue:_deviceMotionQueue withHandler:motionHandler];
    }

    if (_logRawGyroscopeData) {
        [_motionManager startGyroUpdatesToQueue:_gyroQueue withHandler:gyroHandler];
    }

    if (_logRawAccelerometerData) {
        [_motionManager startAccelerometerUpdatesToQueue:_accelQueue withHandler:accelHandler];
    }

}

- (void) stopLoggingMotionData {

    NSLog(@"Stopping data logging.");

    [_motionManager stopDeviceMotionUpdates];
    [_deviceMotionQueue waitUntilAllOperationsAreFinished];

    [_motionManager stopAccelerometerUpdates];
    [_accelQueue waitUntilAllOperationsAreFinished];

    [_motionManager stopGyroUpdates];
    [_gyroQueue waitUntilAllOperationsAreFinished];

    // Save all of the data!
    [self writeDataToDisk];

}

- (void) processAccel:(CMAccelerometerData*)accelData withError:(NSError*)error {

    if (_logRawAccelerometerData) {
        _rawAccelerometerString = [_rawAccelerometerString stringByAppendingFormat:@"%f,%f,%f,%f\n", accelData.timestamp,
                                                           accelData.acceleration.x,
                                                           accelData.acceleration.y,
                                                           accelData.acceleration.z,
                                                           nil];
    }
}

- (void) processGyro:(CMGyroData*)gyroData withError:(NSError*)error {

    if (_logRawGyroscopeData) {
        _rawGyroscopeString = [_rawGyroscopeString stringByAppendingFormat:@"%f,%f,%f,%f\n", gyroData.timestamp,
                                                   gyroData.rotationRate.x,
                                                   gyroData.rotationRate.y,
                                                   gyroData.rotationRate.z,
                                                   nil];
    }
}

- (void) processMotion:(CMDeviceMotion*)motion withError:(NSError*)error {

    //    NSLog(@"Processing motion with motion pointer %p",motion);
    //    NSLog(@"Curr accel string %@",_userAccelerationString);

    if (_logAttitudeData) {
        _attitudeString = [_attitudeString stringByAppendingFormat:@"%f,%f,%f,%f\n", motion.timestamp,
                                           motion.attitude.roll,
                                           motion.attitude.pitch,
                                           motion.attitude.yaw,
                                           nil];
    }

    if (_logGravityData) {
        _gravityString = [_gravityString stringByAppendingFormat:@"%f,%f,%f,%f\n", motion.timestamp,
                                         motion.gravity.x,
                                         motion.gravity.y,
                                         motion.gravity.z,
                                         nil];
    }

    if (_logMagneticFieldData) {
        _magneticFieldString = [_magneticFieldString stringByAppendingFormat:@"%f,%f,%f,%f,%d\n", motion.timestamp,
                                                     motion.magneticField.field.x,
                                                     motion.magneticField.field.y,
                                                     motion.magneticField.field.z,
                                                     (int)motion.magneticField.accuracy,
                                                     nil];
    }

    if (_logRotationRateData) {
        _rotationRateString = [_rotationRateString stringByAppendingFormat:@"%f,%f,%f,%f\n", motion.timestamp,
                                                   motion.rotationRate.x,
                                                   motion.rotationRate.y,
                                                   motion.rotationRate.z,
                                                   nil];
    }

    if (_logUserAccelerationData) {
        _userAccelerationString = [_userAccelerationString stringByAppendingFormat:@"%f,%f,%f,%f\n", motion.timestamp,
                                                           motion.userAcceleration.x,
                                                           motion.userAcceleration.y,
                                                           motion.userAcceleration.z,
                                                           nil];
    }

}



- (void) setLogAttitudeData:(bool)newValue {
    _logAttitudeData = newValue;
}

- (void) setLogGravityData:(bool)newValue {
    _logGravityData = newValue;
}

- (void) setLogMagneticFieldData:(bool)newValue {
    _logMagneticFieldData = newValue;
}

- (void) setLogRotationRateData:(bool)newValue {
    _logRotationRateData = newValue;
}

- (void) setLogUserAccelerationData:(bool)newValue {
    _logUserAccelerationData = newValue;
}

- (void) setLogRawGyroscopeData:(bool)newValue {
    _logRawGyroscopeData = newValue;
}

- (void) setLogRawAccelerometerData:(bool)newValue {
    _logRawAccelerometerData = newValue;
}


- (void) writeDataToDisk {
    NSLog(@"Saving everything to disk!");

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterLongStyle];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];

    // Some filesystems hate colons
    NSString *dateString = [[dateFormatter stringFromDate:[NSDate date]] stringByReplacingOccurrencesOfString:@":" withString:@"_"];
    // I hate spaces
    dateString = [dateString stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    // Nobody can stand forward slashes
    dateString = [dateString stringByReplacingOccurrencesOfString:@"/" withString:@"_"];


    if (_logAttitudeData) {
        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"attitude_%@.txt", dateString, nil]];

        [_attitudeString writeToFile:fullPath
                          atomically:NO
                            encoding:NSStringEncodingConversionAllowLossy
                               error:nil];
        _attitudeString = @"";
    }

    if (_logGravityData) {
        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"gravity_%@.txt", dateString, nil]];

        [_gravityString writeToFile:fullPath
                         atomically:NO
                           encoding:NSStringEncodingConversionAllowLossy
                              error:nil];
        _gravityString = @"";
    }

    if (_logMagneticFieldData) {
        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"magneticField_%@.txt", dateString, nil]];

        [_magneticFieldString writeToFile:fullPath
                               atomically:NO
                                 encoding:NSStringEncodingConversionAllowLossy
                                    error:nil];
        _magneticFieldString = @"";
    }

    if (_logRotationRateData) {
        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"rotationRate_%@.txt", dateString, nil]];

        [_rotationRateString writeToFile:fullPath
                              atomically:NO
                                encoding:NSStringEncodingConversionAllowLossy
                                   error:nil];
        _rotationRateString = @"";
    }

    if (_logUserAccelerationData) {
        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"userAcceleration_%@.txt", dateString, nil]];

        [_userAccelerationString writeToFile:fullPath
                                  atomically:NO
                                    encoding:NSStringEncodingConversionAllowLossy
                                       error:nil];
        _userAccelerationString = @"";
    }

    if (_logRawGyroscopeData) {
        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"rawGyroscope_%@.txt", dateString, nil]];

        [_rawGyroscopeString writeToFile:fullPath
                              atomically:NO
                                encoding:NSStringEncodingConversionAllowLossy
                                   error:nil];
        _rawGyroscopeString = @"";
    }

    if (_logRawAccelerometerData) {
        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"rawAccelerometer_%@.txt", dateString, nil]];

        [_rawAccelerometerString writeToFile:fullPath
                                  atomically:NO
                                    encoding:NSStringEncodingConversionAllowLossy
                                       error:nil];
        _rawAccelerometerString = @"";
    }


}



@end
