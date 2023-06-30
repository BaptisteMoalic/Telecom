function [rfMixerOut, PowerConsumption] = PC_upMixer(InputI,InputQ,Flo,continuousTimeFs)
    % Prise en compte de la consommation d'énergie
    %
    % Renvoie le résultat de upMixer, et l'énergie consommée par le
    % mélangeur
    %------------- BEGIN CODE --------------

    rfMixerOut = upMixer(InputI,InputQ,Flo,continuousTimeFs);

    PowerConsumption = 5*(10^(-12))*Flo;

%------------- END OF CODE --------------