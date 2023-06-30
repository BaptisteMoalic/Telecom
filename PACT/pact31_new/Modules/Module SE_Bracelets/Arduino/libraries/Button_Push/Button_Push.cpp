/* Button_Push.cpp */
#include "Button_Push.h"
#include <Arduino.h>

extern Button button1;
extern Button button2;

int last_time;
int now;

void initTimer(){
  last_time = millis();
}

void IRAM_ATTR isr() {
  now = millis();
  if (now - last_time>250){
    button1.numberKeyPresses += 1;
    button1.pressed = true;
    last_time = now;
  }
}

void IRAM_ATTR isr2(){
  button2.pressed = true;
}
