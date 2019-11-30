# LED-Controller
A program to control WS2812B lights from a user interface

LED-Controller provides a user interface written in Processing 3 in order to control individually addressable LED lights from a computer. The interface includes a beat detection feature that routes the live audio output of the computer into the program so that a clean, latency-free signal can be utilized. Additonally, the user interface allows for users to select and add modes that correspond with effects written to the microcontroller. This program is intended to provide the framework of an LED controller so that addidional effects and control features can be added easily. 

# Set up
## Hardware
Below is a wiring diagram for two sets of WS2812B lights being controlled by an Arduino Mega. The Mega is not required but it provides plenty of memory to allow for scalability. 

-pointer to img file

## Software
The arduino IDE is required to run the code in the LEDS folder. The Fast.LED library is required 
