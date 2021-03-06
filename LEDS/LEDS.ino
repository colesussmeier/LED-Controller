
//Initialize fastLed variables
#include <FastLED.h>
#define NUM_LEDS    300
#define DATA_PIN    5
#define DATA_PIN_1  7
#define CHIPSET     WS2812B
#define COLOR_ORDER GRB

CRGB leds[NUM_LEDS];


int mode = 1;
float thishue = 0;
uint8_t fadeUp = 0;
int colorDelta = 0;
int beatHue = 1;


void fadeall() { for(int i = 0; i < NUM_LEDS; i++) { leds[i].nscale8(250); } }

void setup() {
  Serial.begin(9600);
  Serial.setTimeout(1000);
  //LEDS.addLeds<CHIPSET,5,COLOR_ORDER>(leds,NUM_LEDS);
  LEDS.addLeds<CHIPSET,7,COLOR_ORDER>(leds,NUM_LEDS);
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
  for( int i = 0; i < 5; i++) {
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
    
  //go forward
  for(int i = 0; i < NUM_LEDS; i++) {
    leds[i] = CHSV(hue++, 255, 255);
    FastLED.show(); 
    fadeall();
    delay(10);
  }

  //go back  
  for(int i = (NUM_LEDS)-1; i >= 0; i--) {
    leds[i] = CHSV(hue++, 255, 255);
    FastLED.show();
    fadeall();
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
