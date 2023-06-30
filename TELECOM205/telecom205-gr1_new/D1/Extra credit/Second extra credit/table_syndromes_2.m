%% [res_inter, res] = table_syndromes_2(gx, N)
%%
%%  Returns the table of e(x) mod g(x) given a modulo polynomial 
%%  for coding with a maximum of 2 errors.
%%
%%  gx = Modulo polynomial (1xDeg(gx))
%%  N = size of the final message (coding included)
%%
%%  res_inter = Table of errors (N^2xN)
%%  res = Table of syndromes (N^2xDeg(gx))

function [res_inter, res] = table_syndromes_2(gx, N)
  
  N2 = N**2;
  len_gx = length(gx)-1;
  res_inter = eye(N); %Motifs d'erreurs sur le mot code pour 1 SEULE ERREUR
  
  index_fix = 1;
  for ii=1:N; %Motifs d'erreurs sur le mot code pour 2 ERREURS
    res_inter_2 = zeros(1,N);
    res_inter_2(1,ii) = 1; %On part d'un pattern fixe où l'erreur est à l'indice ii
    for jj=1:N; %On parcourt tous les jj différents de ii
      if jj ~= ii;
        res_inter_3 = res_inter_2;
        res_inter_3(1,jj) = 1; %En plus du bit fixe d'erreur, on ajoute un deuxième différent
        res_inter = [res_inter; res_inter_3]; %On append à la matrice finale
      endif
    endfor
  endfor
  
  
  res = zeros(N2, len_gx); %Syndromes correspondants
  
  for ii=1:N2 %Associer à chaque pattern son syndrome
    err = modulo_poly(gx, res_inter(ii,1:N));
    res(ii,1:len_gx) = err;
  endfor
  
endfunction
