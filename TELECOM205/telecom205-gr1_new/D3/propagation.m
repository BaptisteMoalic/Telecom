clear all;
pkg load signal;

%Simulation parameters
Fs = 10^10;
Ts = 1/Fs;
#ns = 5000;
#t_BB = (0:Ts:((ns-1)*Ts));
#t_imp = 1/(20*10^9);
#sigma = t_imp*10/Ts;
#signal_BB = exp(-((0:ns-1)-(ns/2)).^2 / (sigma^2));

#signal = signal_BB;

%Parameters to model the propagation in the fiber
c = 3e5; %NM/PS
lambda = 1550; %NM
alpha_dB = 0.2;
alpha = alpha_dB*(4.34e-3); %attenuation
D = 17; %dispersion parameter PS/NM/KM
S = 0.09; %dispersion slope PS/NM²/KM
L = 100; %KM
%D_lambda = D_lambda0 + S*(lambda - lambda0); %ca c'est au voisinnage de lambda0, pas utile ici

%beta_2 = -(D*(lambda^2))/(2*pi*c)*10^(-21);
%beta_3 = (S*(lambda^4))/(4*(pi^2)*(c^2))*10^(-30);
beta_2 = -(D*(lambda^2))/(2*pi*c)*10^(-24);

beta_3 = (S*(lambda^4))/(4*(pi^2)*(c^2))*10^(-36);

signal = zeros(1,9000);
random_place_for_T = 2500;
for kk=1:1000
  signal(random_place_for_T+kk-1)=1;
endfor


N_bits = length(signal);
time = (0:Ts:(N_bits-1)*Ts);
 frequencies = (-(N_bits/2)*(Fs/N_bits):Fs/N_bits:((N_bits/2)-1)*(Fs/N_bits));


%{
T = 1e-3;
F = 1/T;
time = (0:T:500*T);
Fs = 3/T;
len = length(time);
%}


figure(1)
plot(time, signal)
grid on
xlabel('t')
ylabel('Pulse value')
title('Pulse')

%frequencies = (-Fs/2, Fs/2, 301);
%spectrum = fftshift(fft(signal, 301));

spectrum = fftshift(fft(signal));

figure(2)
plot(frequencies, spectrum) 
grid on
xlabel('f')
ylabel('Spectrum amplitude')
title('Spectrum of the pulse')

re_signal = ifft(ifftshift(spectrum));

figure(3)
plot(time, re_signal)
grid on
xlabel('t')
ylabel('Signal value')
title('Pulse reconstructed (without filter)')

le_filtre = H_CD(frequencies, beta_2, beta_3, L);

figure(4)
plot(frequencies, abs(le_filtre))
grid on
xlabel('f')
ylabel('Signal value')
title('The filter')


filtered_spectrum = le_filtre.*spectrum;

%attenuated_spectrum = exp(-alpha*L/2)*filtered_spectrum;
%attenuated_spectrum = attenuation*filtered_spectrum;

filtered_signal = ifft(ifftshift(filtered_spectrum));

attenuated_power = (filtered_signal.^2)*exp(-alpha*L);

figure(5)
plot(frequencies, filtered_spectrum)
grid on
xlabel('f')
ylabel('Signal value')
title('Spectrum of the filter')

figure(6)
plot(time, abs(filtered_signal))
grid on
xlabel('t')
ylabel('Signal value')
title('Filtered signal')

figure(7)
plot(time, abs(attenuated_power))
grid on
xlabel('t')
ylabel('Signal value')
title('Attenuated signal')
