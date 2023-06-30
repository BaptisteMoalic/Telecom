#include <Preferences.h>
Preferences prefs;

#define PATTERN_SIZE 10


unsigned char motorPattern[PATTERN_SIZE]={0};

void setup() {
  Serial.begin(115200);
  prefs.begin("motorPatt"); // on utilise l'espace de nom "motorPatt"

  // S'il n'y a rien dans l'espace "nom", on initialise à 0
  if (prefs.getBytesLength("motorPatt")!=PATTERN_SIZE){
    //enregistre les bytes contenus dans motorPattern dans l'espace motorPatt
    prefs.putBytes("motorPatt", motorPattern, sizeof(motorPattern));
  }
  else
  {
    //récupère les bytes contenus dans espace "nom" et stocke dans motorPattern
    prefs.getBytes("motorPatt", motorPattern, PATTERN_SIZE);
  }

  //affiche ligne par ligne le contenu de mottorPattern (récupéré de la mémoire)
  for(int i=0;i<PATTERN_SIZE;i++){
    Serial.printf("%u ",motorPattern[i]);
  }
  Serial.print("\n");
  prefs.end();
  
}

void loop() {
  prefs.begin("motorPatt");
  if (Serial.available()>0){
    //lis les "PATTERN_SIZE" premiers bytes entrés sur le moniteur série et les stocke dans motorPattern
    Serial.readBytes(motorPattern,PATTERN_SIZE);
    //lis les autres caractères et ne les stocke pas (permet d'ignorer les autres caractères)
    Serial.readString();
    //affiche ligne par ligne le contenu de mottorPattern (récupéré de la mémoire)
    for(int i=0;i<PATTERN_SIZE;i++){
      Serial.printf("%u ",motorPattern[i]);
    }
    Serial.print("\n");
    //enregistre les bytes contenus dans motorPattern dans l'espace motorPatt
    prefs.putBytes("motorPatt", motorPattern, sizeof(motorPattern));
  }
  
  prefs.end();

  delay(2000);
  
}
