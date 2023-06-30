## Author: dariu <dariu@DESKTOP-LMS442J>
## Created: 2022-02-25

function retval = BER_DFE(nb_err_DFE,BER_DFE,SNR_bit,N_bits,N,nb_iter_max,nb_err_min,const, M_const,H_toeplitz,No)

%% boucle sur le SNR
for ii = 1:length(SNR_bit);
  jj = 0; ii
  while (((nb_err_DFE(ii)< nb_err_min) && (jj < nb_iter_max )))  
   
    % generation des information bits
    bits = randi(2, [1,N_bits])-1 ; % generation des information bits

    % modulation
    symboles_codes =  bits2symbols(bits, const ,M_const);  % symboles modulés (vecteur de taille N)

    %% Application canal AWGN  
    X = symboles_codes;
    W = sqrt(No(ii)/2).*(randn(N,1) + 1i* randn(N,1));  % noise
             
    %décomposition QR avec Q matrice unitaire et R matrice triangulaire supérieure
    Y = H_toeplitz*X + W;  % signal recu
    [Q,R] = qr(H_toeplitz);
    Y_DFE = Q' * Y;

    % demodulation DFE
    s_est_DFE = zeros(N,1);
    s_est_DFE(N) = threshold_detector(Y_DFE(N)/R(N,N), const, M_const);
       
    for kk = 1:(N-1)
      s_est_DFE(N-kk) = threshold_detector((Y_DFE(N-kk)-R(N-kk, N-kk+1:N)*s_est_DFE(N-kk+1:N))/R(N-kk,N-kk), const, M_const);
    endfor 
    
    d_est_DFE = symbols2bits(s_est_DFE, const,M_const); % convertir les symboles en bits
    
    % calcul du BER pour le treshold
    nb_err_DFE(ii)=nb_err_DFE(ii)+sum(abs(d_est_DFE-bits)); % compter le nombre d'erreur

    jj = jj +1;
  end 
      
  BER_DFE(ii) = nb_err_DFE(ii)/(jj*N_bits);    

end

retval = BER_DFE;

endfunction
