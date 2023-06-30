clear all
close all
Fs = 30e6;                  %fréquence d'échantillonnage 
Ts=1/Fs;
OSRsim = 16;                %facteur de sur échantillonnage
Fs_sim = OSRsim * Fs;       %fréquence d'émulation du temps continu
Tsim = 1/Fs_sim;
nb = [1:1:20];              % on fait varier le nombre de bit de la CAN de 1 à 20
Nsamples_in = 2^12;         %le nombre de points à l'entrée du CNA
Nsamples_out = OSRsim * Nsamples_in;
PE = 2;                     %pleine échelle

t = 0:Ts:(Nsamples_in)*Ts;  %vecteur temporel 
t=t(:);
t_OSR = t(1):Tsim:t(end)-Tsim; 
t_OSR=t_OSR(:);

fsig = 1e6;                 %fréquence du signal
sig_bin = round(fsig/Fs_sim*Nsamples_out);   %on met la fréquence sur un bin
fsig_bin = sig_bin*Fs_sim/Nsamples_out;      %on recalcule la fréquence
fmin = 0;                                 % fréquence minimale de la bande d'intégration
fmax = 10e6;                              % fréquence maximale de la bande d'intégration
BW = fmax - fmin;                         % bande d'intégration

x = PE/2*cos(2*pi*t*fsig_bin);          %construction du signal

SQNR_dB_mes = zeros(1,length(nb));                % on prépare un tableau vide pour les valeurs mesurées du SQNR
for i = 1 : 1 : length(nb)                      % on fait varier le nombre de bits de la CAN, le reste est fixé                                        
    x_quant = Quantification(x,PE,nb(i));   %on génère notre signal quantifié à la bonne fréquence
    y = CNA(t,x_quant,t_OSR);               %signal en sortie du CNA
    Ypsd = FFTpsd(y);                       %on calcule la FFT de y
    SQNR_dB_mes(i)=Calcul_SNR(Ypsd,sig_bin,Fs_sim,fmin,fmax); % pour chaque valeur de i on fait appel a Q23 qui retourne le SNR mesuré frequentiellement   
end    


SQNR_dB = 6.02 .* nb + 1.76 + 20*log10((2 * PE/2)/PE) + 10*log10(Fs/(2*BW)); % calcul du SQNR théorique


plot(nb,SQNR_dB)
xlabel('nombre de bits'); 
ylabel('SQNR en dB');
hold on
plot(nb,SQNR_dB_mes,'r')

