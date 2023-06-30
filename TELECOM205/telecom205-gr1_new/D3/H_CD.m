function res_tf = H_CD(f, beta_2, beta_3, L)
  in_exp = beta_2*((2*pi*f).^2)*(1/2) + beta_3*((2*pi*f).^3)*(1/6);
  res_tf = exp(-j*in_exp*L);
endfunction