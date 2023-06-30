/* Vibration_motor */

#ifndef VIBRATION_MOTOR_H_INCLUDED
#define VIBRATION_MOTOR_H_INCLUDED

#include <Arduino.h>
#include <Constants.h>

//ESP32 connection to vibrator
const int enable1Pin = 4; // PWM connected to transistor for Vibration Motor

// Setting PWM properties
const int freq = 30000;
const int pwmChannel = 0;
const int resolution = 8;

void initVibrationMotor();
void setVibration(int dutCy, int millisTime, int wait);
void playPattern(unsigned char pattern[]);

#endif // VIBRATION_MOTOR_H_INCLUDED
