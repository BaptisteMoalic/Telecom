%% [res] = modulo_poly(gx, mx)
%%
%%  Returns the modulo operation
%%
%%  gx = Modulo polynomial (1xDeg(gx))
%%  mx = Message polynomial (1xDeg(mx))
%%
%%  res = Modulo output (1xDeg(gx))


function [res] = modulo_poly(gx, mx)
  
  % We initialize the number of registers to the degree of gx
  deg_gx = length(gx)-1;
  registers = zeros(1,deg_gx);

  % As we begin from the highest coefficient in mx, we flip the array 
  mx = flip(mx);
  
  % We will iterate over the number of coefficients in mx
  for ii=1:length(mx);
    new_registers = zeros(1,deg_gx);
    exit_bit = registers(deg_gx);
    for jj=1:deg_gx-1;
      new_registers(jj+1) = mod(registers(jj)+gx(jj+1)*exit_bit,2);
    endfor
    new_registers(1) = mod(mx(ii)+gx(1)*exit_bit,2);
    registers = new_registers;
  endfor
  
  res = registers;

endfunction