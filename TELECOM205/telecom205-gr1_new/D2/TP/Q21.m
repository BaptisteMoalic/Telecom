function [x_quant] = Q21(x,PE,Nbits)

quantizedInput=floor((x+(PE/2))*2^(Nbits-1)/(PE/2));                    % quantification
quantizedInput(quantizedInput<0) = 0;                                   % les valeurs <0 sont remplacées par 0
quantizedInput(quantizedInput>2^Nbits-1) = 2^Nbits-1;                   % les valeurs >2^Nbits-1 sont remplacées par 2^Nbits-1
x_quant = (quantizedInput-2^(Nbits-1))/2^(Nbits-1)*(PE/2)+(PE/2)/2^Nbits; % x quantifié
end

