/* Leds_strip.h */

#ifndef LEDS_STRIP_H_INCLUDED
#define LEDS_STRIP_H_INCLUDED

#include <Arduino.h>
#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
 #include <avr/power.h> // Required for 16 MHz Adafruit Trinket
#endif

#define LED_PIN     21
#define LED_COUNT  3 //number of leds on the strip
// NeoPixel brightness, 0 (min) to 255 (max)
#define BRIGHTNESS 50 // Set BRIGHTNESS to about 1/5 (max = 255)

void initLedsStrip();
void ledsBraceletOn();

#endif // LEDS_STRIP_H_INCLUDED
