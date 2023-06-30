## Author: dariu <dariu@DESKTOP-LMS442J>
## Created: 2022-02-23

function retval = BER_treshold(nb_err_treshold,BER_treshold,SNR_bit,N_bits,N,nb_iter_max,nb_err_min,const, M_const,H_toeplitz,No)

% coding prerequisites
poly_modulo = [1, 0, 0, 1, 0, 1, 1, 0, 1, 1, 1];
deg_poly = length(poly_modulo)-1;
[table_err, table_syndromes] = table_syndromes_2(poly_modulo, N);

for ii = 1:length(SNR_bit);
  jj = 0;ii
  while ( ((nb_err_treshold(ii)< nb_err_min) && (jj < nb_iter_max )))   

    % generation des information bits
    bits = randi(2, [1,N_bits])-1 ; % generation des information bits
    
    % ajout des bits de parite sous forme systematique
    bits_coded = encoding_BCH(poly_modulo, bits, N);

    % modulation
    symboles_codes =  bits2symbols(bits_coded, const ,M_const);  % symboles modulés (vecteur de taille N)

    %% Application canal AWGN  
    X = symboles_codes;
    W = sqrt(No(ii)/2).*(randn(N,1) + i* randn(N,1));  % noise

    Y=H_toeplitz*X + W;  % signal recu

    % demodulation treshold
    [s_est_treshold,loc_treshold] = threshold_detector(Y, const ,M_const) ; % prise de dcision        
    d_est_treshold = symbols2bits(s_est_treshold, const,M_const); % convertir les symboles en bits
    
    % obtention du syndrome
    syndrom = modulo_poly(poly_modulo, d_est_treshold);
    
    % comparaison avec la table des syndromes
    %% Demander si ça renvoie rien, est-ce que genre on tente une correction au pif ou on laisse comme ça?
    %corr_found = ismember(syndrom, table_syndromes); %Lance-t-on l'algo?
    corr_found = 0;
    %if corr_found == 1;
    for kk=1:N;
      if table_syndromes(kk,1:deg_poly)==syndrom;
        err_syn = table_err(kk,1:N);
        corr_found = 1;
        break;
      endif
    endfor
    
    if corr_found == 0;
      err_syn = zeros(1,N);
    endif
    
    bits_est_treshold_coded = mod(d_est_treshold+err_syn,2);
    
    %On retrouve les N_bits et pas les N
    bits_est_treshold = bits_est_treshold_coded(1,1:N_bits);
    
    % calcul du BER pour le treshold
    nb_err_treshold(ii)=nb_err_treshold(ii)+sum(abs(bits_est_treshold-bits)); % compter le nombre d'erreurs

    jj = jj +1;
  end 
  BER_treshold(ii) = nb_err_treshold(ii)/(jj*N_bits);  % calcul du taux d'erreur binaire
 
end

retval = BER_treshold;

endfunction
