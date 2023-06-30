## Author: dariu <dariu@DESKTOP-LMS442J>
## Created: 2022-02-23

function retval = BER_multi_treshold_V2(nb_err_treshold,BER_treshold,SNR_bit,N_bits,N,nb_iter_max,nb_err_min,const, M_const,H_toeplitz,No)

%Parameters
fc = 2.4e9; %%carrier frequency
c = 3e8;
lambda = c/fc;

for ii = 1:length(SNR_bit);
  jj = 0;ii
  while ( ((nb_err_treshold(ii)< nb_err_min) && (jj < nb_iter_max )))   

    % generation des information bits
    bits_1 = randi(2, [1,N_bits])-1 ; % generation des information bits
    bits_2 = randi(2, [1,N_bits])-1 ;
    bits_3 = randi(2, [1,N_bits])-1 ;
    
    % modulation
    symboles_codes_1 =  bits2symbols(bits_1, const ,M_const);  % symboles modulés (vecteur de taille N)
    symboles_codes_2 =  bits2symbols(bits_2, const ,M_const);
    symboles_codes_3 =  bits2symbols(bits_3, const ,M_const);
    
    % Positions
    xx_1 = (rand(1)*2-1)*1e3; % [-1km:1km]
    yy_1 = (rand(1)*2-1)*1e3; % [-1km:1km]

    xx_2 = (rand(1)*2-3)*1e3; % [-3km:-1km]
    %xx_2 = (rand(1)*2-5)*1e3; % [-5km:-3km]
    yy_2 = (rand(1)*2-1)*1e3; % [-1km:1km]
    
    xx_3 = (rand(1)*2+1)*1e3; % [1km:3km]
    %xx_3 = (rand(1)*2+3)*1e3; % [3km:5km]
    yy_3 = (rand(1)*2-1)*1e3; % [-1km:1km]
    
    num_inter = lambda/(4*pi);
    
    % Coefficients wrt to each position
    d_1 =sqrt(xx_1^2+yy_1^2);%% distance from the origin to each user
    a_1 = min(1, num_inter/d_1);
    
    d_2 =sqrt(xx_2^2+yy_2^2);
    a_2 = min(1, num_inter/d_2);
    
    d_3 = sqrt(xx_3^2+yy_3^2);
    a_3 = min(1, num_inter/d_3);
    
    % Final vector with attenuations
    %{
    symboles_codes_1 = symboles_codes_1.*a_1;
    symboles_codes_2 = symboles_codes_2.*a_2;
    symboles_codes_3 = symboles_codes_3.*a_3;
    %}
    
    %% Application canal AWGN  
    X_1 = symboles_codes_1;
    X_2 = symboles_codes_2;
    X_3 = symboles_codes_3;
    
    W_1 = sqrt(No(ii)/2).*(randn(N,1) + i* randn(N,1));  % noise
    W_2 = sqrt(No(ii)/2).*(randn(N,1) + i* randn(N,1));
    W_3 = sqrt(No(ii)/2).*(randn(N,1) + i* randn(N,1));

    Y_1 = X_1 + W_1;  % signal recu
    Y_2 = (X_2 + W_2).*a_2;
    Y_3 = (X_3 + W_3).*a_3;
    
    % MUI seen as noise
    Y_mui = Y_1 + Y_2 + Y_3;
    
    % demodulation treshold
    [s_est_treshold,loc_treshold] = threshold_detector(Y_mui, const ,M_const) ; % prise de dcision        
    d_est_treshold = symbols2bits(s_est_treshold, const,M_const); % convertir les symboles en bits
    bits_est_treshold=d_est_treshold; % cas non cod

    % calcul du BER pour le treshold
    nb_err_treshold(ii)=nb_err_treshold(ii)+sum(abs(bits_est_treshold-bits_1)); % compter le nombre d'erreur

    jj = jj +1;
  end 
  BER_treshold(ii) = nb_err_treshold(ii)/(jj*N_bits);  % calcul du taux d'erreur binaire
 
end

retval = BER_treshold;

endfunction
