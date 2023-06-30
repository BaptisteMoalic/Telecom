## Author: dariu <dariu@DESKTOP-LMS442J>
## Created: 2022-02-23

function retval = BER_treshold(nb_err_treshold,BER_treshold,SNR_bit,N_bits,N,nb_iter_max,nb_err_min,const, M_const,H_toeplitz,No)

% coding prerequisites
N_bits_info = 21;
N_bits_code = 31;
poly_modulo = [1, 0, 0, 1, 0, 1, 1, 0, 1, 1, 1];
deg_poly = length(poly_modulo)-1;
[table_err, table_syndromes] = table_syndromes_2(poly_modulo, N_bits_code);

for ii = 1:length(SNR_bit);
  jj = 0;ii
  while ( ((nb_err_treshold(ii)< nb_err_min) && (jj < nb_iter_max )))   

    N_uncoded_bits = rem(N_bits, N_bits_code); % On regarde combien de tours on fait pour coder
    loop_number_coding = (N_bits-N_uncoded_bits)/N_bits_code;
    
    bits_final = [];
    bits_final_coded = [];
    
    for kk = 1:loop_number_coding;
      % generation des information bits
      bits = randi(2, [1,N_bits_info])-1 ; % generation des information bits
      
      %concatenation des bits non-codes ici au reste
      bits_final = [bits_final, bits];
      
      % ajout des bits de parite sous forme systematique
      bits_coded = encoding_BCH(poly_modulo, bits, N_bits_code);
      
      %concatenation des bits codes ici au reste
      bits_final_coded = [bits_final_coded, bits_coded];
    endfor
    
    %ajout des bits restants non codes car pas au bon format
    %bits_uc = randi(2, [1,N_uncoded_bits])-1 ;
    bits_uc = zeros(1, N_uncoded_bits);
    bits_final = [bits_final, bits_uc];
    bits_final_coded = [bits_final_coded, bits_uc];

    % modulation
    symboles_codes =  bits2symbols(bits_final_coded, const ,M_const);  % symboles modulés (vecteur de taille N)

    %% Application canal AWGN  
    X = symboles_codes;
    W = sqrt(No(ii)/2).*(randn(N,1) + i* randn(N,1));  % noise

    Y=H_toeplitz*X + W;  % signal recu

    % demodulation treshold
    [s_est_treshold,loc_treshold] = threshold_detector(Y, const ,M_const) ; % prise de dcision        
    d_est_treshold = symbols2bits(s_est_treshold, const,M_const); % convertir les symboles en bits
    
    % decodage en retrouvant les petits paquets de bits
    
    bits_final_ber = [];
    for ll = 1:loop_number_coding;
      bits_est = d_est_treshold(1,(((ll-1)*N_bits_code)+1):ll*N_bits_code);
    
      % obtention du syndrome
      syndrom = modulo_poly(poly_modulo, bits_est);
      corr_found = 0;

      for kk=1:N_bits_code;
        if table_syndromes(kk,1:deg_poly)==syndrom;
          err_syn = table_err(kk,1:N_bits_code);
          corr_found = 1;
          break;
        endif
      endfor
    
      if corr_found == 0;
        err_syn = zeros(1,N_bits_code);
      endif
    
      bits_est_treshold_coded = mod(bits_est+err_syn,2);
    
      %On retrouve les N_bits et pas les N
      bits_est_treshold = bits_est_treshold_coded(1,1:N_bits_info);
      bits_final_ber = [bits_final_ber, bits_est_treshold];
    endfor
    
    %Adding the uncoded bits at the end
    ending_uc = d_est_treshold(1,(loop_number_coding*N_bits_code+1):end);
    bits_final_ber = [bits_final_ber, ending_uc];
    
    % calcul du BER pour le treshold
    nb_err_treshold(ii)=nb_err_treshold(ii)+sum(abs(bits_final_ber-bits_final)); % compter le nombre d'erreurs

    jj = jj +1;
  end 
  BER_treshold(ii) = nb_err_treshold(ii)/(jj*N_bits);  % calcul du taux d'erreur binaire
 
end

retval = BER_treshold;

endfunction
