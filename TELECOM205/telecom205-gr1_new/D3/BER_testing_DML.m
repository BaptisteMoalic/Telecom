clear all;
pkg load signal;

% We start by generating the SNR in the x-axis
SNR_bit=[-40:5:-10];
%SNR_bit = [-20];
%Trouver un autre truc sur lequel itérer
%En fait c'est la puissance optique en dBm

N = 20;                            % nombre de symboles a envoyer
N_bits = N; %OOK => symbole=bit


nb_err_min = 100 ;
nb_iter_max = 100 ;

nb_err_treshold = zeros(1,length(SNR_bit));
BER_treshold = zeros(1,length(SNR_bit));

bitrate = 1e9;
Ts = 3/bitrate;

wavelength = 1550e-9;
c = 3e8;
v = c/wavelength;


for ii = 1:length(SNR_bit);
  
  laser_to_use_at_this_SNR = make_laser_simple('v', v);
  photodetector_to_use_at_this_SNR = make_photodetector();
    
  jj = 0;
  
  while ( ((nb_err_treshold(ii)< nb_err_min) && (jj < nb_iter_max )))   

    info_bits = randi(2, [1,N_bits])-1;  % generation des information bits
    bits = [];
    for kk=1:N_bits
      if (info_bits(kk)==1)
        bits = [bits, ones(1,3)*100];
      else
        bits = [bits, ones(1,3)*50];
      endif
    endfor

    %bits = [info_bits, zero_padding];
    %bits = conv(bits, window);
    %disp(['N= ',num2str(N)]);
    %disp(['longueur bits= ',num2str(length(bits))]);
    
    [output_TX, Ts_out, ~] = TX_optical_dml(bits, Ts, laser_to_use_at_this_SNR);
    real(output_TX);
    plot(real(output_TX))
    %output_fiber = fiber_model(output_TX, bitrate, 20)
    %disp(size(output_TX));
    [output_RX, ~, ~, ~] = RX_photodetector(output_TX, Ts_out/3, 0, photodetector_to_use_at_this_SNR);
    %[output_RX, ~, ~, ~] = RX_photodetector(output_TX, Ts_out, 0, photodetector_to_use_at_this_SNR);
    output_RX;
    output_RX = abs(output_RX)/max(abs(output_RX));
    %disp(size(output_RX));

    %Regarder à fort SNR
    return_to_bits = zeros(1, N_bits);
    for kk = 0:N_bits-1
      if output_RX(3*kk+2)>(1/2)
        return_to_bits(kk+1) = 1;
      end
    end
    %{
    for kk = 0:N_bits-1
      if output_RX(2*kk+1)>(1/2)
        output_RX(kk) = 1;
      else output_RX(kk) = 0;
      end
    end
    %}
    %disp(size(output_RX));
    
    % calcul du BER pour le treshold
    %nb_err_treshold(ii)=nb_err_treshold(ii)+sum(abs(output_RX-bits)); % compter le nombre d'erreurs
    nb_err_treshold(ii)=nb_err_treshold(ii)+sum(abs(return_to_bits-info_bits));
    %REMPLACER AVEC LA BONNE NOMENCLATURE
    
    jj = jj +1;
  end 
  BER_treshold(ii) = nb_err_treshold(ii)/(jj*N_bits);  % calcul du taux d'erreur binaire
 
end

figure(1)
semilogy(SNR_bit,BER_treshold)
grid on
xlabel('P_opt (dBm)')
ylabel('BER')
title('OOK non-coded WITH FIBER')

figure(2)
plot(output_TX)

figure(3)
plot(output_RX)