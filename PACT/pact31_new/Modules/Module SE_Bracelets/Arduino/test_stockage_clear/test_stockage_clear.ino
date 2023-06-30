#include <Preferences.h>
Preferences prefs;

#define PATTERN_SIZE 10


unsigned char motorPattern[PATTERN_SIZE]={0};

void setup() {
  Serial.begin(115200);
  prefs.begin("motorPatt"); // on utilise l'espace de nom "motorPatt"

  prefs.clear();
  prefs.end();
  Serial.print("Nettoyage terminé");
  
  
  
}

void loop() {
  delay(2000);
  
}
