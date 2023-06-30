function [OutputI,OutputQ, PowerConsumption] = PC_downMixer(InputRF,Flo,continuousTimeFs)
    % Prise en compte de la consommation d'énergie
    %
    % Renvoie le résultat de downMixeur, et l'énergie consommée par le
    % mélangeur
    %------------- BEGIN CODE --------------

    [OutputI,OutputQ] = downMixer(InputRF,Flo,continuousTimeFs);

    PowerConsumption = 5*(10^(-12))*Flo;

%------------- END OF CODE --------------