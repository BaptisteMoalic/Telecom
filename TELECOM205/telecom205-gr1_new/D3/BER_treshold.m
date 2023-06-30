clear all;

## Author: dariu <dariu@DESKTOP-LMS442J>
## Created: 2022-02-23

% We start by generating the SNR in the x-axis
SNR_bit=[0:2:20];
%Trouver un autre truc sur lequel itérer

N = 100;                            % nombre de symboles a envoyer
#const = 'PSK';
#M_const = 2;
#N_bits= N*log2(M_const)*R;          % nombre de bits d'information
N_bits = N;


nb_err_min = 20 ;
nb_iter_max = 20 ;


nb_err_treshold = zeros(1,length(SNR_bit));
BER_treshold = zeros(1,length(SNR_bit));
#SNR_bit = 
#N_bits = 
 

bitrate = 2.5e9;
%bitrate = 10e9;
Ts = 1/bitrate;




#const = 
#M_const = 


for ii = 1:length(SNR_bit);
  
  laser_to_use_at_this_SNR = make_emlaser('P_opt_dBm', SNR_bit(ii));
  photodetector_to_use_at_this_SNR = make_photodetector();
    
  jj = 0;
  
  while ( ((nb_err_treshold(ii)< nb_err_min) && (jj < nb_iter_max )))   

    
    % generation des information bits
    bits = randi(2, [1,N_bits])-1 ; % generation des information bits
    
    [output_TX, Ts_out, ~] = TX_optical_eml(bits, Ts, laser_to_use_at_this_SNR);
    disp(output_TX)
    [output_RX, ~, ~, ~] = RX_photodetector(output_TX, Ts_out, 2e-20, photodetector_to_use_at_this_SNR);
    disp(output_RX)
    
    % modulation
    %symboles_codes =  bits2symbols(bits, const ,M_const);  % symboles modulés (vecteur de taille N)
    %Y'a pas de modulation
    
    %% Application canal AWGN  
    %X = symboles_codes;
    %W = sqrt(No(ii)/2).*(randn(N,1) + i* randn(N,1));  % noise
    %Pas de bruit

    %Y=H_toeplitz*X + W;  % signal recu

    % demodulation treshold
    %[s_est_treshold,loc_treshold] = threshold_detector(Y, const ,M_const) ; % prise de dcision        
    %d_est_treshold = symbols2bits(s_est_treshold, const,M_const); % convertir les symboles en bits
    %bits_est_treshold=d_est_treshold; % cas non cod


    % calcul du BER pour le treshold
    nb_err_treshold(ii)=nb_err_treshold(ii)+sum(abs(output_RX-bits)); % compter le nombre d'erreur
    %REMPLACER AVEC LA BONNE NOMENCLATURE
    
    jj = jj +1;
  end 
  BER_treshold(ii) = nb_err_treshold(ii)/(jj*N_bits);  % calcul du taux d'erreur binaire
 
end

figure(1)
semilogy(SNR_bit,BER_treshold)
grid on
xlabel('Eb/No (in dB)')
ylabel('BER')
title('BPSK non-code channel 1')
%legend('Treshold','ZF','DFE')
%line_hdl=get(gca,'children');
%set(line_hdl,{'marker'},{'s';'d';'p'});
%set(line_hdl,{'color'},{[64,61,88]/256;[252,119,83]/256;[100,50,83]/256});
%set(line_hdl,'linewidth',2);
%set(gca,'fontsize',15);
%set(get(gca,'title'),'fontsize',15);
%set(get(gca,'xlabel'),'fontsize',15);
%set(get(gca,'ylabel'),'fontsize',15);
