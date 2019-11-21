
//Initialize fastLed variables
#include <FastLED.h>
#define NUM_LEDS    150
#define DATA_PIN    5
#define CHIPSET     WS2812B
#define COLOR_ORDER GRB

CRGB leds[NUM_LEDS];


int mode = 1; //changed 
float thishue = 0;
uint8_t fadeUp = 0;
int colorDelta = 0;
int beatHue = 1;


void fadeall() { for(int i = 0; i < NUM_LEDS; i++) { leds[i].nscale8(250); } }

void setup() {
  Serial.begin(9600);
  Serial.setTimeout(1000);
  LEDS.addLeds<CHIPSET,DATA_PIN,COLOR_ORDER>(leds,NUM_LEDS);
  LEDS.setBrightness(255);
  
}

unsigned long beatMillis = millis();

void loop() {
  
 unsigned long currentMillis = millis();


   if (Serial.available() > 0) {
  mode = Serial.read(); // read the incoming byte:
}



//colored lines shooting back and forth
if(mode==1) { 
  fadeToBlackBy( leds, NUM_LEDS, 20);
  byte dothue = 0;
  for( int i = 0; i < 8; i++) {
    leds[beatsin16(i+14,0,NUM_LEDS)] |= CHSV(dothue, 250, 255);
    dothue += 32;
    }
    FastLED.show();
  }

//rainbow
if(mode == 2) {
    static uint8_t starthue = 0;    thishue+= 0.5;
    fill_rainbow(leds, NUM_LEDS, thishue, 1);
    FastLED.show();
  }

//red white and blue
if(mode==3) {
    for(int i=0; i<(NUM_LEDS/3); i++) {
      leds[i] = CRGB(255,255,255);
      FastLED.show();
    }

    for(int i=(NUM_LEDS/3); i<(NUM_LEDS/3)*2; i++) {
      leds[i] = CRGB(255,0,0);
      FastLED.show();
    }
    for(int i=(NUM_LEDS/3)*2; i<NUM_LEDS; i++) {
      leds[i] = CRGB(0,0,255);
      FastLED.show();
    }
  }

//cylon
if(mode == 4) {
    static uint8_t hue = 0;
    
  //go foward
  for(int i = 0; i < NUM_LEDS; i++) {
    // Set the i'th led to red 
    leds[i] = CHSV(hue++, 255, 255);
    // Show the leds
    FastLED.show(); 
    // now that we've shown the leds, reset the i'th led to black
    // leds[i] = CRGB::Black;
    fadeall();
    // Wait a little bit before we loop around and do it again
    delay(10);
  }


  //go back  
  for(int i = (NUM_LEDS)-1; i >= 0; i--) {
    // Set the i'th led to red 
    leds[i] = CHSV(hue++, 255, 255);
    // Show the leds
    FastLED.show();
    // now that we've shown the leds, reset the i'th led to black
    // leds[i] = CRGB::Black;
    fadeall();
    // Wait a little bit before we loop around and do it again
    delay(10);
  }
}

//beat visualization
if(mode == 6) {
     for(int i=0; i<NUM_LEDS; i++) {
      leds[i] = leds[i] = CHSV(beatHue, 255, 255);
    }
    colorDelta = 255;
    FastLED.show();
     mode = 5;
  }
if(mode == 5||mode ==6) {
  colorDelta *= .99;
  if(beatMillis%2000==0){beatHue++;}
  for(int i=0; i<NUM_LEDS; i++) {
      leds[i] = CHSV(beatHue, 255, colorDelta);
    }
    FastLED.show();
  } 
}
