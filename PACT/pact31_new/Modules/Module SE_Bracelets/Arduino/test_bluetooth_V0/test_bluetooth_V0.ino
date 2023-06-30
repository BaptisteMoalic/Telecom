#include <ESP32AnalogRead.h>

#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>

#define MAX_BATTERY 4.2
#define MIN_BATTERY 3.0
#define MAX_ANALOG 4096.0
#define MAX_V_ANALOG 3.3
#define DELTA_ERREUR 0.15

#define BATTERY_SERVICE_UUID "180f"
#define BATTERY_CHAR_UUID    "2a19"

BLEServer *pServer = NULL;
BLEService *battServ = NULL;
BLECharacteristic *battChar = NULL;


class MyCallbacks: public BLECharacteristicCallbacks {
    void onRead(BLECharacteristic *pCharacteristic) {
      uint8_t* value = pCharacteristic->getData();

      Serial.println("*********");
      Serial.print("Sent value: ");
      Serial.print(*value); // Value est un pointeur, on doit donc récupérer la valeur pointée.

      Serial.println();
      Serial.println("*********");
    }
};



void checkBattery(){

  char battCheckPin = 35;
  int batteryLvl_i = 0;
  batteryLvl_i = analogRead(battCheckPin);
  //TO DO: convertir valeur analogique batterie "162" m*3.3/4096 *2
  float batteryLvl_f = ((((batteryLvl_i/MAX_ANALOG) * MAX_V_ANALOG * 2.0+DELTA_ERREUR)-MIN_BATTERY)/(MAX_BATTERY-MIN_BATTERY))*100;
  char batteryLvl = (char) batteryLvl_f;
  battChar->setValue(&batteryLvl);
}


void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  Serial.println("1- Download and install an BLE scanner app in your phone");
  Serial.println("2- Scan for BLE devices in the app");
  Serial.println("3- Connect to OnionWizz");
  Serial.println("4- Go to BATTERY CHARACTERISTIC in BATTERY SERVICE and read it");
  Serial.println("5- Verify the coherence of the battery level");

  BLEDevice::init("OnionWizz");
  pServer = BLEDevice::createServer();

  // Création du service de visionnage de la batterie
  battServ = pServer->createService(BATTERY_SERVICE_UUID);

  // Création de la caractéristique associée
  battChar = battServ->createCharacteristic(
                              BATTERY_CHAR_UUID,
                              BLECharacteristic::PROPERTY_READ
                              );

  // Pour le moment on y associe un callback de Débuggage
  battChar->setCallbacks(new MyCallbacks());

  battChar->setValue("");

  // Mise en route des services
  battServ->start();

  BLEAdvertising *pAdvertising = pServer->getAdvertising();
  pAdvertising->start();

}

void loop() {
  // put your main code here, to run repeatedly:
  delay(2000);
  checkBattery();
}
