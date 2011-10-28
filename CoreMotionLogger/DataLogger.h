//
//  DataLogger.h
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

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

/**
 * DataLogger
 *
 * Class that can receive motion updates from CoreMotion, append new motion data
 * to strings in a specified format, and ultimately save that data to the app's
 * documents directory with a timestamp.
 */
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

/**
 * startLoggingMotionData
 *
 * This method uses the boolean instance variables to tell the CMMotionManager what
 * to do. The three main types of IMU capture each have their own NSOperationQueue.
 * A queue will only be utilized if its respective motion type is going to be logged.
 *
 */
- (void) startLoggingMotionData;

/**
 * stopLoggingMotionDataAndSave
 *
 * Tells the CMMotionManager to stop the motion updates and calls the writeDataToDisk
 * method. The only gotchya is that we wait for the NSOperationQueues to finish
 * what they are doing first so that we're not accessing the same resource from
 * different points in the program.
 */
- (void) stopLoggingMotionDataAndSave;

// Setters
- (void) setLogAttitudeData:(bool)newValue;
- (void) setLogGravityData:(bool)newValue;
- (void) setLogMagneticFieldData:(bool)newValue;
- (void) setLogRotationRateData:(bool)newValue;
- (void) setLogUserAccelerationData:(bool)newValue;
- (void) setLogRawGyroscopeData:(bool)newValue;
- (void) setLogRawAccelerometerData:(bool)newValue;


@end
