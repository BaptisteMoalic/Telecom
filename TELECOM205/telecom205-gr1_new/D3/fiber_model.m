## Copyright (C) 2022 bapti
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <https://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {} {@var{retval} =} fiber_model (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: bapti <bapti@LAPTOP-AK4ET8T4>
## Created: 2022-05-13

function attenuated_signal = fiber_model(signal, bitrate, L)
  
  %Parameters to model the propagation in the fiber
  c = 3e5; % NM/PS
  lambda = 1550; %wavelength NM
  %L is a parameter of the function
  alpha_dB = 0.2; %attenuation (dB)
  alpha_lin = alpha_dB*(4.34e-3); %attenuation (m^-1)
  D = 17e-12; %dispersion parameter PS/NM/KM
  S = 0.09; %dispersion slope PS/NM²/KM
  
  %Computing of the parameters for the transfer function
  beta_2 = -(D*(lambda^2))/(2*pi*c);
  beta_3 = (S*(lambda^4))/(4*(pi^2)*(c^2));
  
  N_bits = length(signal);
  frequencies = linspace(-bitrate/2, bitrate/2, N_bits);
  
  spectrum = fftshift(fft(signal, N_bits));
  H = fftshift(H_CD(2*pi*frequencies, beta_2, beta_3, L));
  
  filtered_signal = real(ifft(spectrum.*H));
  
  attenuated_signal = filtered_signal*exp(-alpha_lin*L/2);

endfunction
