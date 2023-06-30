/* Button_Push.h */

#ifndef BUTTON_PUSH_H_INCLUDED
#define BUTTON_PUSH_H_INCLUDED

#include <Arduino.h>

struct Button {
  const gpio_num_t PIN;
  uint32_t numberKeyPresses;
  bool pressed;
};

void initTimer();

void IRAM_ATTR isr();
void IRAM_ATTR isr2();

#endif // BUTTON_PUSH_H_INCLUDED
