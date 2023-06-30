function [Vref,Nbits] = numerisation_quantification(Vref_ext,Nbits_ext)
t = 0:0.01:2;
Vref = Vref_ext; 
Nbits = Nbits_ext;
x = cos(2*pi*1*t);
quantizedInput=floor((x+Vref)*2^(Nbits-1)/Vref); % Quantizing the sampled data
quantizedInput(quantizedInput<0) = 0; % Clipping Down
quantizedInput(quantizedInput>2^Nbits-1) = 2^Nbits-1; % Clipping Up
DigOutput = (quantizedInput-2^(Nbits-1))/2^(Nbits-1)*Vref+Vref/2^Nbits;
stem(t,DigOutput); 
xlabel('Temps (s)'); 
ylabel('Sortie Quantifiee')
end

