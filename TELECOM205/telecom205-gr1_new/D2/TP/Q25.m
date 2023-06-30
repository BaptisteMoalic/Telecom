Fs = 30e6;                                % fréquence d'échantillonnage
PE = 2;                                   % pleine échelle
Amp = [0.1:0.1:PE/2];                     % on fait varier l'amplitude de 0 à Vref
Nbits = 10;                               % nombre de bits
N = 2^(16);                               % nombre de points
Ts = 1/Fs;                                % période d'échantillonnage
t = 0:Ts:(N-1)*Ts;                        % vecteur temporel
t = reshape(t,N,1);                       % on passe d'un vecteur ligne à colonne
f = 1e6 ;                                 % fréquence de la sinusoïde
sig_bin   = round(f/Fs*N);                % on met la fréquence sur un bin
fsig      = sig_bin*Fs/N;                 % on recalcule la fréquence

fmin = 0;                                 % fréquence minimale de la bande d'intégration
fmax = 10e6;                              % fréquence maximale de la bande d'intégration
BW = fmax - fmin;                         % bande d'intégration

SQNR_dB_mes = zeros(length(Amp));               % on prépare un tableau vide pour les valeurs mesurées du SQNR
for i = 1 : 1 : length(Amp)                     % on fait varier la valeur de l'amplitude de la sinusoide                                       
    x = Amp(i) * cos(2*pi*fsig*t);              % construction du signal pour chaque valeur de Amp
    x_quant = Q21(x,PE,Nbits);                  % pour chaque valeur de i on fait appel à Q21 qui retourne le signal quantifié
    win = blackman(length(x_quant),'periodic'); % fenetre de type blackman
    x_windowed = x_quant(:).*win(:);            % on fenêtre x
    Xpsd = abs(fft(x_windowed)).^2;             % calcul de la fft PSD de x fenetré
    Xpsd = Xpsd/length(Xpsd);
    SQNR_dB_mes(i)=Q23(Xpsd,sig_bin,Fs,fmin,fmax); % pour chaque valeur de i on fait appel a Q23 qui retourne le SNR mesuré frequentiellement   
end    

figure()
subplot(2,1,1)
SQNR_dB = 6.02 * Nbits + 1.76 + 20*log10((2 .* Amp)/PE) + 10*log10(Fs/(2*BW)); % calcul du SQNR théorique
plot(Amp,SQNR_dB)
xlabel('Amplitude A_{in}'); 
ylabel('SQNR en dB théorique');

subplot(2,1,2)
plot(Amp,SQNR_dB_mes)
axis([0.1 1 40 65])
xlabel('Amplitude A_{in}'); 
ylabel('SQNR en dB mesuré');


disp(['Le SQNR théorique pour une bande [0-10] MHz et une amplitude PE/2=1V est de ', num2str(SQNR_dB(length(Amp))-1), ' dB']);
disp(['Le SQNR mesuré pour une bande [0-10] MHz et une amplitude PE/2=1V est de ', num2str(SQNR_dB_mes(length(Amp))-1), ' dB']);