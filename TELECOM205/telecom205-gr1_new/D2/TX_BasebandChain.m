close all;
clear;

%% DAC Specifications %%%
Nbits_DAC               = 18;
Vref_DAC                = 1;
Fs_DAC                  = 30e6;
basebandSamplingRate    = Fs_DAC;
mode                    = 'zoh';

%% General %%%
continuousTimeSamplingRate    = 19.98e9; % Operating Frequency to emulate the behavior of a continuous time system
Ts_Cont                       = 1/continuousTimeSamplingRate; % Continuous time sampling period
Subsamp_fac                   = round(continuousTimeSamplingRate/basebandSamplingRate);
N   = 2^13;     % Number of signal points
BW  = 10e6;     % Signal bandwidth
K   = 1.38e-23; % Boltzmann Constant
T   = 290;      % room temperature
t_Cont    = 0:Ts_Cont:(N*Subsamp_fac-1)*Ts_Cont; % Time vetor
f_Cont    = 0:continuousTimeSamplingRate/N:continuousTimeSamplingRate/2-continuousTimeSamplingRate/N; %Frequency vector

Ts_BB     = 1/basebandSamplingRate; % Baseband sampling period
t_BB      = 0:Ts_BB:(N-1)*Ts_BB;    % Baseband Time vetor


Rin       = 50;  % Matching impedance chosen equal to 50


%% Input Signal Specifications %%%%
fin_or    = 9.9e6;  % Input sine frequency
Bin_in    = round(fin_or/basebandSamplingRate*N);   % Determining the input bin
fin       = Bin_in*basebandSamplingRate/N;
Ain       = 1;      % Signal amplitude
Input     = Ain*sin(2*pi*fin*t_BB+rand()*180);      % Input signal





%% Filter Specifications %%%
TXBB_Filt_NF    = 3;          % Filter Noise Figure Filter
TXBB_Filt_Fcut  = 11.2479e6;  % Filter TXBB_Fil_Fcut 3dB Frequency
TXBB_Filt_Order = 6;          % Filter TXBB_Fil_Order

% Instanciate filter (due to numerical issue, the filter has to be instanciated as SOS)

[TXBB_Filt_z,TXBB_Filt_p,TXBB_Filt_k] = butter(TXBB_Filt_Order,TXBB_Filt_Fcut/(continuousTimeSamplingRate/2));
TXBB_Filt_sos = zp2sos(TXBB_Filt_z,TXBB_Filt_p,TXBB_Filt_k);

% Generate Analog signal
DACOutputZOH    = DAC(Input',Nbits_DAC,Vref_DAC,mode,basebandSamplingRate,continuousTimeSamplingRate);
Filtered_output = basebandAnalogFilt(DACOutputZOH,TXBB_Filt_sos,TXBB_Filt_NF,Rin,continuousTimeSamplingRate);


% Plot signals
figure(1)
subplot(2,2,1)
plot_spectrum(Input,1, basebandSamplingRate,1);
xlabel('frequency (Hz)')
ylabel('PSD (dB/bin)')
title('Input Signal')
axis([0,100e6,-200,1])


subplot(2,2,2)
plot_spectrum(DACOutputZOH,1,continuousTimeSamplingRate,2);
xlabel('frequency (Hz)')
ylabel('PSD (dB/bin)')
title('DAC Output Zero Holder')
axis([0,100e6,-200,1])


subplot(2,2,3)
plot_spectrum(Filtered_output,1,continuousTimeSamplingRate,3);
xlabel('frequency (Hz)')
ylabel('PSD (dB/bin)')
title('Filter Output')
axis([0,100e6,-200,1])


subplot(2,2,4)
plot_spectrum(DACOutputZOH,1,continuousTimeSamplingRate,3); 
hold all
plot_spectrum(Filtered_output,1,continuousTimeSamplingRate,2);
plot_spectrum(Input,1, basebandSamplingRate,1);
xlabel('frequency (Hz)')
ylabel('PSD (dB/bin)')
title('All signals')
axis([0,100e6,-200,1])





