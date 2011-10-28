# Core Motion Data Logger #

This is a simple utility to allow the easy capture of IMU data on iOS devices for offline use. I wanted to play around with data from the accelerometer, but I decided to include all of the sensors here in case I need different data in the future. 

![Core Motion Data Logger](https://github.com/pokeefe/CoreMotion-Data-Logger/raw/master/screenshot.png)

The aspects of the IMU that you can log follow directly from the CoreMotion documentation provided by apple. For more details regarding what each switch toggles, see the CoreMotion documentation [here](http://developer.apple.com/library/ios/#documentation/CoreMotion/Reference/CoreMotion_Reference/_index.html).

## Usage Notes ##

The txt files this app produces can be accessed from iTunes via the standard app file sharing interface. They can also be recovered using the Xcode Organizer.

This only works on iOS 5 because of Automatic Reference Counting and Storyboards. It doesn't currently check for sensor availability before logging...I'm not sure if there are any devices that run iOS 5 that don't have all these sensors. Either way, it's a TODO.

With the default update rates (100 Hz), it can take a few seconds to save all of the data to disk. On an iPhone 4S, a thirty second run while logging the user acceleration and rotation rate took about 5 seconds to save. A more efficient save method will probably have to be created if anyone wants to log data at these rates for very long periods of time.

## Output Format ##

I've chosen the following output formats, but they are easy to change if you find something else more convenient.

* CMDeviceMotion Attitude: `timestamp,roll,pitch,yaw\n`
* CMDeviceMotion Gravity: `timestamp,x,y,z\n`
* CMDeviceMotion Magnetic Field: `timestamp,x,y,z,(int)accuracy\n`
* CMDeviceMotion Rotation Rate: `timestamp,x,y,z\n`
* CMDeviceMotion User Acceleration: `timestamp,x,y,z\n`
* CMAccelerometerData Raw Acceleration: `timestamp,x,y,z\n`
* CMGyroData Raw Gyroscope: `timestamp,x,y,z\n`

There are alternative representations of the attitude (quaternions, rotation matrix). You will have to modify the source if you prefer logging one of those instead of roll/pitch/yaw.


## Offline Python Visualization ##

The ability to experiment with different algorithms to process the IMU data is the reason that I created this project in the first place. I've been working with SciPy/NumPy quite a bit these days as a beautiful, truly object oriented, free, and open source alternative to MATLAB. I've included an example script that you can use to parse and visualize the data that comes from CoreMotion Data Logger. Look under the Visualization directory to check it out. 

If you have the necessary packages installed (I don't remember what comes with Python these days), you can run the script by typing the following in your terminal:

    python exampleVisualizer.py

Here's one of the figures produced by the script:

![Data visualization](https://github.com/pokeefe/CoreMotion-Data-Logger/raw/master/Visualization/rotationRate.png)


## License ##

This project is covered under the MIT license.

Copyright (c) 2011 Patrick O'Keefe.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
