clear all;
pkg load signal;

% We start by generating the optical power on the x-axis (in dBm)
SNR_bit=(-20:2:0);

% Number of symbols to send
N = 100;                            
N_bits = N; %OOK => symbole=bit

% Stopping criteria
nb_err_min = 120 ;
nb_iter_max = 150 ;

% Arrays to store our results
nb_err_treshold = zeros(1,length(SNR_bit));
BER_treshold = zeros(1,length(SNR_bit));
 
% Bitrate and period 
bitrate = 1e9;
Ts = 1/bitrate;

wavelength = 1550e-9;
c = 3e8;
v = c/wavelength;



for ii = 1:length(SNR_bit);
  
  laser_to_use_at_this_SNR = make_laser_simple('v', v);
  photodetector_to_use_at_this_SNR = make_photodetector();
    
  jj = 0;
  
  while ( ((nb_err_treshold(ii)< nb_err_min) && (jj < nb_iter_max )))   

    info_bits = randi(2, [1,N_bits])-1;  % Generating information bits
    bits = info_bits;
    %%GENERATION SIGNAL COURANT
    Idc = 0.15;
    plage = 1e-3;
    Imax = Idc + plage/2;
    Imin = Idc - plage/2;
    seuil = mean(bits);
    signal_courant(bits>=seuil) = Imax;
    signal_courtant(bits>seuil) = Imin;
    

    [output_TX, Ts_out, ~] = TX_optical_dml(signal_courant, Ts, laser_to_use_at_this_SNR);

    %fiber_output = fiber_model_new(output_TX, bitrate, 100);
    
    [output_RX, ~, ~, ~] = RX_photodetector(output_TX, Ts_out/1, 0, photodetector_to_use_at_this_SNR);

    output_RX = abs(output_RX)/max(abs(output_RX)); % Normalizing the signal

    return_to_bits = zeros(1, N_bits);
    for kk = 1:N_bits
      if output_RX(kk)>seuil % Decision taken on the middle bit
        return_to_bits(kk) = 1;
      end
    end
    
    % Number of errors
    nb_err_treshold(ii)=nb_err_treshold(ii)+sum(abs(return_to_bits-info_bits));
    
    jj = jj +1;
  end 
  BER_treshold(ii) = nb_err_treshold(ii)/(jj*N_bits);  % BER computation
 
end

BER_treshold

figure(1)
semilogy(SNR_bit,BER_treshold)
line([-30 -10], [10**(-3) 10**(-3)])
line([-30 -10], [10**(-6) 10**(-6)])
grid on
xlabel('P_opt (dBm)')
ylabel('BER')
title('BER for an OOK non-coded @1Ghz, DML')

figure(2)
plot(real(output_TX))
grid on
xlabel('Sample number')
ylabel('Signal value')
title('Samples sent by the TX')

figure(3)
plot(output_RX)
grid on
xlabel('Sample number')
ylabel('Signal value')
title('Samples received by the RX')