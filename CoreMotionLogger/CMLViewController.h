//
//  CMLViewController.h
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

#import <UIKit/UIKit.h>
#import "DataLogger.h"

@interface CMLViewController : UIViewController {
    
    DataLogger *_myDataLogger;
    bool        _loggingData;
    
}

@property (weak, nonatomic) IBOutlet UISwitch *attitudeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *gravitySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *magneticFieldSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *rotationRateSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *userAccelerationSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *rawGyroscopeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *rawAccelerometerSwitch;
@property (weak, nonatomic) IBOutlet UIButton *startStopButton;

- (IBAction)startStopButtonPressed:(id)sender;
- (IBAction)switchToggled:(id)sender;

@end
