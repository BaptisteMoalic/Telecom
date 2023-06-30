% Rev: March 2022, Chadi+Germain

close all;
clear;

%%% General %%%
Flo       = 2.4e9;
N_Cont    = 2^18;
BW        = 10e6;
continuousTimeSamplingRate    = 19.98e9; %Operating Frequency to emulate the behavior of a continuous time system
Ts_Cont   = 1/continuousTimeSamplingRate; %Continuous time sampling period
K         = 1.38e-23; %Boltzmann Constant
T         = 290;      %room temperature
t_Cont    = 0:Ts_Cont:(N_Cont-1)*Ts_Cont; %Time vetor
f_Cont    = 0:continuousTimeSamplingRate/N_Cont:continuousTimeSamplingRate/2-continuousTimeSamplingRate/N_Cont; %Frequency vector

Bin_low   = round((Flo-BW/2)/continuousTimeSamplingRate*N_Cont); %Determining the input bin
Bin_high  = round((Flo+BW/2)/continuousTimeSamplingRate*N_Cont); %Determining the input bin

Rin       = 50;  %Matching impedance chosen equal to 50


%%%%%%%%%%% Input signal %%%%%%%

fin_or          = Flo+1.1e6; %Input sine frequenct
Bin_in          = round(fin_or/continuousTimeSamplingRate*N_Cont); %Determining the input bin
fin             = Bin_in*continuousTimeSamplingRate/N_Cont;


Pin             = 25.6;  %Pin in dBm
Ain             = sqrt(10.^((Pin-30)/10)*2*Rin);
AntennaNoise    = randn(1,N_Cont)*sqrt(K*T*continuousTimeSamplingRate/2*Rin);
in              = Ain*sin(2*pi*fin*t_Cont+rand()*180)+AntennaNoise; %Input signal

PA_model    = 2; %%% Select a model between 1, 2 or 3
PA_NF       = 5;
PA_Gain     = 40;

%%%%%%%%%%%% PA %%%%%%%%%%%
switch (PA_model) 
  case 1
   PA_IIP3  = 35;
  case 2
   PA_IIP3  = 30;
  case 3
   PA_IIP3  = 20;
  otherwise
   PA_IIP3  = 100;
end

PA_out = rfPA(in,PA_Gain,PA_NF, PA_IIP3,Rin,continuousTimeSamplingRate/2);


window_number       = 1;
lineSpec_index      = 3;

Pin_tab = -80:0.5:30;
SNRvsPin = zeros(1,length(Pin_tab));
PoutvsPin = zeros(1,length(Pin_tab));

for ii=1:length(Pin_tab)
    Pin = Pin_tab(ii);
    Ain             = sqrt(10.^((Pin-30)/10)*2*Rin);
    AntennaNoise    = randn(1,N_Cont)*sqrt(K*T*continuousTimeSamplingRate/2*Rin);
    in              = Ain*sin(2*pi*fin*t_Cont+rand()*180)+AntennaNoise; %Input signal
    Output = rfPA(in, PA_Gain, PA_NF, PA_IIP3, Rin, continuousTimeSamplingRate/2);
    %SNRvsPin(ii) = perf_estim(Output, Bin_in, 3, Bin_Limit, 0);
    [SNRvsPin(ii), PoutvsPin(ii)] = perf_estim(Output, Bin_in, 3, [1, N_Cont/2], 0);
end

PoutvsPin = 10*log10(PoutvsPin);

figure(1)
plot(Pin_tab, SNRvsPin);
title('SNR vs Pin');
xlabel('Pin');
ylabel('SNR');

figure(2)
plot(Pin_tab, PoutvsPin);
title('Pout vs Pin');
xlabel('Pin');
ylabel('Pout');





