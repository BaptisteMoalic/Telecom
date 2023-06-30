#include <BluetoothWIZZ.h>
#include <WizzPrefs.h>
#include <Leds_strip.h>
#include <Vibration_motor.h>
#include <Button_Push.h>
#include <Constants.h>
#include <Ticker.h>

WizzPrefs prefs;
Adafruit_NeoPixel strip(LED_COUNT, LED_PIN, NEO_GRB + NEO_KHZ800);
Ticker schedule;
//SET USUAL COLORS
const uint32_t red = strip.Color(150,   0,   0);
const uint32_t green = strip.Color(0,   150,   0);
const uint32_t blue = strip.Color(0,   0,   150);
unsigned char motorPattern[NB_PATTERNS][PATTERN_SIZE]={0};
Button button1 = {GPIO_NUM_15, 1, false}; //PIN15
Button button2 = {GPIO_NUM_32, 1, false}; //PIN 32
bool authorizedPlay = false;

void setup() {
  //init
  Serial.begin(115200);
  esp_sleep_enable_ext0_wakeup(button2.PIN, 0);
  initLedsStrip();
  initTimer();
  pinMode(button1.PIN, INPUT_PULLUP); //internal pullup resistors with the mode INPUT_PULLUP
  pinMode(button2.PIN, INPUT);
  attachInterrupt (button1.PIN, isr, FALLING); //falling edge
  attachInterrupt (button2.PIN, isr2, RISING); //rising edge
  initVibrationMotor();
  prefs.begin(true);
  OnionWizzDevice::init("OnionWizz");
  OnionWizzDevice::checkBattery();
  
  //all leds on + starting message
  ledsBraceletOn();
  strip.clear();
  strip.setPixelColor(0, red);
  strip.show();   
  Serial.println("MODE 1: Nothing going on");
  
  //affiche le contenu de mottorPattern (récupéré de la mémoire)
  Serial.print("Motifs: ");
  for(int i=0;i<NB_PATTERNS;i++){
    Serial.print("[ ");
    for(int j=0;j<PATTERN_SIZE;j++){
      Serial.printf("%u ",motorPattern[i][j]);
    }
    Serial.print("]\n");
  }
  schedule.attach(10,OnionWizzDevice::checkBattery);
}


void loop() {
  if (button1.pressed) {
    OnionWizzDevice::changeMode();
    if (button1.numberKeyPresses == 1) {
      strip.clear();
      strip.setPixelColor(0, red);
      strip.show();
      Serial.println("MODE 1: Nothing going on");
      authorizedPlay = false;
    }
    else if (button1.numberKeyPresses == 2) {
      strip.clear();
      strip.setPixelColor(1, blue);
      strip.show();   
      Serial.println("MODE 2: Vibration order via bluetooth ");
      authorizedPlay = true;
    }
    else if (button1.numberKeyPresses == 3) {
      strip.clear();
      strip.setPixelColor(2, green);
      strip.show();
      button1.numberKeyPresses = 0;
      Serial.println("MODE 3: Check battery ");
      authorizedPlay = false;
      OnionWizzDevice::checkBattery();
    }
    else{
      button1.numberKeyPresses = 1;
    }
    button1.pressed = false;
  }
  if (button2.pressed) {
    strip.clear();
    strip.show();
    button2.pressed = false;
    esp_deep_sleep_start();
  }
}
