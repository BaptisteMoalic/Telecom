//BRANCHEMENT BOUTON: les 2 pins du même côté
//une sur GND, une sur la pin d'interruption
//si pas INPUT_PULLUP dans pinMode, ajouter une résistance pull-up

struct Button {
  const uint8_t PIN;
  uint32_t numberKeyPresses;
  bool pressed;
};

Button button1 = {15, 0, false}; //PIN15

void IRAM_ATTR isr() {
  button1.numberKeyPresses += 1;
  button1.pressed = true;
}

void setup() {
  Serial.begin(115200);
  pinMode(button1.PIN, INPUT_PULLUP); //internal pullup resistors with the mode INPUT_PULLUP
  attachInterrupt(button1.PIN, isr, FALLING); //front descendant
}

void loop() {
  if (button1.pressed) {
      Serial.printf("Button 1 has been pressed %u times\n", button1.numberKeyPresses);
      button1.pressed = false;
  }

  //Detach Interrupt after 1 Minute
  static uint32_t lastMillis = 0;
  //millis() to check the number of milliseconds that have passed since the program first started
  //au bout de 1 min l'interruption est arrêtée
  if (millis() - lastMillis > 60000) {
    lastMillis = millis();
    detachInterrupt(button1.PIN);
  Serial.println("Interrupt Detached!");
  }
}
