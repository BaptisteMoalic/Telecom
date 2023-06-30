function [DigOutput, PowerConsumption] = PC_ADC(input,Nbits,Vref,adcSamplingRate,delay,continuousTimeFs)
    % Prise en compte de la consommation d'énergie
    %
    % Renvoie le résultat de ADC, et l'énergie consommée par l'ADC
    %------------- BEGIN CODE --------------

    DigOutput = ADC(input,Nbits,Vref,adcSamplingRate,delay,continuousTimeFs);
 
    PowerConsumption = (10^(-13))*adcSamplingRate*(2^Nbits);
    
%------------- END OF CODE --------------