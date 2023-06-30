close all;
clear;

%%DAC Specifications%%%
Nbits_DAC               = 18;
Vref_DAC                = 1;
Fs_DAC                  = 30e6;
basebandSamplingRate    = Fs_DAC;


%%General%%%
continuousTimeSamplingRate    = 19.98e9; %Operating Frequency to emulate the behavior of a continuous time system
Ts_Cont                       = 1/continuousTimeSamplingRate; %Continuous time sampling period
Subsamp_fac                   = round(continuousTimeSamplingRate/basebandSamplingRate);
N   = 2^13;     % Number of signal points
BW  = 10e6;     % Signal bandwidth
K   = 1.38e-23; % Boltzmann Constant
T   = 290;      % room temperature
t_Cont    = 0:Ts_Cont:(N*Subsamp_fac-1)*Ts_Cont; % Time vetor
f_Cont    = 0:continuousTimeSamplingRate/N:continuousTimeSamplingRate/2-continuousTimeSamplingRate/N; %Frequency vector

Ts_BB     = 1/basebandSamplingRate; % Baseband sampling period
t_BB      = 0:Ts_BB:(N-1)*Ts_BB;    % Baseband Time vetor


Rin   = 50;  % Matching impedance chosen equal to 50

%%%% Input  Generation %%%%
InputOrigin   = randn(1,N);             % Generate white noise
CutFil        = fir1(100,BW/(Fs_DAC/2));% Generate Low pass filter
Input         = filter(CutFil,1,InputOrigin); % Filter noise to make it band limited
Input         = Input/max(Input);       % Normalize

%%%%%%%%%%%%% Zero Order Hold %%%%%%%%%%%%%%%%%%%
mode              = 'zoh';
AnalogOutputZOH   = DAC(Input',Nbits_DAC,Vref_DAC,mode,Fs_DAC,continuousTimeSamplingRate);

%%%%%%%%%%%%% Zero Padding %%%%%%%%%%%%%%%%%%%
mode              = 'impulse';
AnalogOutputZP    = DAC(Input',Nbits_DAC,Vref_DAC,mode,Fs_DAC,continuousTimeSamplingRate);

figure(1)
subplot(2,2,1)
plot_spectrum(Input,1, Fs_DAC,1);
xlabel('frequency (Hz)')
ylabel('PSD (dB/bin)')
title('Input Signal')
axis([0,100e6,-200,1])
hold all

subplot(2,2,2)
plot_spectrum(AnalogOutputZOH,1,continuousTimeSamplingRate,2);  
xlabel('frequency (Hz)')
ylabel('PSD (dB/bin)')
title('DAC Output Zero Holder')
axis([0,100e6,-200,1])
hold all

subplot(2,2,3)
plot_spectrum(AnalogOutputZP,1,continuousTimeSamplingRate,3);
xlabel('frequency (Hz)')
ylabel('PSD (dB/bin)')
title('DAC Output  Zero Padding')
axis([0,100e6,-200,1])
hold all

subplot(2,2,4)
plot_spectrum(AnalogOutputZP*(continuousTimeSamplingRate/Fs_DAC),1,continuousTimeSamplingRate,3); 
hold all
plot_spectrum(AnalogOutputZOH,1,continuousTimeSamplingRate,2);
plot_spectrum(Input,1, Fs_DAC,1);
xlabel('frequency (Hz)')
ylabel('PSD (dB/bin)')
title('All signals')
axis([0,100e6,-200,1])
hold all




