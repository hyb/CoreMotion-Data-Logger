"""" Example of how to visualize the data produced by CoreMotion Data Logger.

Here we use matplotlib/pylab to plot the user acceleration and rotation rate data
from a trial run of CoreMotion Data Logger. This can be easily modified to plot
data from other sensors.
"""

import matplotlib.pyplot as plt
import numpy as np



def getCoreMotionDataFromFile(fileName):
    """ Given a file path, return a numpy array of the data contained
    in the file. The size of the array will vary based on the content of the file.

    """
    dataFile = open(fileName)

    # Unfortunately, this is the best way (that I know of) to get a file line count
    numLines = sum(1 for line in dataFile)

    # Read from the beginning of the file
    dataFile.seek(0,0)

    numRows = len(dataFile.readline().split(","))

    # Read from the beginning of the file (again)
    dataFile.seek(0,0)

    # Allocate space for our data
    data = np.zeros((numLines,numRows))

    # Assemble data
    for lineNum, line in enumerate(dataFile):
        lineData = line.split(",")
        for colIndex, elem in enumerate(lineData):
            data[lineNum, colIndex] = float(elem)


    dataFile.close()

    return data



userAccelFile = "userAcceleration_10_28_11_10_54_28_AM_EDT.txt"
userRotFile = "rotationRate_10_28_11_10_54_28_AM_EDT.txt"

########################
# Plot User Acceleration
########################

moarData = getCoreMotionDataFromFile(userAccelFile)

timestampData = moarData[:,0]
userAccelData = moarData[:,1:]

# Make the timestamp data more meaningful by subtracting the start time
timestampData -= timestampData[0]

f, (ax1, ax2, ax3) = plt.subplots(3, sharex=True, sharey=True)
ax1.plot(timestampData, userAccelData[:,0])
ax1.set_title('User Acceleration')
ax1.grid(True)
ax1.set_ylabel('X Acceleration')
ax2.plot(timestampData, userAccelData[:,1])
ax2.grid(True)
ax2.set_ylabel('Y Acceleration')
ax3.plot(timestampData, userAccelData[:,2])
ax3.grid(True)
ax3.set_ylabel('Z Acceleration')
ax3.set_xlabel('Time')


########################
# Plot Rotation Rate
########################

moarData = getCoreMotionDataFromFile(userRotFile)

timestampData = moarData[:,0]
userRotData = moarData[:,1:]

# Make the timestamp data more meaningful by subtracting the start time
timestampData -= timestampData[0]

f2, (ax12, ax22, ax32) = plt.subplots(3, sharex=True, sharey=True)
ax12.plot(timestampData, userRotData[:,0])
ax12.set_title('Rotation Rate')
ax12.grid(True)
ax12.set_ylabel('X Rotation')
ax22.plot(timestampData, userRotData[:,1])
ax22.grid(True)
ax22.set_ylabel('Y Rotation')
ax32.plot(timestampData, userRotData[:,2])
ax32.grid(True)
ax32.set_ylabel('Z Rotation')
ax32.set_xlabel('Time')

# Force python to remain open if you're running this from the command line
plt.show()
