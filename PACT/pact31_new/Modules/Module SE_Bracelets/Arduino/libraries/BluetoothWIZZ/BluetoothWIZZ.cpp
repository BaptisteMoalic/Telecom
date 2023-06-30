/* BluetoothWIZZ.cpp */
#include "BluetoothWIZZ.h"
#include "Button_Push.h"

extern WizzPrefs prefs;
extern unsigned char motorPattern[NB_PATTERNS][2][PATTERN_SIZE];
extern Button button1;
extern char isRight;

BLEServer *OnionWizzDevice :: pServer = nullptr;
BLEService *OnionWizzDevice :: battServ = nullptr, *OnionWizzDevice :: pattServ = nullptr, *OnionWizzDevice :: modeServ = nullptr;
BLECharacteristic *OnionWizzDevice :: battChar = nullptr, *OnionWizzDevice :: pattModChar = nullptr, *OnionWizzDevice :: pattSelChar = nullptr,
                                                                                                    *OnionWizzDevice :: pattPlayChar = nullptr,
                                                                                                    *OnionWizzDevice :: isRightChar = nullptr,
                                                                                                    *OnionWizzDevice :: modeChar = nullptr;

void OnionWizzDevice :: init(std::string deviceName){
    BLEDevice::init(deviceName);
    char defaultVal = 1;
    pServer = createServer();

      // Création du service de visionnage de la batterie
    battServ = pServer->createService(BATTERY_SERVICE_UUID);
    pServer->setCallbacks(new ServCallback());

    // Création de la caractéristique associée
    battChar = battServ->createCharacteristic(
                                              BATTERY_CHAR_UUID,
                                              BLECharacteristic::PROPERTY_READ|
                                              BLECharacteristic::PROPERTY_NOTIFY
                                              );

    battChar->setValue("");

    // Création du Service de gestion des motifs moteur
    pattServ = pServer->createService(PATTERN_MODIF_SERVICE_UUID);

    // Création de la caractéristique "motif moteur"
    pattSelChar = pattServ->createCharacteristic(
                                                 PATTERN_SEL_CHAR_UUID,
                                                 BLECharacteristic::PROPERTY_WRITE
                                                 );
    pattModChar = pattServ->createCharacteristic(
                                                 PATTERN_MODIF_CHAR_UUID,
                                                 BLECharacteristic::PROPERTY_WRITE
                                                 );
    pattPlayChar = pattServ->createCharacteristic(
                                                  PATTERN_PLAY_CHAR_UUID,
                                                  BLECharacteristic::PROPERTY_WRITE
                                                  );
    isRightChar = pattServ->createCharacteristic(RIGHT_CHAR_UUID,
                                                 BLECharacteristic::PROPERTY_WRITE
                                                 );
    
    // on définit la fonction à appeler en cas d'intéraction avec la donnée
    pattSelChar->setCallbacks(new SelectCallback());
    pattModChar->setCallbacks(new MotorCallback(pattSelChar));
    pattPlayChar->setCallbacks(new PlayCallback());
    isRightChar->setCallbacks(new RightCallback());

    // on initialise la valeur des caractéristiques à 1
    pattSelChar->setValue(&defaultVal);
    pattModChar->setValue(&defaultVal);
    pattPlayChar->setValue(&defaultVal);

    modeServ = pServer->createService(MODE_SERVICE_UUID);
    modeChar = modeServ->createCharacteristic(
                                              MODE_CHAR_UUID,
                                              BLECharacteristic::PROPERTY_WRITE |
                                              BLECharacteristic::PROPERTY_NOTIFY
                                             );
    modeChar->setCallbacks(new ModeCallback());

    // Mise en route des services
    battServ->start();
    pattServ->start();
    modeServ->start();

    BLEAdvertising *pAdvertising = pServer->getAdvertising();
    pAdvertising->start();

}

void OnionWizzDevice :: checkBattery(){
    /* Static Method to check the Battery Level */

  char battCheckPin = 35; // on an ESP32, pin 35 is allocated for battery level measurement with 1/2 factor voltage divider
  int batteryLvl_i = 0;
  batteryLvl_i = analogRead(battCheckPin);
  float batteryLvl_f = ((((batteryLvl_i/MAX_ANALOG) * MAX_V_ANALOG * 2.0+DELTA_ERREUR)-MIN_BATTERY)/(MAX_BATTERY-MIN_BATTERY))*100;
  char batteryLvl = (char) batteryLvl_f;
  battChar->setValue(&batteryLvl); // set the battery level to be displayed
  if (batteryLvl<PERC_ALERT){
      battChar->notify();
  }
}

void OnionWizzDevice :: changeMode(){
    modeChar->setValue(button1.numberKeyPresses);
    modeChar->notify();
}


MotorCallback :: MotorCallback(BLECharacteristic *selCharac) : BLECharacteristicCallbacks(),selChar(selCharac)
{
    /* Callback for motorPattern modification, needs the reference to the selection Characteristic in order to know which pattern to overwrite. */
}


void MotorCallback :: onWrite(BLECharacteristic *pCharacteristic){
    std::string value = pCharacteristic->getValue(); // getting the new value sent by the user
    uint8_t *index = selChar->getData(); // getting the index of the pattern to overwrite
    if (value.length()==PATTERN_SIZE){
        for (int i=0;i<value.length();i++){
            switch (value[i])
            {
            case 255: // FF (gauche)
                motorPattern[*index-1][0][i]=255;
                motorPattern[*index-1][1][i]=0;
                break;
            
            case 187: // BB (les deux)
                motorPattern[*index-1][0][i]=255;
                motorPattern[*index-1][1][i]=255;
                break;
            
            case 221: // DD (droite)
                motorPattern[*index-1][0][i]=0;
                motorPattern[*index-1][1][i]=255;
                break;
            
            case 1: // FF (gauche)
                motorPattern[*index-1][0][i]=1;
                motorPattern[*index-1][1][i]=1;
                break;
            
            default:
                motorPattern[*index-1][0][i]=0;
                motorPattern[*index-1][1][i]=0;
                break;
            }
        }
        prefs.savePattern(*index); // saving the new pattern in Flash Memory
        Serial.println("Ecriture sur le motif " + String(*index));
        //displaying the content of the new motor pattern on serial
        Serial.println("Gauche:");
        for(int i=0;i<PATTERN_SIZE;i++){
            Serial.printf("%u ",motorPattern[*index-1][0][i]);
        }
        Serial.print("\n");
        Serial.println("Droite:");
        for(int i=0;i<PATTERN_SIZE;i++){
            Serial.printf("%u ",motorPattern[*index-1][1][i]);
        }
        Serial.print("\n");
    }
}

void SelectCallback :: onWrite(BLECharacteristic *pCharacteristic){

    std::string value = pCharacteristic->getValue();
    char defaultVal = 1;
    if (value.length()!=1){
        pCharacteristic->setValue(&defaultVal);
    }
    else if (!((0<value[0])&&(value[0]<=NB_PATTERNS))){
        pCharacteristic->setValue(&defaultVal);
    }

}

void PlayCallback :: onWrite(BLECharacteristic *pCharacteristic){

    std::string value = pCharacteristic->getValue();
    char defaultVal = 1;
    /*
    Serial.printf("Taille du nombre reçu %d\n",value.length());
    for (int i =0; i<value.length();i++){
        Serial.printf("%x\n", value[i]);
    }*/
    if (value.length()!=1){
        pCharacteristic->setValue(&defaultVal);
        return;
    }
    else if (!(0<value[0]<=NB_PATTERNS)){
        pCharacteristic->setValue(&defaultVal);
        return;
    }
    else {
        Serial.printf("Joue le motif n°%d\n",value[0]);
        playPattern(motorPattern[value[0]-1][isRight]);
    }

}

void ModeCallback :: onWrite(BLECharacteristic *pCharacteristic){
    std::string value = pCharacteristic->getValue();
    char defaultVal = 1;
    /*
    Serial.printf("Taille du mode reçu %d\n",value.length());
    for (int i =0; i<value.length();i++){
        Serial.printf("%x\n", value[i]);
    }*/
    if (value.length()!=1){
        pCharacteristic->setValue(&defaultVal);
        return;
    }
    else if (!(0<value[0]<=3)){
        pCharacteristic->setValue(&defaultVal);
        return;
    }
    else {
        Serial.printf("Valeur de mode modifiée: %d\n", value[0]);
        button1.numberKeyPresses=value[0];
        button1.pressed=true;
    }
}

void RightCallback :: onWrite(BLECharacteristic *pCharacteristic){
    std::string value = pCharacteristic->getValue();
    char defaultVal = 1;
    if (value.length()==1){
        if (0<=value[0]<=1){
            isRight = value[0];
        }
    }
}

void ServCallback :: onConnect(BLEServer *pServer){
    Serial.println("Connexion reçue");
}

void ServCallback :: onDisconnect(BLEServer *pServer){
    Serial.println("Client déconnecté");
}