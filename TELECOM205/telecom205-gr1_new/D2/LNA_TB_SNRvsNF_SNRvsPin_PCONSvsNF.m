% Rev: March 2022, Chadi+Germain

close all;
clear;

%%% General %%%
Flo       = 2.4e9;
N_Cont    = 2^18;
BW        = 20e6;
continuousTimeSamplingRate    = 19.98e9; % Operating Frequency to emulate the behavior of a continuous time system
Ts_Cont                       = 1/continuousTimeSamplingRate; % Continuous time sampling period
K         = 1.38e-23; % Boltzmann Constant
T         = 290;      % room temperature
t_Cont    = 0:Ts_Cont:(N_Cont-1)*Ts_Cont; % Time vetor
f_Cont    = 0:continuousTimeSamplingRate/N_Cont:continuousTimeSamplingRate/2-continuousTimeSamplingRate/N_Cont; % Frequency vector

Bin_low   = round((Flo-BW/2)/continuousTimeSamplingRate*N_Cont); % Determining the bandwidth bins
Bin_high  = round((Flo+BW/2)/continuousTimeSamplingRate*N_Cont); % Determining the bandwidth bins
Bin_Limit = [Bin_low,Bin_high];
Rin       = 50;  % Matching impedance chosen equal to 50


%%%%%%%%%%% Input signal %%%%%%%

fin_or          = Flo+1.1e6; % Input sine frequenct
Bin_in          = round(fin_or/continuousTimeSamplingRate*N_Cont); % Determining the input bin
fin             = Bin_in*continuousTimeSamplingRate/N_Cont;


Pin             = -70;  % Pin in dBm
Ain             = sqrt(10.^((Pin-30)/10)*2*Rin);
AntennaNoise    = randn(1,N_Cont)*sqrt(K*T*continuousTimeSamplingRate/2*Rin);
in              = Ain*sin(2*pi*fin*t_Cont+rand()*180)+AntennaNoise; % Input signal


LNA_Gain    = 15;
LNA_NF      = 4;
LNA_IIP3    = 10;
LNA_out     = rfLNA(in,LNA_Gain,LNA_NF,LNA_IIP3,Rin,continuousTimeSamplingRate/2);


window_number       = 1;
lineSpec_index      = 3;
fullband_spectrum   = false;

plot_spectrum(LNA_out*sqrt(1e3/Rin),window_number,continuousTimeSamplingRate,lineSpec_index,fullband_spectrum);
hold on
plot_spectrum(in*sqrt(1e3/Rin),window_number,continuousTimeSamplingRate);
legend('output','input')
xlabel('frequency (Hz)')
ylabel('PSD (dBm/bin)')


win_width = 5; % window width in bins
SNR_in    = perf_estim(in,Bin_in,win_width,[Bin_low Bin_high]);
SNR_out   = perf_estim(LNA_out,Bin_in,win_width,[Bin_low Bin_high]);


disp(['The SNR at the LNA input is ',num2str(SNR_in),' dB'])
disp(['The SNR at the LNA output is ',num2str(SNR_out), ' dB'])

NF=1:0.5:10;
Pin_tab = -80:0.5:20;
SNRvsNF=zeros(1,length(NF));
SNRvsPin = zeros(1,length(Pin_tab));
Pcons=zeros(1, length(NF));

for ii=1:length(NF)
    [Output,Pcons(ii)] = PC_rfLNA(in, LNA_Gain, NF(ii), LNA_IIP3, Rin, continuousTimeSamplingRate/2);
    %SNRvsNF(ii) = perf_estim(Output, Bin_in, 3, Bin_Limit, 0);
    SNRvsNF(ii) = perf_estim(Output, Bin_in, 3, [1, N_Cont/2], 0);
    Pcons(ii) = 0.01/(10^(NF(ii)/10)-1);
end


for ii=1:length(Pin_tab)
    Pin = Pin_tab(ii);
    Ain             = sqrt(10.^((Pin-30)/10)*2*Rin);
    AntennaNoise    = randn(1,N_Cont)*sqrt(K*T*continuousTimeSamplingRate/2*Rin);
    in              = Ain*sin(2*pi*fin*t_Cont+rand()*180)+AntennaNoise; %Input signal
    Output = rfLNA(in, LNA_Gain, LNA_NF, LNA_IIP3, Rin, continuousTimeSamplingRate/2);
    %SNRvsPin(ii) = perf_estim(Output, Bin_in, 3, Bin_Limit, 0);
    SNRvsPin(ii) = perf_estim(Output, Bin_in, 3, [1, N_Cont/2], 0);
end



figure(2)
plot(NF, SNRvsNF);
title('SNR vs NF');
xlabel('NF');
ylabel('SNR');

figure(3)
plot(Pin_tab, SNRvsPin);
title('SNR vs Pin');
xlabel('Pin');
ylabel('SNR');

figure(4)
plot(NF, Pcons);
title('Puissance consommée vs NF');
xlabel('NF');
ylabel('Pcon');