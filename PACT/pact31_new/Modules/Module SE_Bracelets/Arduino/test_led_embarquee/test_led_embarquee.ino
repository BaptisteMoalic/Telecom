void setup() {
  Serial.begin(9600); //Communication série
  pinMode(13, OUTPUT);

}

void loop() {
  delay(500);
  Serial.println("Test led embarquée: allumée");
  delay(500);
  digitalWrite(13, HIGH);   // turn the LED on (HIGH is the voltage level)
  delay(500);
  Serial.println("Test led embarquée: éteinte");
  delay(500);
  digitalWrite(13, LOW);   // turn the LED off (LOW is the voltage level)
}
