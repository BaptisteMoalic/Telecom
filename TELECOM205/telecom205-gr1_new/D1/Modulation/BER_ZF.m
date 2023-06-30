## Author: dariu <dariu@DESKTOP-LMS442J>
## Created: 2022-02-23

function retval = BER_ZF(nb_err_ZF,BER_ZF,SNR_bit,N_bits,N,nb_iter_max,nb_err_min,const, M_const,H_toeplitz,No)

%% boucle sur le SNR
for ii = 1:length(SNR_bit);
  jj = 0; ii
  while (((nb_err_ZF(ii)< nb_err_min) && (jj < nb_iter_max )))  
     
    % generation des information bits
    bits = randi(2, [1,N_bits])-1 ; % generation des information bits

    % modulation
    symboles_codes =  bits2symbols(bits, const ,M_const);  % symboles modulés (vecteur de taille N)

    %% Application canal AWGN  
    X = symboles_codes;
    W = sqrt(No(ii)/2).*(randn(N,1) + i* randn(N,1));  % noise
        
    Y=H_toeplitz*X + W;  % signal recu
    Z_ZF = pinv(H_toeplitz)*Y; %signal ZF par porteuse

    % demodulation ZF
    [s_est_ZF,loc_ZF] = threshold_detector(Z_ZF, const ,M_const) ; % prise de dcision
    d_est_ZF = symbols2bits(s_est_ZF, const,M_const); % convertir les symboles en bits
    bits_est_ZF=d_est_ZF; % cas non cod

    % calcul du BER pour le treshold
    nb_err_ZF(ii)=nb_err_ZF(ii)+sum(abs(bits_est_ZF-bits)); % compter le nombre d'erreur

    jj = jj +1;
  end 
          
  BER_ZF(ii) = nb_err_ZF(ii)/(jj*N_bits);    
end

retval = BER_ZF;

endfunction
