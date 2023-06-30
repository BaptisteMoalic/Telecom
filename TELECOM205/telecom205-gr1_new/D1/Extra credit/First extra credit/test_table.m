%N = 31;
%poly_modulo = [1, 0, 1, 0, 0, 1];
%[res_inter, res] = table_syndromes_1(poly_modulo, N);

%{
A = eye(3)
B = [0, 1, 0]
yes = 0;

for ii=1:3
  if A(ii,1:3)==B
    yes = 1;
  endif
endfor

display(yes);
%}

%{
bits = randi(2, [1,N_bits])-1;

A = zeros(1,N_bits);

sum(abs(A-bits))
%}

gx = [1, 0, 1, 0, 0, 1];
N = 7;
table_syndromes_2(gx, N)