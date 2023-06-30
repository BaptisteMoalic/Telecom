#include <BluetoothWIZZ.h>
#include <WizzPrefs.h>
#include <Constants.h>
#include <Vibration_motor.h>
WizzPrefs prefs;

#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>

unsigned char motorPattern[NB_PATTERNS][PATTERN_SIZE]={0};



void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  Serial.println("1- Download and install an BLE scanner app in your phone");
  Serial.println("2- Scan for BLE devices in the app");
  Serial.println("3- Connect to OnionWizz");
  Serial.println("4- Go to CUSTOM CHARACTERISTIC in CUSTOM SERVICE and read/write it");
  Serial.println("5- Verify the values are ok");

  prefs.begin(true);
  
  //affiche le contenu de mottorPattern (récupéré de la mémoire)
  Serial.print("Motifs: ");
  for(int i=0;i<NB_PATTERNS;i++){
    Serial.print("[ ");
    for(int j=0;j<PATTERN_SIZE;j++){
      Serial.printf("%u ",motorPattern[i][j]);
    }
    Serial.print("]\n");
  }
  initVibrationMotor();
  OnionWizzDevice::init("OnionWizz");
  

}

void loop() {
  // put your main code here, to run repeatedly:
  delay(2000);
  OnionWizzDevice::checkBattery();
}
