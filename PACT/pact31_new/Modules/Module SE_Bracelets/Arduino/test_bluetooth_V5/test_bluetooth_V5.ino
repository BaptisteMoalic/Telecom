#include <ESP32AnalogRead.h>
#include <Preferences.h>
Preferences prefs;

#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>

#define PATTERN_MODIF_SERVICE_UUID         "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define PATTERN_MODIF_CHAR_UUID             "beb5483e-36e1-4688-b7f5-ea07361b26a8"
#define PATTERN_SEL_CHAR_UUID              "f5697e06-689e-11eb-9439-0242ac130002"

#define PATTERN_SIZE  10
#define NB_PATTERNS   10

#define MAX_BATTERY       4.2
#define MIN_BATTERY       3.0
#define MAX_ANALOG     4096.0
#define MAX_V_ANALOG      3.3
#define DELTA_ERREUR      0.15

#define BATTERY_SERVICE_UUID "180f"
#define BATTERY_CHAR_UUID    "2a19"



BLEServer *pServer = NULL;
BLEService *battServ = NULL, *pattServ = NULL;
BLECharacteristic *battChar = NULL, *pattModChar = NULL, *pattSelChar = NULL;
unsigned char motorPattern[NB_PATTERNS][PATTERN_SIZE] = {0};

class BattCallback: public BLECharacteristicCallbacks {
    void onRead(BLECharacteristic *pCharacteristic) {
      uint8_t* value = pCharacteristic->getData();

      Serial.println("*********");
      Serial.print("Sent value: ");
      Serial.print(*value); // Value est un pointeur, on doit donc récupérer la valeur pointée.

      Serial.println();
      Serial.println("*********");
    }
};

class MotorCallback: public BLECharacteristicCallbacks {
    void onRead(BLECharacteristic *pCharacteristic) {
      
      // TO DO: faire jouer le motif
      Serial.println("lecture");
      //affiche le contenu de mottorPattern (récupéré de la mémoire)
      for(int i=0;i<PATTERN_SIZE;i++){
        Serial.printf("%u ",motorPattern[0][i]);
      }
      Serial.print("\n");
    }

    void onWrite(BLECharacteristic *pCharacteristic){
      std::string value = pCharacteristic->getValue();
      char nmspc[12];
      uint8_t *index = pattSelChar->getData();
      if (value.length()==PATTERN_SIZE){
        for (int i=0;i<value.length();i++){
          motorPattern[*index-1][i]=value[i];
        }
      }
      prefs.begin("motorPatt");
      sprintf(nmspc,"motorPatt%d",*index);
      prefs.putBytes(nmspc, motorPattern[*index-1], PATTERN_SIZE);
      prefs.end();
      // TO DO: faire jouer le nouveau motif
      Serial.println("ecriture sur le motif " + String(*index));
      //affiche le contenu de mottorPattern (récupéré de la mémoire)
      for(int i=0;i<PATTERN_SIZE;i++){
        Serial.printf("%u ",motorPattern[*index-1][i]);
      }
      Serial.print("\n");
    }
};

class SelectCallback: public BLECharacteristicCallbacks {
    
    void onWrite(BLECharacteristic *pCharacteristic){
      
      std::string value = pCharacteristic->getValue();
      char defaultVal = 1;
      if (value.length()!=1){
        pCharacteristic->setValue(&defaultVal);
      }
      else if (!(0<value[0]<=PATTERN_SIZE)){
        pCharacteristic->setValue(&defaultVal);
      }
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
  Serial.println("4- Go to CUSTOM CHARACTERISTIC in CUSTOM SERVICE and read/write it");
  Serial.println("5- Verify the values are ok, and that the ESP doesn't loop-boot");

  prefs.begin("motorPatt"); // on utilise l'espace de nom "motorPatt"
  char nmspc[12];
  // S'il n'y a rien dans l'espace "nom", on initialise à 0
  if (prefs.getBytesLength("motorPatt1")!=PATTERN_SIZE){
    //enregistre les bytes contenus dans motorPattern dans l'espace motorPatt
    Serial.print("Initialisation de la mémoire\n");
    for(int i=0;i<NB_PATTERNS;i++){
      sprintf(nmspc,"motorPatt%d",i+1);
      prefs.putBytes(nmspc, motorPattern[i], PATTERN_SIZE);
    }
  }
  else
  {
    //récupère les bytes contenus dans espace "nom" et stocke dans motorPattern
    for(int i=0;i<NB_PATTERNS;i++){
      sprintf(nmspc,"motorPatt%d",i+1);
      prefs.getBytes(nmspc, motorPattern[i], PATTERN_SIZE);
    }
  }
  prefs.end();

  //affiche le contenu de mottorPattern (récupéré de la mémoire)
  Serial.print("Motifs: ");
  for(int i=0;i<NB_PATTERNS;i++){
    Serial.print("[ ");
    for(int j=0;j<PATTERN_SIZE;j++){
      Serial.printf("%u ",motorPattern[i][j]);
    }
    Serial.print("]\n");
  }
  

  char defaultVal = 1;
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
  battChar->setCallbacks(new BattCallback());

  battChar->setValue("");

  // Création du Service de gestion des motifs moteur
  pattServ = pServer->createService(PATTERN_MODIF_SERVICE_UUID);

  // Création de la caractéristique "motif moteur"
  pattSelChar = pattServ->createCharacteristic(
                              PATTERN_SEL_CHAR_UUID,
                              BLECharacteristic::PROPERTY_WRITE 
                              | BLECharacteristic::PROPERTY_READ
                              );
  pattModChar = pattServ->createCharacteristic(
                              PATTERN_MODIF_CHAR_UUID,
                              BLECharacteristic::PROPERTY_WRITE
                              );
                              
  // on définit la fonction à appeler en cas d'intéraction avec la donnée
  pattSelChar->setCallbacks(new SelectCallback());
  pattModChar->setCallbacks(new MotorCallback());
  
  // on initialise la valeur des caractéristiques à 1
  pattSelChar->setValue(&defaultVal);
  pattModChar->setValue(&defaultVal);
  

  // Mise en route des services
  battServ->start();
  pattServ->start();

  BLEAdvertising *pAdvertising = pServer->getAdvertising();
  pAdvertising->start();

}

void loop() {
  // put your main code here, to run repeatedly:
  delay(2000);
  checkBattery();
}
