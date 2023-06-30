/* Leds_strip.cpp */

#include <Arduino.h>
#include "Leds_strip.h"

extern Adafruit_NeoPixel strip;
//SET USUAL COLORS
extern const uint32_t green;
const uint32_t white = strip.Color(150,   150,   150);

void initLedsStrip()
{
    strip.begin();           // INITIALIZE NeoPixel strip object (REQUIRED)
    strip.show();            // Turn OFF all pixels ASAP
    strip.setBrightness(BRIGHTNESS);
}

//All leds in white for 1 sec
void ledsBraceletOn()
{
    for(int i=0; i<strip.numPixels(); i++) { // For each pixel in strip...
    strip.setPixelColor(i, white);         //  Set pixel's color (in RAM)
    strip.show();                          //  Update strip to match
    }
    Serial.println();
    Serial.println("Bracelet ON");
    delay(1000);

    Serial.println("Clear");
    strip.clear();
    strip.show();
}
