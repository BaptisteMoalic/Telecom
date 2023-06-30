#include <Vibration_motor.h>

#define PATTERN_SIZE 5
unsigned char motorPattern[PATTERN_SIZE]={255,0,255,0,255};

void playPattern(unsigned char pattern[]){

  for (int i=0; i<PATTERN_SIZE;i++){
    setVibration(pattern[i],500,0);
  }
  
}


void setup() {
  // put your setup code here, to run once:
  initVibrationMotor();
}

void loop() {
  // put your main code here, to run repeatedly:
  playPattern(motorPattern);
  delay(3000);
}
