function [lnaOutput, PowerConsumption] = PC_rfLNA(input,Gain,NF,IIP3,R,BW_noise)
    % Prise en compte de la consommation d'énergie
    %
    % Renvoie le résultat de rfLNA, et l'énergie consommée par le LNA
    %------------- BEGIN CODE --------------

    lnaOutput = rfLNA(input,Gain,NF,IIP3,R,BW_noise);
    
    
    PowerConsumption = (10^(-2))/(10^(NF/10)-1);
%------------- END OF CODE --------------