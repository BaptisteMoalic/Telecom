#include <analogWrite.h>

const char motorPin=2;
String deviceName = "OnionWizz";
void setup() {
 Serial.begin(9600); //Communication série
}

void play_pattern(char pattern[]){
  /* Fonction pour jouer un motif de vibration avec les moteurs*/

  /* pour le moment, le motif est un tableau d'entiers allant de 0 à 255 */
  for (int i=0;i<sizeof(pattern)/sizeof(char);i++){
    analogWrite(motorPin,pattern[i]);
    delay(1);
  }
}


void loop() {
 delay(500);
 Serial.println("Print chaque demi-seconde");
}
