EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L MCU_Module_New:Adafruit_Feather_HUZZAH32_ESP32 A?
U 1 1 606C4B16
P 5200 3300
F 0 "A?" H 5200 1911 50  0000 C CNN
F 1 "Adafruit_Feather_HUZZAH32_ESP32" H 5200 1820 50  0000 C CNN
F 2 "Module:Adafruit_Feather" H 5300 1950 50  0001 L CNN
F 3 "" H 5200 2100 50  0001 C CNN
	1    5200 3300
	1    0    0    -1  
$EndComp
$Comp
L Switch:SW_Push_Dual SW?
U 1 1 606C76D4
P 2550 1550
F 0 "SW?" H 2550 1835 50  0000 C CNN
F 1 "SW_Push_Dual" H 2550 1744 50  0000 C CNN
F 2 "" H 2550 1750 50  0001 C CNN
F 3 "~" H 2550 1750 50  0001 C CNN
	1    2550 1550
	1    0    0    -1  
$EndComp
$Comp
L Device:Q_NPN_BCE Q?
U 1 1 606C9F69
P 6350 3600
F 0 "Q?" H 6541 3646 50  0000 L CNN
F 1 "Q_NPN_BCE" H 6541 3555 50  0000 L CNN
F 2 "" H 6550 3700 50  0001 C CNN
F 3 "~" H 6350 3600 50  0001 C CNN
	1    6350 3600
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 606CA7A7
P 5400 1700
F 0 "#PWR?" H 5400 1450 50  0001 C CNN
F 1 "GND" H 5405 1527 50  0000 C CNN
F 2 "" H 5400 1700 50  0001 C CNN
F 3 "" H 5400 1700 50  0001 C CNN
	1    5400 1700
	1    0    0    -1  
$EndComp
$Comp
L Switch:SW_Push_Dual SW?
U 1 1 606CB5A5
P 3500 2500
F 0 "SW?" H 3500 2785 50  0000 C CNN
F 1 "SW_Push_Dual" H 3500 2694 50  0000 C CNN
F 2 "" H 3500 2700 50  0001 C CNN
F 3 "~" H 3500 2700 50  0001 C CNN
	1    3500 2500
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole_Pad H?
U 1 1 606CB8EF
P 3200 3200
F 0 "H?" V 3350 3250 50  0000 C CNN
F 1 "Led_Data" V 3300 3250 50  0000 C CNN
F 2 "" H 3200 3200 50  0001 C CNN
F 3 "~" H 3200 3200 50  0001 C CNN
	1    3200 3200
	0    -1   -1   0   
$EndComp
$Comp
L Device:C C?
U 1 1 606CBFAA
P 5250 1200
F 0 "C?" V 4998 1200 50  0000 C CNN
F 1 "100pF" V 5089 1200 50  0000 C CNN
F 2 "" H 5288 1050 50  0001 C CNN
F 3 "~" H 5250 1200 50  0001 C CNN
	1    5250 1200
	0    1    1    0   
$EndComp
$Comp
L Device:CP C?
U 1 1 606CCF44
P 5250 1550
F 0 "C?" V 5505 1550 50  0000 C CNN
F 1 "10uF" V 5414 1550 50  0000 C CNN
F 2 "" H 5288 1400 50  0001 C CNN
F 3 "~" H 5250 1550 50  0001 C CNN
	1    5250 1550
	0    -1   -1   0   
$EndComp
$Comp
L Switch:SW_Push_Dual SW?
U 1 1 606CE973
P 1700 2150
F 0 "SW?" H 1700 2435 50  0000 C CNN
F 1 "SW_Push_Dual" H 1700 2344 50  0000 C CNN
F 2 "" H 1700 2350 50  0001 C CNN
F 3 "~" H 1700 2350 50  0001 C CNN
	1    1700 2150
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 606CEF99
P 4050 3200
F 0 "R?" V 3843 3200 50  0000 C CNN
F 1 "400R - led" V 3934 3200 50  0000 C CNN
F 2 "" V 3980 3200 50  0001 C CNN
F 3 "~" H 4050 3200 50  0001 C CNN
	1    4050 3200
	0    1    1    0   
$EndComp
$Comp
L Device:R R?
U 1 1 606CFB25
P 6900 3050
F 0 "R?" H 6830 3004 50  0000 R CNN
F 1 "10R" H 6830 3095 50  0000 R CNN
F 2 "" V 6830 3050 50  0001 C CNN
F 3 "~" H 6900 3050 50  0001 C CNN
	1    6900 3050
	-1   0    0    1   
$EndComp
$Comp
L Device:R R?
U 1 1 606D01CC
P 5950 3600
F 0 "R?" V 5850 3550 50  0000 L CNN
F 1 "330R" V 5800 3500 50  0000 L CNN
F 2 "" V 5880 3600 50  0001 C CNN
F 3 "~" H 5950 3600 50  0001 C CNN
	1    5950 3600
	0    -1   -1   0   
$EndComp
$Comp
L power:+BATT #PWR?
U 1 1 606D03B0
P 5100 900
F 0 "#PWR?" H 5100 750 50  0001 C CNN
F 1 "+BATT" H 5115 1073 50  0000 C CNN
F 2 "" H 5100 900 50  0001 C CNN
F 3 "" H 5100 900 50  0001 C CNN
	1    5100 900 
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 606D2204
P 5650 4600
F 0 "#PWR?" H 5650 4350 50  0001 C CNN
F 1 "GND" V 5655 4472 50  0000 R CNN
F 2 "" H 5650 4600 50  0001 C CNN
F 3 "" H 5650 4600 50  0001 C CNN
	1    5650 4600
	0    -1   -1   0   
$EndComp
Wire Wire Line
	5200 4600 5650 4600
Wire Wire Line
	5100 900  5100 1200
Wire Wire Line
	5100 1200 5100 1550
Connection ~ 5100 1200
Wire Wire Line
	5100 1550 5100 2100
Connection ~ 5100 1550
Wire Wire Line
	5400 1200 5400 1550
Wire Wire Line
	5400 1700 5400 1550
Connection ~ 5400 1550
$Comp
L Mechanical:MountingHole_Pad H?
U 1 1 606DCF6E
P 2650 3250
F 0 "H?" H 2650 3450 50  0000 C CNN
F 1 "Led_GND" H 2650 3400 50  0000 C CNN
F 2 "" H 2650 3250 50  0001 C CNN
F 3 "~" H 2650 3250 50  0001 C CNN
	1    2650 3250
	1    0    0    -1  
$EndComp
Wire Wire Line
	4700 3200 4200 3200
Wire Wire Line
	3900 3200 3300 3200
$Comp
L power:+BATT #PWR?
U 1 1 606DDC63
P 2900 3450
F 0 "#PWR?" H 2900 3300 50  0001 C CNN
F 1 "+BATT" H 2915 3623 50  0000 C CNN
F 2 "" H 2900 3450 50  0001 C CNN
F 3 "" H 2900 3450 50  0001 C CNN
	1    2900 3450
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR?
U 1 1 606DE997
P 2650 3450
F 0 "#PWR?" H 2650 3200 50  0001 C CNN
F 1 "GND" H 2655 3277 50  0000 C CNN
F 2 "" H 2650 3450 50  0001 C CNN
F 3 "" H 2650 3450 50  0001 C CNN
	1    2650 3450
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole_Pad H?
U 1 1 606DCA96
P 2900 3250
F 0 "H?" H 2900 3550 50  0000 C CNN
F 1 "Led_3.7V" H 2900 3500 50  0000 C CNN
F 2 "" H 2900 3250 50  0001 C CNN
F 3 "~" H 2900 3250 50  0001 C CNN
	1    2900 3250
	1    0    0    -1  
$EndComp
Wire Wire Line
	2650 3350 2650 3450
Wire Wire Line
	2900 3350 2900 3450
Wire Wire Line
	5700 3600 5800 3600
$Comp
L power:GND #PWR?
U 1 1 606E38D6
P 6450 3950
F 0 "#PWR?" H 6450 3700 50  0001 C CNN
F 1 "GND" H 6455 3777 50  0000 C CNN
F 2 "" H 6450 3950 50  0001 C CNN
F 3 "" H 6450 3950 50  0001 C CNN
	1    6450 3950
	1    0    0    -1  
$EndComp
Wire Wire Line
	6450 3950 6450 3800
$Comp
L Mechanical:MountingHole_Pad H?
U 1 1 606E4351
P 7150 3400
F 0 "H?" V 7300 3450 50  0000 C CNN
F 1 "Vib-" V 7250 3500 50  0000 C CNN
F 2 "" H 7150 3400 50  0001 C CNN
F 3 "~" H 7150 3400 50  0001 C CNN
	1    7150 3400
	0    1    1    0   
$EndComp
Wire Wire Line
	6450 3400 7050 3400
$Comp
L Mechanical:MountingHole_Pad H?
U 1 1 606E4F78
P 7150 3200
F 0 "H?" V 7050 3250 50  0000 C CNN
F 1 "Vib+" V 7000 3250 50  0000 C CNN
F 2 "" H 7150 3200 50  0001 C CNN
F 3 "~" H 7150 3200 50  0001 C CNN
	1    7150 3200
	0    1    1    0   
$EndComp
Wire Wire Line
	7050 3200 6900 3200
Wire Wire Line
	5300 2100 5300 2000
Wire Wire Line
	5300 2000 6900 2000
Wire Wire Line
	6900 2000 6900 2900
Wire Wire Line
	6100 3600 6150 3600
$EndSCHEMATC
