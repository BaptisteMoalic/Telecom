clear all;
pkg load signal;

% We start by generating the optical power on the x-axis (in dBm)
SNR_bit=(-20:1:-10);

% Number of symbols to send
N = 100;                            
N_bits = N; %OOK => symbole=bit

% Stopping criteria
nb_err_min = 1000 ;
nb_iter_max = 1000 ;


 
% Bitrate and period 
bitrate = 2.5e9;
%bitrate = 10e9;
upsample_factor = 30;
Ts = upsample_factor/bitrate;
L = 1000;

% Arrays to store our results
nb_err_treshold = zeros(1,length(SNR_bit));
BER_treshold = zeros(1,length(SNR_bit));


for ii = 1:length(SNR_bit);
  
  laser_to_use_at_this_SNR = make_emlaser('P_opt_dBm', SNR_bit(ii));
  photodetector_to_use_at_this_SNR = make_photodetector();
    
  jj = 0;
  
  while ( ((nb_err_treshold(ii)< nb_err_min) && (jj < nb_iter_max )))   

    info_bits = randi(2, [1,N_bits])-1;  % Generating information bits
    bits = [];
    for kk=1:N_bits
      if (info_bits(kk)==1)
        bits = [bits, ones(1,upsample_factor)]; % Upsampling
      else
        bits = [bits, zeros(1,upsample_factor)];
      endif
    endfor

    
    [output_TX, Ts_out, ~] = TX_optical_eml(bits, Ts, laser_to_use_at_this_SNR);
    
    fiber_output = fiber_model_new(output_TX, bitrate, L);

    [output_RX, ~, ~, ~] = RX_photodetector(fiber_output, Ts_out/30, 0, photodetector_to_use_at_this_SNR);

    output_RX = abs(output_RX)/max(abs(output_RX)); % Normalizing the signal

    return_to_bits = zeros(1, N_bits);
    for kk = 0:N_bits-1
      if output_RX(30*kk+15)>(1/2) % Decision taken on the middle bit
        return_to_bits(kk+1) = 1;
      end
    end
    
    % Number of errors
    nb_err_treshold(ii)=nb_err_treshold(ii)+sum(abs(return_to_bits-info_bits));
    
    jj = jj +1;
  end 
  BER_treshold(ii) = nb_err_treshold(ii)/(jj*N_bits);  % BER computation
 
end

BER_treshold;

figure(1)
semilogy(SNR_bit,BER_treshold)
line([-20 -10], [10**(-3) 10**(-3)])
line([-20 -10], [10**(-6) 10**(-6)])
grid on
xlabel('P_opt (dBm)')
ylabel('BER')
title('BER for an OOK non-coded @2.5Ghz')

%{
figure(1)
semilogy(L,BER_treshold)
line([0 100], [10**(-3) 10**(-3)])
line([0 100], [10**(-6) 10**(-6)])
grid on
xlabel('Length (km)')
ylabel('BER')
title('BER for an OOK non-coded @2,5Ghz')
%}

figure(2)
plot(output_TX)
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