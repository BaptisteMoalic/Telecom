/* Vibration_motor.cpp */

#include <Arduino.h>

#include "Vibration_motor.h"


void initVibrationMotor()
{
    // sets the pin as output
    pinMode(enable1Pin, OUTPUT);

    // configure LED PWM functionalities
    ledcSetup(pwmChannel, freq, resolution);

    // attach the channel to the GPIO to be controlled
    ledcAttachPin(enable1Pin, pwmChannel);
}

void setVibration(int dutCy, int millisTime, int wait)
{
    ledcWrite(pwmChannel, dutCy);
    delay(millisTime);
    ledcWrite(pwmChannel, 0);
    delay(wait);
}

void playPattern(unsigned char pattern[]){

  for (int i=0; i<PATTERN_SIZE;i++){
    if (pattern[i]==1){
      return;
    }
    setVibration(pattern[i],500,0);
  }

}


