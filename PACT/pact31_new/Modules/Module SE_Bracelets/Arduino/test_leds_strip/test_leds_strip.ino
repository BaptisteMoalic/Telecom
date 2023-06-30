//LEDS STRIP
#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
 #include <avr/power.h> // Required for 16 MHz Adafruit Trinket
#endif

#define LED_PIN     21
#define LED_COUNT  8 //number of leds on the strip
// NeoPixel brightness, 0 (min) to 255 (max)
#define BRIGHTNESS 50 // Set BRIGHTNESS to about 1/5 (max = 255)
// Declare our NeoPixel strip object:
Adafruit_NeoPixel strip(LED_COUNT, LED_PIN, NEO_GRB + NEO_KHZ800);




void setup() {
  //INIT LEDS STRIP
  strip.begin();           // INITIALIZE NeoPixel strip object (REQUIRED)
  strip.show();            // Turn OFF all pixels ASAP
  strip.setBrightness(BRIGHTNESS);
  //SET USUAL COLORS
  uint32_t red = strip.Color(150,   0,   0);
  uint32_t green = strip.Color(0,   150,   0);
  uint32_t blue = strip.Color(0,   0,   150);
  uint32_t white = strip.Color(150,   150,   150);

  //INIT COM SERIE
  Serial.begin(115200);
  strip.setPixelColor(0, green);  
  strip.show(); 
  delay(1000);
  strip.setPixelColor(1, green);  
  strip.show(); 
  delay(1000);
  strip.setPixelColor(2, green);  
  strip.show(); 
  delay(1000);
  strip.setPixelColor(3, green);  
  strip.show(); 
  delay(1000);
  
  //ALL LEDS ON + MSG
  for(int i=0; i<strip.numPixels(); i++) { // For each pixel in strip...
    strip.setPixelColor(i, white);         //  Set pixel's color (in RAM)
    strip.show();                          //  Update strip to match
  }
  Serial.println("Bracelet ON");
  delay(1000);
  Serial.println("Clear");
  strip.clear();
  strip.show(); 
}

void loop() {
  // put your main code here, to run repeatedly:

}
