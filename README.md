# LED-Controller
A program to control WS2812B lights from a user interface

LED-Controller provides a user interface written in Processing 3 in order to control individually addressable LED lights from a computer. The interface includes a beat detection feature that routes the live audio output of the computer into the program so that a clean, latency-free signal can be utilized. Additonally, the user interface allows for users to select and add modes that correspond with effects written to the microcontroller. This program is intended to provide the framework of an LED controller so that addidional effects and control features can be added easily. 

![alt text](https://github.com/colesussmeier/LED-Controller/blob/master/demo.gif)
# Setup
## Hardware
Below is a wiring diagram for two sets of WS2812B lights being controlled by an Arduino. The use of two LED strips is not reflected in the software, but it can be easily added by sending signals to more than one data pin.

![alt text](https://github.com/colesussmeier/LED-Controller/blob/master/WiringDiagram.png)

## Software
The arduino IDE is required to run the code in the LEDS (Arduino) folder. The Fast.LED library is also required for this file, this can be found in Tools-> Manage Libraries. For the LEDCONTROL (Processing) folder, the processing IDE, the Minim library, and the Processing.Sound library will be needed. These libraries can be found at Sketch->Import Library-> Add Library.

In order to setup the audio signal loop for the beat detection, Windows users will need to go to Sound Panel->Recording->Right click to show disabled devices->Enable Stereo Mix. For Mac, an alternative to stereo mix will need to be downloaded. Without this, the program will still work, however the audio signal will come from the mic input and may not behave well.

Mac users: When defining port name in the Processing file, the COM port may not be 0th in the list, so if this is the case the 0 will need to get changed to a 1 in order to establish a connection with the Arduino.
