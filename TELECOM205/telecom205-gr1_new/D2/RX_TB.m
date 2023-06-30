close all;
clear all;


K   = 1.38e-23; % Boltzmann Constant
T   = 290;      % room temperature
Rin = 50;       % Input impedance

N   = 2^13;     % Number of signal points ADC
BW  = 10e6;     % Signal bandwidth
Flo = 2.4e9;    % Central frequency


basebandSamplingRate          = 30e6;       % sampling frequency ADC
continuousTimeSamplingRate    = 19.98e9;    % sampling frequency Simulation
Ts_Cont                       = 1/continuousTimeSamplingRate; % sampling period Simulation
Vref                          = 1;          % Reference voltage of the ADC
Nbits_ADC                     = 13;         % number of bits for the ADC


N_Sim   = floor(N*continuousTimeSamplingRate/basebandSamplingRate);  % Number of Simulation points
t_Sim   = 0:Ts_Cont:(N_Sim-1)*Ts_Cont;      % Time vector Simulation
f_Sim   = 0:continuousTimeSamplingRate/N_Sim:continuousTimeSamplingRate/2-continuousTimeSamplingRate/N_Sim; % Frequency vector Simulation


Ts_ADC  = 1/basebandSamplingRate; % sampling period ADC
t_ADC   = 0:Ts_ADC:(N-1)*Ts_ADC;  % ADC sampling instants
f_ADC   = 0:basebandSamplingRate/N:basebandSamplingRate/2-basebandSamplingRate/N; % Frequency vector Simulation

fin_or          = 1.1e6; % Input sine frequency
Bin_in          = round(fin_or./basebandSamplingRate*N); % Determining the input bin
fin             = Bin_in.*basebandSamplingRate/N;

AntennaNoise     =randn(1,N_Sim)*sqrt(K*T*continuousTimeSamplingRate/2*Rin);
Pin              =-90;  % Pin in dBm
Ain              =sqrt(10.^((Pin-30)/10)*2*Rin);
rxSignal         =Ain*sin(2*pi*(Flo+fin)*t_Sim+rand()*180)+AntennaNoise; % Input signal
 

%%% LNA %%%
LNA_Gain = 15;     % (dB)
LNA_IIP3 = 100;    % (dBm)
LNA_NF   = 8.1;    % (dB)

rfLNASignal = rfLNA(rxSignal,LNA_Gain,LNA_NF,LNA_IIP3,Rin,continuousTimeSamplingRate/2);

%%% Mixing down to BB %%%
[basebandAnalog_raw_I,basebandAnalog_raw_Q] = downMixer(rfLNASignal,Flo,continuousTimeSamplingRate);

%%% Baseband Analog filter %%%
RXBB_Filt_NF    = 0;     % (in dB)
RXBB_Filt_Fcut  = 15e6;  % Filter TX BB Fcut 3dB Frequency
RXBB_Filt_Order = 10;    % Filter TX BB Order
% Instanciate filter (due to numerical issue, the filter has to be instanciated as SOS)
[RXBB_Filt_z,RXBB_Filt_p,RXBB_Filt_k]=butter(RXBB_Filt_Order,RXBB_Filt_Fcut/(continuousTimeSamplingRate/2));
RXBB_Filt_sos = zp2sos(RXBB_Filt_z,RXBB_Filt_p,RXBB_Filt_k);
% Perform filtering
basebandAnalog_filtrx_I = basebandAnalogFilt(basebandAnalog_raw_I,RXBB_Filt_sos,RXBB_Filt_NF,Rin,continuousTimeSamplingRate);
basebandAnalog_filtrx_Q = basebandAnalogFilt(basebandAnalog_raw_Q,RXBB_Filt_sos,RXBB_Filt_NF,Rin,continuousTimeSamplingRate);

%%% Analog to Digital Conversion %%%
nBitADC           = 13;
delay             = 0;
adcSamplingRate   = basebandSamplingRate;
BB_gain           = 20; % dB
BB_gain_lin       = 10^(BB_gain/20); % in linear
% Perform conversion
basebandAnalog_adc_I = ADC(BB_gain_lin*basebandAnalog_filtrx_I,nBitADC,Vref,adcSamplingRate,delay,continuousTimeSamplingRate);
basebandAnalog_adc_Q = ADC(BB_gain_lin*basebandAnalog_filtrx_Q,nBitADC,Vref,adcSamplingRate,delay,continuousTimeSamplingRate);

%%% IQ combination for complex baseband signals %%%
basebandComplexDigital = complex(basebandAnalog_adc_I,basebandAnalog_adc_Q);

Bin_limits    = N/2+[round(-BW/adcSamplingRate*N),round(BW/adcSamplingRate*N)];
SNR_out       = perf_estim(basebandComplexDigital,N/2+Bin_in,5,Bin_limits,1);


disp(['The SNR at the output of the ADC is ',num2str(SNR_out), ' dB'])









subplot(2,2,1)
plot_spectrum(rfLNASignal*sqrt(1000/Rin),1,continuousTimeSamplingRate);
title('spectrum output LNA')
xlabel('Frequency (Hz)')
ylabel('PSD (dBm/bin)')
subplot(2,2,2)

plot_spectrum(basebandAnalog_filtrx_I*sqrt(1000/Rin),1,continuousTimeSamplingRate,1);
title('spectrum filter mixer')
xlabel('frequency(Hz)')
ylabel('PSD(dBm/bin)')
axis([0 100e6 -250 0])



subplot(2,2,3)
plot_spectrum(basebandAnalog_adc_I*sqrt(1000/Rin),1,basebandSamplingRate,1);
title('spectrum ADC')
xlabel('Frequency (Hz)')
ylabel('PSD (dBm/bin)')


subplot(2,2,4)
plot_spectrum(basebandComplexDigital,1,basebandSamplingRate,1,1);
title('spectrum reconstructed complex output')
xlabel('Frequency (Hz)')
ylabel('PSD (dBm/bin)')


