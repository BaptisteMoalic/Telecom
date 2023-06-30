## Author: dariu <dariu@DESKTOP-LMS442J>
## Created: 2022-02-23

function retval = BER_treshold(nb_corr_treshold,throughput_treshold,SNR_bit,N_bits,N,nb_iter_max,nb_err_min,const, M_const,H_toeplitz,No)

ARQ_nb_of_reps = 1;

nb_of_loops = 0;

for ii = 1:length(SNR_bit);
  jj = 0;ii
  %while ((nb_corr_treshold(ii) < nb_err_min) && (jj < nb_iter_max))   
  while ((jj < nb_iter_max)) 
    %disp(['jj=',num2str(jj)])
    % generation des information bits
    bits = randi(2, [1,N_bits])-1 ; % generation des information bits

    for qq = 0:ARQ_nb_of_reps;
      %disp(['ii=',num2str(ii),' boucle ARQ=',num2str(qq)])
      
      % modulation
      symboles_codes =  bits2symbols(bits, const ,M_const);  % symboles modulés (vecteur de taille N)


      %% Application canal AWGN  
      X = symboles_codes;

      W = sqrt(No(ii)/2).*(randn(N,1) + i* randn(N,1));  % noise

      Y=H_toeplitz*X + W;  % signal recu

      % demodulation treshold
      [s_est_treshold,loc_treshold] = threshold_detector(Y, const ,M_const) ; % prise de dcision        
      d_est_treshold = symbols2bits(s_est_treshold, const,M_const); % convertir les symboles en bits
      bits_est_treshold=d_est_treshold; % cas non cod


      % calcul du BER pour le treshold
      %nb_err_treshold(ii)=nb_err_treshold(ii)+sum(abs(bits_est_treshold-bits)); % compter le nombre d'erreur
      nb_err = sum(abs(bits_est_treshold-bits));
      
      jj = jj+1;
      
      if(nb_err==0)
        %disp('Pas derreur trouvée')
        %nb_corr_treshold(ii) = nb_corr_treshold(ii)+N_bits;
        break;
      endif;
      %disp('Erreur trouvée')
      %nb_of_loops = nb_of_loops+1; %deja jj=jj+1 présent
    endfor;
    
    if(nb_err==0)
      nb_corr_treshold(ii) = nb_corr_treshold(ii)+(N_bits-nb_err);
    endif
    
  end 
  %throughput_treshold(ii) = nb_corr_treshold(ii)/(jj*N_bits);  % calcul du throughput
  throughput_treshold(ii) = nb_corr_treshold(ii)/((jj+nb_of_loops)*N);
end

retval = throughput_treshold;

endfunction
