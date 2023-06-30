/* BluetoothWIZZ.h */

#include <Preferences.h>
#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include <ESP32AnalogRead.h>
#include <Arduino.h>
#include <WizzPrefs.h>
#include <Vibration_motor.h>

#ifndef BLUETOOTHWIZZ_H_INCLUDED
    #define BLUETOOTHWIZZ_H_INCLUDED

    #define PATTERN_MODIF_SERVICE_UUID         "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
    #define PATTERN_MODIF_CHAR_UUID            "beb5483e-36e1-4688-b7f5-ea07361b26a8"
    #define PATTERN_SEL_CHAR_UUID              "f5697e06-689e-11eb-9439-0242ac130002"
    #define PATTERN_PLAY_CHAR_UUID             "16d3cb22-6ac6-11eb-9439-0242ac130002"
    #define RIGHT_CHAR_UUID                    "e3e8e76f-e071-4b67-89ef-2f5ede75a9c6"

    #define MODE_SERVICE_UUID                  "a9769b38-b50d-4d7a-b7aa-75bc7f30488a"
    #define MODE_CHAR_UUID                     "9b457ddc-9b04-493d-87ed-c228f3b4d24f"

    #define MAX_BATTERY       4.2
    #define MIN_BATTERY       3.0
    #define MAX_ANALOG     4096.0
    #define MAX_V_ANALOG      3.3
    #define DELTA_ERREUR      0.15
    #define PERC_ALERT       30

    #define BATTERY_SERVICE_UUID "180f"
    #define BATTERY_CHAR_UUID    "2a19"




    class MotorCallback: public BLECharacteristicCallbacks {
        public:
            MotorCallback(BLECharacteristic *selChar);
        private:
            void onWrite(BLECharacteristic *pCharacteristic);
            BLECharacteristic *selChar;


    };

    class SelectCallback: public BLECharacteristicCallbacks {
        void onWrite(BLECharacteristic *pCharacteristic);
    };

    class PlayCallback: public BLECharacteristicCallbacks {
        void onWrite(BLECharacteristic *pCharacteristic);
    };

    class ModeCallback: public BLECharacteristicCallbacks {
        void onWrite(BLECharacteristic *pCharacteristic);
    };

    class RightCallback: public BLECharacteristicCallbacks {
        void onWrite(BLECharacteristic *pCharacteristic);
    };

    class ServCallback: public BLEServerCallbacks {
        void onConnect(BLEServer *pServer);
        void onDisconnect(BLEServer *pServer);
    };

    class OnionWizzDevice: public BLEDevice {
        public:
            static void init(std::string deviceName);
            static void checkBattery();
            static void changeMode();
        private:
            static BLEServer *pServer;
            static BLEService *battServ, *pattServ, *modeServ;
            static BLECharacteristic *battChar, *pattModChar, *pattSelChar, *pattPlayChar, *isRightChar, *modeChar;
    };


#endif // BLUETOOTHWIZZ_H_INCLUDED
