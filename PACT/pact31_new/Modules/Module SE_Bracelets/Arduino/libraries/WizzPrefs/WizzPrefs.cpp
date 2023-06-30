/* WizzPrefs.cpp */
#include "WizzPrefs.h"

extern unsigned char motorPattern[NB_PATTERNS][2][PATTERN_SIZE];

void WizzPrefs :: begin(bool firstTime){
    Preferences :: begin("motorPatt"); // on utilise l'espace de nom "motorPatt"
    if (firstTime){
        char nmspc[12];
        // S'il n'y a rien, pas assez ou trop dans l'espace "nom", on initialise à 0
        if (getBytesLength("motorPatt1")!=2*PATTERN_SIZE){
            //enregistre les bytes contenus dans motorPattern dans l'espace motorPatt
            Serial.print("Initialisation de la mémoire\n");
            unsigned char buffer[2*PATTERN_SIZE] = {0};
            for(int i=0;i<NB_PATTERNS;i++){
                sprintf(nmspc,"motorPatt%d",i+1);
                for (int j=0;j<PATTERN_SIZE;j++){
                    buffer[j]=motorPattern[i][0][j];
                    buffer[PATTERN_SIZE+j]=motorPattern[i][1][j];
                }
                Preferences::remove(nmspc); // nettoyage des valeurs avant d'en mettre des nouvelles
                putBytes(nmspc, buffer, 2*PATTERN_SIZE);
            }
        }
        else
        {
            //récupère les bytes contenus dans espace "nom" et stocke dans motorPattern
            unsigned char buffer[2*PATTERN_SIZE] = {0};
            for(int i=0;i<NB_PATTERNS;i++){
                sprintf(nmspc,"motorPatt%d",i+1);
                getBytes(nmspc, buffer , 2*PATTERN_SIZE);
                for (int j=0;j<PATTERN_SIZE;j++){
                    motorPattern[i][0][j]=buffer[j];
                    motorPattern[i][1][j]=buffer[PATTERN_SIZE+j];
                }
            }
        }
        end();
    }

}

void WizzPrefs :: savePattern(char index){
    char nmspc[12];
    unsigned char buffer[2*PATTERN_SIZE] = {0};
    begin(false);
    sprintf(nmspc,"motorPatt%d",index);
    for (int j=0;j<PATTERN_SIZE;j++){
        buffer[j]=motorPattern[index-1][0][j];
        buffer[PATTERN_SIZE+j]=motorPattern[index-1][1][j];
    }
    putBytes(nmspc, buffer, 2*PATTERN_SIZE);
    end();
}



