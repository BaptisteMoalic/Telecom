function [SNR_freq] = Q23(Xpsd,sig_bin,Fs,fmin,fmax)

N = length(Xpsd);                                           % nombre de points 
bin_min = max(round(fmin/Fs*N),1);                          % bin minimal de la bande d'intégration
bin_max = min(round(fmax/Fs*N),floor(N/2));                 % bin maximal de la bande d'intégration

err_bin   = [bin_min : bin_max];                            % début et fin de la bande utile
nintsig   = 2;                                              % nombre de point autour du bin utile à integrer
PS_freq   = sum(Xpsd(sig_bin+1-nintsig:sig_bin+1+nintsig)); % calcul de la puissance du signal utile à + ou - 2 points de sig_bin 
PN_freq   = sum(Xpsd(err_bin))-PS_freq;                     % calcul de la puissance du bruit
SNR_freq  = 10*log10(PS_freq/PN_freq);                      % calcul du SNR
end

