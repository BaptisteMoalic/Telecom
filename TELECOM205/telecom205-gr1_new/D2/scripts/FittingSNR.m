close all
clear
%%%%%%%%%%%%%%% You should replace this part (l3 to 14) by your real measurement 
%%%%%%%%%%%%%%% you should replace the vector SNR_real by your values
%%%%%%%%%%%%%%% The distance vector as well
distance=[1:100];   % Measurement vector
lambda=3e8/2.4e9;   % The wavelength
alpha=-1.5;          % The path loss exponent =2 for the free space 
Pt=20;              % transmitted power in dBm 
ThermNoise=10*log10(1.38e-23*290*20e6)+30; % Therm Noise power in dBm at the receiver input KTB
NFreceiver=8; % Receiver NF in dB
SNR_theo=Pt-NFreceiver-ThermNoise-10*alpha*log10(4*pi.*distance/lambda);
SNR_real=SNR_theo+0*randn(1,length(SNR_theo));  %%% Adding fluctuation to the measurement to make it more real
%%%%%%%%%%%%%%%%%%%%%%%%%%%


distancelog=10*log10(distance);          %%%Converting the distance the log as the SNR = 10*alpha*distancelog+K
fittedcoef=fitlm(distancelog,SNR_real);  %%% Linear fitting of the coefficient

distance_interp=[1:100]; %%% distance vector of the interpolated function
fittedcurve=fittedcoef.Coefficients.Estimate(1)+10*fittedcoef.Coefficients.Estimate(2)*log10(distance_interp);

disp(['The curve coefficient is ', num2str(fittedcoef.Coefficients.Estimate(2))])


semilogx(distance,SNR_real,'linewidth',2)   
hold all
semilogx(distance_interp,fittedcurve,'linewidth',2)
xlabel('Distance(m)')
ylabel('SNR(dB)')
legend('SNR real', 'fitted curve')
set(gca, 'FontSize', 25);