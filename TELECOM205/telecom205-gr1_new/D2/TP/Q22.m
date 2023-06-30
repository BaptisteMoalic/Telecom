Fs = 30e6;                                  % fréquence d'échantillonnage
PE = 2;                                     % pleine échelle
Nbits = 10;                                 % nombre de bits
N = 2^(16);                                 % nombre de points
Ts = 1/Fs;                                  % période d'échantillonnage
t = 0:Ts:(N-1)*Ts;                          % vecteur temporel
t = reshape(t,N,1);                         % on passe d'un vecteur ligne à colonne
Amp = PE/2;                                 % ici l'amplitude vaut Vref    
f = 1e6 ;                                   % fréquence de la sinusoïde
sig_bin   = round(f/Fs*N);                  % on met la fréquence sur un bin
fsig      = sig_bin*Fs/N;                   % on recalcule la fréquence

x = Amp * cos(2*pi*fsig*t);                 % construction du signal

x_quant = Q21(x,PE,Nbits);                  % on génère notre signal quantifié à la bonne fréquence

win = blackman(length(x_quant),'periodic'); % fenetre de type blackman
x_windowed = x_quant(:).*win(:);            % on fenêtre x
Xpsd = abs(fft(x_windowed)).^2;             % calcul de la fft PSD de x fenetré
Xpsd = Xpsd/length(Xpsd);                   % normalisation

bin_freq_val_shift = -(length(Xpsd)-1)/2 : (length(Xpsd)-1)/2;  % recalibration des bins
freq_val_shift = bin_freq_val_shift/length(Xpsd)*Fs;            % création de l'échelle en fréquence à partir des bins
plot(freq_val_shift,fftshift(10*log10(Xpsd))) ;                 % plot de la fft PSD
xlim(Fs/2*[-1 1]);
xlabel('Frequency (Hz)'); 
ylabel('Power spectral density (dB)');