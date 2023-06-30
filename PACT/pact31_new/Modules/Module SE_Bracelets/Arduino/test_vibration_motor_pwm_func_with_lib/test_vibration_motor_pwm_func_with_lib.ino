#include <Vibration_motor.h>

void setup()
{
  Serial.begin(115200);
  
  initVibrationMotor();
  Serial.print("Vibration Motor Init");
}


void loop()
{  
  Serial.println("Vibration d'une sec toutes les 3 sec");
  setVibration(150, 1000, 3000);
  
}
