void setup() {
 Serial.begin(9600); //Communication série
}

void loop() {
 delay(500);
 Serial.println("Print chaque demi-seconde");
}
