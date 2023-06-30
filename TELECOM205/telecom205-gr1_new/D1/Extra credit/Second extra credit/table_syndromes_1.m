%% [res_inter, res] = table_syndromes_1(gx, N)
%%
%%  Returns the table of e(x) mod g(x) given a modulo polynomial 
%%  for coding with a maximum of 1 error.
%%
%%  gx = Modulo polynomial (1xDeg(gx))
%%  N = size of the final message (coding included)
%%
%%  res_inter = Table of errors (NxN)
%%  res = Table of syndromes (NxDeg(gx))

function [res_inter, res] = table_syndromes_1(gx, N)
  
  len_gx = length(gx)-1;
  res_inter = eye(N); %Motifs d'erreurs sur le mot code
  res = zeros(N, len_gx); %Syndromes correspondants
  
  for ii=1:N; %Associer à chaque pattern son syndrome
    err = modulo_poly(gx, res_inter(ii,1:N));
    res(ii,1:len_gx) = err;
  endfor
  
endfunction
