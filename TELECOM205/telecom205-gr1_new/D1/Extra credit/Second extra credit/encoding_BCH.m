function [res] = encoding_BCH(gx, mx, N)
  k = length(mx);
  translated_mx = zeros(1,N-k);
  translated_mx = [translated_mx, mx]; %We obtain mx*x^(n-k)
  res = [mx, modulo_poly(gx, translated_mx)]; %Accordingly, we keep the info bits at the end of the message
endfunction
