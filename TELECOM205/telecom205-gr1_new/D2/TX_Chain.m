close all;
clear;





PA_model    = 2; %%% Select a model between 1, 2 or 3
PA_NF       = 5;
PA_Gain     = 14;
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





%% DAC Specifications%%%
Nbits_DAC               = 12;
Vref_DAC                = 1;
Fs_DAC                  = 30e6;
basebandSamplingRate    = Fs_DAC;
Flo                     = 2.4e9;
mode                    = 'zoh';


%% General%%%
continuousTimeSamplingRate    = 19.98e9; % Operating Frequency to emulate the behavior of a continuous time system
Ts_Cont                       = 1/continuousTimeSamplingRate; % Continuous time sampling period
Subsamp_fac                   = round(continuousTimeSamplingRate/basebandSamplingRate);
N         = 2^13;     % Number of signal points
BW        = 10e6;     % Signal bandwidth
K         = 1.38e-23; % Boltzmann Constant
T         = 290;      % room temperature
t_Cont    = 0:Ts_Cont:(N*Subsamp_fac-1)*Ts_Cont; % Time vetor
f_Cont    = 0:continuousTimeSamplingRate/N:continuousTimeSamplingRate/2-continuousTimeSamplingRate/N; % Frequency vector

Ts_BB     = 1/basebandSamplingRate; % Baseband sampling period
t_BB      = 0:Ts_BB:(N-1)*Ts_BB;    % Baseband Time vetor


Rin       = 50;  % Matching impedance chosen equal to 50


%%%%%%%%%%% Input signal %%%%%%%
fin_or    = [6.1e6, 9.2e6];    % Input sine frequency
Bin_in    = round(fin_or/basebandSamplingRate*N); % Determining the input bin
fin       = Bin_in*basebandSamplingRate/N;
Ain_I     = 0.5;
Ain_Q     = 0.5;

%% Filter Specifications%%%
TXBB_Filt_NF    = 3;        % Filter Noise Figure Filter
TXBB_Filt_Fcut  = 11.12e6;  % Filter TXBB_Fil_Fcut 3dB Frequency
TXBB_Filt_Order = 6;        % Filter TXBB_Fil_Order

[TXBB_Filt_z,TXBB_Filt_p,TXBB_Filt_k] = butter(TXBB_Filt_Order,TXBB_Filt_Fcut/(continuousTimeSamplingRate/2));
TXBB_Filt_sos = zp2sos(TXBB_Filt_z,TXBB_Filt_p,TXBB_Filt_k);

%%%%% I Channel%%%%
PI                = rand()*pi;
Input_I           = Ain_I*sin(2*pi*fin(1)*t_BB+PI)+Ain_I*sin(2*pi*fin(2)*t_BB+PI);% Input signal I Channel
DACOutputZOH_I    = DAC(Input_I',Nbits_DAC,Vref_DAC,mode,basebandSamplingRate,continuousTimeSamplingRate);
Filtered_output_I = basebandAnalogFilt(DACOutputZOH_I,TXBB_Filt_sos,TXBB_Filt_NF,Rin,continuousTimeSamplingRate);


%%%%% Q Channel%%%%
Input_Q           = Ain_Q*sin(2*pi*fin(1)*t_BB+PI-pi/2)+Ain_Q*sin(2*pi*fin(2)*t_BB+PI-pi/2);% Input signal Q Channel
DACOutputZOH_Q    = DAC(Input_Q',Nbits_DAC,Vref_DAC,mode,basebandSamplingRate,continuousTimeSamplingRate);
Filtered_output_Q = basebandAnalogFilt(DACOutputZOH_Q,TXBB_Filt_sos,TXBB_Filt_NF,Rin,continuousTimeSamplingRate);









%%%%%%%%% RF%%%%%%%%%%%
MixerOutput   = upMixer(Filtered_output_I,Filtered_output_Q,Flo,continuousTimeSamplingRate);
PAOutput      = rfPA(MixerOutput, PA_Gain,PA_NF,PA_IIP3,Rin,continuousTimeSamplingRate/2);


plot_spectrum(MixerOutput,1,continuousTimeSamplingRate,3);
xlabel('frequency (Hz)')
ylabel('PSD (dB/bin)')
title('Mixer Output')

plot_spectrum(PAOutput*sqrt(1e3/Rin),2,continuousTimeSamplingRate,1);
xlabel('frequency (Hz)')
ylabel('PSD (dBm/bin)')
title('PA Output')


plot_spectrum(PAOutput*sqrt(1e3/Rin),3,continuousTimeSamplingRate,1);
xlabel('frequency (Hz)')
ylabel('PSD (dBm/bin)')
title('Zoom PA Output')
axis([Flo-2*BW,Flo+2*BW,-150,30])




