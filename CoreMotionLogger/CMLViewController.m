//
//  CMLViewController.m
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

#import "CMLViewController.h"

@implementation CMLViewController
@synthesize attitudeSwitch = _attitudeSwitch;
@synthesize gravitySwitch = _gravitySwitch;
@synthesize magneticFieldSwitch = _magneticFieldSwitch;
@synthesize rotationRateSwitch = _rotationRateSwitch;
@synthesize userAccelerationSwitch = _userAccelerationSwitch;
@synthesize rawGyroscopeSwitch = _rawGyroscopeSwitch;
@synthesize rawAccelerometerSwitch = _rawAccelerometerSwitch;
@synthesize startStopButton;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    // This could mean that our strings in the data logger are just getting too large
    // It's best here to stop and save what we have and throw up an alert to let the user know
    
    if (_loggingData) {
        [_myDataLogger stopLoggingMotionDataAndSave];
        
        _loggingData = false;
        
        // Update UI
        [startStopButton setTitle:@"Start" forState:UIControlStateNormal];
        _attitudeSwitch.enabled = true;
        _gravitySwitch.enabled = true;
        _magneticFieldSwitch.enabled = true;
        _rotationRateSwitch.enabled = true;
        _userAccelerationSwitch.enabled = true;
        _rawGyroscopeSwitch.enabled = false;
        _rawAccelerometerSwitch.enabled = false;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Need Moar Memory!"
                                                            message:@"The device is running out of memory. Logging has been stopped and the files have been saved. Feel free to start again!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Darn"
                                                  otherButtonTitles:nil];
        [alertView show];
    }

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _myDataLogger = [[DataLogger alloc] init];
    _loggingData = false;
    
    // Inform the data logger about the default values of the switches
    [_myDataLogger setLogAttitudeData:_attitudeSwitch.on];
    [_myDataLogger setLogGravityData:_gravitySwitch.on];
    [_myDataLogger setLogMagneticFieldData:_magneticFieldSwitch.on];
    [_myDataLogger setLogRotationRateData:_rotationRateSwitch.on];
    [_myDataLogger setLogUserAccelerationData:_userAccelerationSwitch.on];
    [_myDataLogger setLogRawGyroscopeData:_rawGyroscopeSwitch.on];
    [_myDataLogger setLogRawAccelerometerData:_rawAccelerometerSwitch.on];
}

- (void)viewDidUnload
{
    [self setStartStopButton:nil];
    [self setAttitudeSwitch:nil];
    [self setGravitySwitch:nil];
    [self setMagneticFieldSwitch:nil];
    [self setRotationRateSwitch:nil];
    [self setUserAccelerationSwitch:nil];
    [self setRawGyroscopeSwitch:nil];
    [self setRawAccelerometerSwitch:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - UI Event Handlers

- (IBAction)startStopButtonPressed:(id)sender {
    
    if (_loggingData) {
        
        [_myDataLogger stopLoggingMotionDataAndSave];
        
        _loggingData = false;
        
        // Update UI
        [startStopButton setTitle:@"Start" forState:UIControlStateNormal];
        _attitudeSwitch.enabled = true;
        _gravitySwitch.enabled = true;
        _magneticFieldSwitch.enabled = true;
        _rotationRateSwitch.enabled = true;
        _userAccelerationSwitch.enabled = true;
        _rawGyroscopeSwitch.enabled = false;
        _rawAccelerometerSwitch.enabled = false;
        
    } else {
        
        [_myDataLogger startLoggingMotionData];
        
        _loggingData = true;

        // Update UI
        [startStopButton setTitle:@"Stop and Save" forState:UIControlStateNormal];
        _attitudeSwitch.enabled = false;
        _gravitySwitch.enabled = false;
        _magneticFieldSwitch.enabled = false;
        _rotationRateSwitch.enabled = false;
        _userAccelerationSwitch.enabled = false;
        _rawGyroscopeSwitch.enabled = false;
        _rawAccelerometerSwitch.enabled = false;

    }    
    
}

- (IBAction)switchToggled:(UISwitch*)sender {
    
    if (sender == _attitudeSwitch) {
        [_myDataLogger setLogAttitudeData:sender.on];
    } else if (sender == _gravitySwitch) {
        [_myDataLogger setLogGravityData:sender.on];
    } else if (sender == _magneticFieldSwitch) {
        [_myDataLogger setLogMagneticFieldData:sender.on];
    } else if (sender == _rotationRateSwitch) {
        [_myDataLogger setLogRotationRateData:sender.on];
    } else if (sender == _userAccelerationSwitch) {
        [_myDataLogger setLogUserAccelerationData:sender.on];
    } else if (sender == _rawGyroscopeSwitch) {
        [_myDataLogger setLogRawGyroscopeData:sender.on];
    } else if (sender == _rawAccelerometerSwitch) {
        [_myDataLogger setLogRawAccelerometerData:sender.on];
    }
    
    
}


@end
