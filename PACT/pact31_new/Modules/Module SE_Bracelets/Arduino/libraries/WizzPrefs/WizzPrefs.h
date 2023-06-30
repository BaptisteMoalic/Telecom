/* WizzPrefs.h */
#include <Preferences.h>
#include <Arduino.h>
#include <Constants.h>

#ifndef WIZZPREFS_H_INCLUDED
#define WIZZPREFS_H_INCLUDED

class WizzPrefs : public Preferences {
    public:
        void begin(boolean firstTime);
        void savePattern(char index);
};

#endif // WIZZPREFS_H_INCLUDED
