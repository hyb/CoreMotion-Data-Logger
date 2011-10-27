//
//  CMLViewController.h
//  CoreMotionLogger
//
//  Created by Patrick O'Keefe on 10/27/11.
//  Copyright (c) 2011 Patrick O'Keefe. All rights reserved.
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
