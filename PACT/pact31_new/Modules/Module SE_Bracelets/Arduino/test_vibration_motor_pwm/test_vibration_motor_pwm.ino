
//ESP32 connection to vibrator
int enable1Pin = 4; // PWM connected to transistor for Vibration Motor

// Setting PWM properties
const int freq = 30000;
const int pwmChannel = 0;
const int resolution = 8;
int dutyCycle = 200;


void setup()
{
 // sets the pin as output
  pinMode(enable1Pin, OUTPUT);
  
  // configure LED PWM functionalitites
  ledcSetup(pwmChannel, freq, resolution);
  
  // attach the channel to the GPIO to be controlled
  ledcAttachPin(enable1Pin, pwmChannel);

  Serial.begin(115200);

  // testing
  Serial.print("Testing DC Motor...");
}


void loop()
{
  //variation PWM de 10 à 255
  /*while (dutyCycle <= 255){
    ledcWrite(pwmChannel, dutyCycle);   
    Serial.print("Forward with duty cycle: ");
    Serial.println(dutyCycle);
    dutyCycle = dutyCycle + 5;
    delay(500);
  }
  dutyCycle = 10;*/

  //dutyCycle   I_vib_motor
  //    255       60 mA
  //    149       35 mA

  //variation intensité moyenne puis max
  dutyCycle = 149;
  ledcWrite(pwmChannel, dutyCycle);   
  Serial.print("Forward with duty cycle: ");
  Serial.println(dutyCycle);
  delay(3000); //3s
  dutyCycle = 255;
  ledcWrite(pwmChannel, dutyCycle);   
  Serial.print("Forward with duty cycle: ");
  Serial.println(dutyCycle);
  delay(3000); //3s
  
}
