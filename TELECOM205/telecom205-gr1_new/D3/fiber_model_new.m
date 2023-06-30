## Author: bapti <bapti@LAPTOP-AK4ET8T4>
## Created: 2022-05-13

function attenuated_signal = fiber_model_new(signal, bitrate, L)
  
  %Parameters to model the propagation in the fiber
  Fs = 5*10^9;
  Ts = 1/Fs;
  c = 3e5; %NM/PS
  lambda = 1550; %NM
  alpha_dB = 0.2;
  alpha = alpha_dB*(4.34e-3); %attenuation
  D = 17; %dispersion parameter PS/NM/KM
  S = 0.09; %dispersion slope PS/NM²/KM
  %L = 50; %KM
  %D_lambda = D_lambda0 + S*(lambda - lambda0); %ca c'est au voisinnage de lambda0, pas utile ici
  
  %Computing of the parameters for the transfer function
  beta_2 = -(D*(lambda^2))/(2*pi*c)*10^(-24);
  beta_3 = (S*(lambda^4))/(4*(pi^2)*(c^2))*10^(-36);

  N_bits = length(signal);
  time = (0:Ts:(N_bits-1)*Ts);
  %frequencies = (-(N_bits/2)*(Fs/N_bits):Fs/N_bits:((N_bits/2)-1)*(Fs/N_bits));
  frequencies = (-(0)*(Fs/N_bits):Fs/N_bits:((N_bits)-1)*(Fs/N_bits));
  
  spectrum = fftshift(fft(signal));
  
  le_filtre = H_CD(frequencies, beta_2, beta_3, L);
  
  filtered_spectrum = le_filtre.*spectrum;
  
  filtered_signal = ifft(ifftshift(filtered_spectrum));
  
  #attenuated_signal = (filtered_signal.^2)*exp(-alpha*L);
  attenuated_signal = (abs(filtered_signal))*exp(-alpha*L/2);

endfunction
