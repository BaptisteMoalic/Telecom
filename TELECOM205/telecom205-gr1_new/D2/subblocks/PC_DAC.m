function [AnalogOutput, PowerConsumption] = PC_DAC(input,Nbits,Vref,DACType,basebandFs,continuousTimeFs)
    % Prise en compte de la consommation d'énergie
    %
    % Renvoie le résultat de DAC, et l'énergie consommée par le DAC
    %------------- BEGIN CODE --------------

    AnalogOutput = DAC(input,Nbits,Vref,DACType,basebandFs,continuousTimeFs);

    PowerConsumption = (10^(-13))*basebandFs*(2^Nbits);
    
%------------- END OF CODE --------------