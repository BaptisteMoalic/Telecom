% completeTxRx - Script that performs the simulation of the complete communication chain
%
%   The purpose of this script is to demonstrate a complete wireless
%   communication chain.
%   As provided, the chain is not optimized ; ONE OF THE TARGET OF THE
%   PROJECT IS TO OPTIMIZE THE PARAMETERS OF THE SYSTEM SUBBLOCKS IN ORDER
%   TO MEET THE REQUIREMENTS.
%   Please pay attention to the fact that FIR filters in this script cause 
%   transient phenomena that have not been compensated. 
%   IT IS YOUR DUTY TO FIND THE EXPRESSION OF THE TOTAL DELAY IN "THE
%   ANALOG TO DIGITAL CONVERSION" SECTION TO MATCH THE TRANSMIT AND RECEIVE
%   DATA. (no hardcoding please...)
%   
%   Hopefully, the script has been written to be self-explanatory. 
%
%   In this project, we use the Quadriga Channel Model ("QuaDRiGa") for
%   generating realistic radio channel impulse responses.
%   It is an open source project whose license can be found in the
%   directories of the project. In order to reduce the footprint in terms
%   of disk space, we do not distribute the documentation (PDF) of the
%   QuaDRiGa toolbox included in the original archive distributed on the
%   official site. Please consult the download page and download the
%   archive to retrieve the documentation.
%   https://quadriga-channel-model.de/
%
% Other m-files required:   ./subblocks/*.m
% Subfunctions:             ./subblocks/*.m
% MAT-files required: none
%
% Author: Germain PHAM, Chadi JABBOUR
% C2S, COMELEC, Telecom Paris, Palaiseau, France
% email address: dpham@telecom-paris.fr
% Website: https://c2s.telecom-paristech.fr/TODO
% Feb. 2020, Apr. 2020, Mar. 2022
%------------- BEGIN CODE --------------
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                   Tranmitter                        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Signal Generation %%%
continuousTimeSamplingRate    = 20e9;     % A sampling rate which is sufficiently high in order to be close to the continous time
basebandSamplingRate_or       = 30e6;     % The sampling rate of the complex baseband signal ; Units : Samples/second
                                          % in this project it MUST BE a multiple of symbolRate

basebandSamplingRate          = continuousTimeSamplingRate/round(continuousTimeSamplingRate/basebandSamplingRate_or);


%%% Signal Characteristics %%%
symbolRate              = 15e6;  % The raw symbol rate : the raw complex QAM symbols are sent at this rate ; Units : Symbols/second
basebandOverSampling    = round(basebandSamplingRate/symbolRate);
NSamples_BB             = 1e3;   % Signal length (after RRC filter)

% Signal frequencies
freqVin_or1   = 7.12e6;
freqVin_or2   = 6.12e6;
% Place the sine waves in an FFT bin
freqVin1      = round(freqVin_or1/basebandSamplingRate*NSamples_BB)...
                  *basebandSamplingRate/NSamples_BB; 
freqVin2      = round(freqVin_or2/basebandSamplingRate*NSamples_BB)...
                  *basebandSamplingRate/NSamples_BB; 

% Time vector of the simulation
t = 0:1/basebandSamplingRate:(NSamples_BB-1)/basebandSamplingRate;

%%% Baseband (digital) shaping filter %%%
rollOff     = 0.25; % (for RRC filter, single sided output BW is (1+beta)*Rsymb/2 )
symbolSpan  = 25;   % This parameter is related to both the filter length and the attenuation of the stop band
% Instanciate filter
basebandRRC = rcosdesign(rollOff,symbolSpan,basebandOverSampling,'sqrt'); 


%%% choix du PA %%%
PA_type = 4;

switch PA_type
   case 1
      %%%ZX60-V63+%%%
      %%%IMPOSSIBLE DE DEPASSER 20dBm DE PUISSANCE EN SORTIE CAR SATURATION%%%
      %%% RF Amplification %%%
      PA_Gain       = 19.7;             % PA Gain ; in dB power
      PA_IIP3       = 30.2 - PA_Gain;   % PA IIP3 ; in dBm = OIP3 - GAIN
      PA_NF         = 3.65;             % PA Noise figure ; in dB
      Pregain = 1;
      
   case 2
      %%%ZX60-V62+%%%
      %%%IMPOSSIBLE DE DEPASSER 20dBm DE PUISSANCE EN SORTIE CAR SATURATION%%%
      %%% RF Amplification %%%
      PA_Gain       = 15.45;            % PA Gain ; in dB power
      PA_IIP3       = 32 - PA_Gain;     % PA IIP3 ; in dBm = OIP3 - GAIN
      PA_NF         = 5.1;              % PA Noise figure ; in dB
      Pregain = 1; 
      
   case 3
      %%%ZHL42%%%
      %%% RF Amplification %%%
      PA_Gain       = 39.46;            % PA Gain ; in dB power
      PA_IIP3       = 44.85 - PA_Gain;  % PA IIP3 ; in dBm = OIP3 - GAIN
      PA_NF         = 8.07;             % PA Noise figure ; in dB
      Pregain = 0.06;
      PA_pc = 15;
      
   case 4
      %%%ADL5606%%%
      %%% RF Amplification %%%
      PA_Gain       = 23.6;             % PA Gain ; in dB power
      PA_IIP3       = 45.5 - PA_Gain;   % PA IIP3 ; in dBm = OIP3 - GAIN
      PA_NF         = 4.7;              % PA Noise figure ; in dB
      Pregain = 0.37; 
      PA_pc = 1.81;
      
   case 5
      %%%RFLUPA05M06G%%%
      %%% RF Amplification %%%
      PA_Gain       = 34;               % PA Gain ; in dB power
      PA_IIP3       = 43 - PA_Gain;     % PA IIP3 ; in dBm = OIP3 - GAIN
      PA_NF         = 3;                % PA Noise figure ; in dB
      Pregain = 0.11;
      PA_pc = 3.3;
      
   otherwise
      %%%ADL5606%%%
      %%% RF Amplification %%%
      PA_Gain       = 23.6;             % PA Gain ; in dB power
      PA_IIP3       = 45.5 - PA_Gain;   % PA IIP3 ; in dBm = OIP3 - GAIN
      PA_NF         = 4.7;              % PA Noise figure ; in dB
      Pregain = 0.35; 
      PA_pc = 1.81;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Possible values of test_type are:
%%%%%                               'onetone' for a one-tone sine 
%%%%%                               'twotone' for a two-tone sine 
%%%%%                               'mod'     for a modulated QAM 16 signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                              

test_type='onetone';
switch test_type
   case 'onetone'
      %%% one tone signal%%%
      basebandSig = exp(1j*2*pi*freqVin1*t);
   case 'twotone'
      %%% two tone signal%%%
      basebandSig = exp(1j*2*pi*freqVin1*t)+exp(1j*2*pi*freqVin2*t);
   case 'mod'
      %%% Modulated signal
      modSize       = 16; % Modulation order for 16QAM
      nQAMSymbols   = round(NSamples_BB/basebandOverSampling); % Number of QAM symbols to be generated
      inSig         = randi([0 modSize-1],nQAMSymbols,1);      % generate symbols as integer
      % Perform modulation : convert integer symbols to complex symbols
      qamSig        = qammod(inSig,modSize,'UnitAveragePower',true);

      % Apply filter with upsampling to basebandSamplingRate 
      basebandSig   = resample(qamSig,basebandOverSampling,1,basebandRRC);
      % Resample (compared to upfirdn) generates a signal that is exactly the 
      % length we can predict without having to compensate for the delay introduced by the filter
      % https://groups.google.com/d/msg/comp.soft-sys.matlab/UGLNR9vFqhM/c56ZlfUlhhcJ

   otherwise
      %%% one tone signal%%%
      basebandSig = exp(1j*2*pi*freqVin1*t);
end
    


%%% IQ separation for real baseband signals %%%
[basebandDigital_I_unorm,basebandDigital_Q_unorm] = complx2cart(basebandSig(:));

%%% Digital to Analog Conversion %%%
nBitDAC = 10;           % Number of bits of the DAC
Vref    = 1;            % Voltage reference of the DAC
dacType = 'zoh';        % DAC type ; can be 'zoh' or 'impulse'

% Normalize signal for conversion
% Must use same scale factor for both wave (Take max of both)
normalize_factor    = max( max(abs(basebandDigital_I_unorm)),...
                           max(abs(basebandDigital_Q_unorm)));
basebandDigital_I   = basebandDigital_I_unorm/normalize_factor*Vref;
basebandDigital_Q   = basebandDigital_Q_unorm/normalize_factor*Vref;

% Perform conversion
[basebandAnalog_dac_I, DAC_I_pc] = PC_DAC(basebandDigital_I,nBitDAC,Vref,dacType,basebandSamplingRate,continuousTimeSamplingRate);
[basebandAnalog_dac_Q, DAC_Q_pc] = PC_DAC(basebandDigital_Q,nBitDAC,Vref,dacType,basebandSamplingRate,continuousTimeSamplingRate);

%%% Baseband Analog filter %%%
TXBB_Filt_NF    = 10;    %(in dB)
TXBB_Filt_Fcut  = 15e6;  % Filter TX BB Fcut 3dB Frequency
TXBB_Filt_Order = 8;     % Filter TX BB Order
Rin             = 50;    % Input impedance of the filter
TXBB_Filt_pc = (10^(-10))*TXBB_Filt_Fcut*TXBB_Filt_Order; % Power consumption of the reconstruction filter
% Instanciate filter (due to numerical issue, the f ilter has to be instanciated as SOS)
[TXBB_Filt_z,TXBB_Filt_p,TXBB_Filt_k]=butter(TXBB_Filt_Order,TXBB_Filt_Fcut/(continuousTimeSamplingRate/2));
TXBB_Filt_sos = zp2sos(TXBB_Filt_z,TXBB_Filt_p,TXBB_Filt_k);
% Perform filtering
basebandAnalog_filt_I = basebandAnalogFilt(basebandAnalog_dac_I,TXBB_Filt_sos,TXBB_Filt_NF,Rin,continuousTimeSamplingRate);
basebandAnalog_filt_Q = basebandAnalogFilt(basebandAnalog_dac_Q,TXBB_Filt_sos,TXBB_Filt_NF,Rin,continuousTimeSamplingRate);

%%% Mixing up to RF %%%
Flo      = 2.4e9; % Local Oscillator Frequency
[rfSignal, upMixer_pc] = PC_upMixer(basebandAnalog_filt_I,basebandAnalog_filt_Q,Flo,continuousTimeSamplingRate);

%%% ACPR and Power in the usefull band%%%
rfPASignal    = rfPA(Pregain*rfSignal,PA_Gain,PA_NF,PA_IIP3,Rin,continuousTimeSamplingRate/2);
[ACPR_high, ACPR_low, Pow_useful_band] = ACPR_PA(rfPASignal, Flo, Rin, continuousTimeSamplingRate);

if strcmp(test_type, 'mod')
    disp(['ACPR High ', num2str(ACPR_high), ' dB']);
    disp(['ACPR Low ', num2str(ACPR_low), ' dB']);
end

disp(['Puissance utile ', num2str(Pow_useful_band), ' dBm']);

%%% We compute the consommation of the TX%%%    
consommation_TX = DAC_I_pc + DAC_Q_pc + TXBB_Filt_pc*2 + upMixer_pc + PA_pc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                      Channel                        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Channel %%%
carrierFreq        = Flo; % Center frequency of the transmission
c                  = 3e8; % speed of light in vacuum
distance           = 1400; % Distance between Basestation and UE : [1.4,1.4e3] metres
% Amplitude Attenuation in free space
ChannelAttenuation = (c/carrierFreq./(4*pi*distance));
rxSignal           = rfPASignal*ChannelAttenuation;

ChannelAttenuation_min_dB = 20*log10((c/carrierFreq./(4*pi*1.4)));
ChannelAttenuation_max_dB = 20*log10((c/carrierFreq./(4*pi*1400)));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                     Receiver                        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% We need to compute the voltages

%inputPowerRange_mindB = 10*log10((rfPASignal*(c/carrierFreq./(4*pi*1.4)))*sqrt(1e3/Rin)); %(voltage)*1000R
%inputPowerRange_maxdB = 10*log10(rfPASignal*(c/carrierFreq./(4*pi*1400))*sqrt(1e3/Rin)); %(voltage)*1000R

requiredADCPowerdB = 10*log10((Vref^2)/(2*Rin)*1000);


overallGain_max = requiredADCPowerdB-(Pow_useful_band+ChannelAttenuation_min_dB);



%%% We add the Antenna noise to determinate the SNR in RX %%%
BW = 20e6;
K   = 1.38e-23;
T   = 290;      

ThermalNoisedBm =10*log10(K*BW*T*1000);

%%% We compute the SNR in and SNR out%%%

SNR_in_RX_Min = Pow_useful_band + ChannelAttenuation_max_dB - ThermalNoisedBm; %SNR in minimum

SNR_out_RX_ideal = 10; % We want the SNR out to be 10dB for every distance
NF_RX = SNR_in_RX_Min - SNR_out_RX_ideal;% NF of the RX chain


LNA_NF   = [1:1:11];    % (dB) A DETERMINER!!
SNR_outputADC_v1 = zeros(1,length(LNA_NF));

for ii=1:length(LNA_NF)
    %%% LNA %%%
    LNA_Gain = 15;   % (dB) Déterminé avec la séance sur le LNA
    LNA_IIP3 = 0;  % (dBm)

    [rfLNASignal, LNA_pc] = PC_rfLNA(rxSignal,LNA_Gain,LNA_NF(ii),LNA_IIP3,Rin,continuousTimeSamplingRate/2);

    %%% Mixing down to BB %%%
    [basebandAnalog_raw_I,basebandAnalog_raw_Q, downMixer_pc] = PC_downMixer(rfLNASignal,Flo,continuousTimeSamplingRate);

    %%% Baseband Analog f_ilter %%%
    RXBB_Filt_NF    = 10;     %(in dB) FIXED!!
    RXBB_Filt_Fcut  = 15e6;  % Filter RX BB Fcut 3dB Frequency
    RXBB_Filt_Order = 6;     % Filter RX BB Order
    RXBB_Filt_pc = (10^(-10))*2*RXBB_Filt_Fcut*RXBB_Filt_Order; % Power consumption of the anti-aliasing filter
    % Instanciate filter (due to numerical issue, the filter has to be instanciated as SOS)
    [RXBB_Filt_z,RXBB_Filt_p,RXBB_Filt_k]=butter(RXBB_Filt_Order,RXBB_Filt_Fcut/(continuousTimeSamplingRate/2));
    RXBB_Filt_sos = zp2sos(RXBB_Filt_z,RXBB_Filt_p,RXBB_Filt_k);
    % Perform filtering
    basebandAnalog_filtrx_I = basebandAnalogFilt(basebandAnalog_raw_I,RXBB_Filt_sos,RXBB_Filt_NF,Rin,continuousTimeSamplingRate);
    basebandAnalog_filtrx_Q = basebandAnalogFilt(basebandAnalog_raw_Q,RXBB_Filt_sos,RXBB_Filt_NF,Rin,continuousTimeSamplingRate);


    %%% Baseband Gain %%%
    BBamp_Gain    = overallGain_max-LNA_Gain; % (dB)
    BBamp_IIP3    = 40; % (dBm) Fixed???
    BBamp_NF      = 0; % (dB) FIXED!!
    BBamp_pc = (10^(-10))*2*RXBB_Filt_Fcut;
    basebandAnalog_amp_I = BBamp(basebandAnalog_filtrx_I,BBamp_Gain,BBamp_NF,BBamp_IIP3,Rin,continuousTimeSamplingRate/2);
    basebandAnalog_amp_Q = BBamp(basebandAnalog_filtrx_Q,BBamp_Gain,BBamp_NF,BBamp_IIP3,Rin,continuousTimeSamplingRate/2);
    %basebandAnalog_amp   = rfLNA(rxSignal,LNA_Gain,LNA_NF,LNA_IIP3,Rin,continuousTimeSamplingRate/2); %Retourne le signal de sortie du LNA en WATTS




    %%% Analog to Digital Conversion %%%
    nBitADC = 13;
    delay   = 0; % WARNING : non trivial value !!! to be thoroughly analyzed
    adcSamplingRate = basebandSamplingRate;
    % Perform conversion


    [basebandAnalog_adc_I, ADC_I_pc] = PC_ADC(basebandAnalog_amp_I,nBitADC,Vref,adcSamplingRate,delay,continuousTimeSamplingRate);
    [basebandAnalog_adc_Q, ADC_Q_pc] = PC_ADC(basebandAnalog_amp_Q,nBitADC,Vref,adcSamplingRate,delay,continuousTimeSamplingRate);

    %%% IQ combination for complex baseband signals %%%
    basebandComplexDigital                = complex(basebandAnalog_adc_I,basebandAnalog_adc_Q);


    % RX RRC and downsampling (reverse effect of resample(qamSig...) )
    % WARNING : this downsampling may create unexpected sampling effects due to butterworth filtering and phase distortion
    %           please check signals integrity before and after this step
    basebandComplexDigital_fir            = resample(basebandComplexDigital,1,basebandOverSampling,basebandRRC);

    % Normalize received symbols to UnitAveragePower (see qammod(inSig)) 
    % Trully effective when noise and distortions are not too large compared to the useful signal
    basebandComplexDigital_fir            = basebandComplexDigital_fir / sqrt(var(basebandComplexDigital_fir));

    % Coarse truncation of the transient parts. 
    % This should be optimized with respect to the filters delays. 
    basebandComplexDigital_fir_truncated  = basebandComplexDigital_fir(10:end-10);


    %%%SNR calcul%%%
    %Parameters for plot_spectrum
    win = 1;
    lineSpec_index = 3;
    fullband = 1;
    scaletype = 'lin';

    %We determinate the output SNR
    basebandComplexSpectrum = plot_spectrum(basebandComplexDigital, win, adcSamplingRate, lineSpec_index, fullband, scaletype);
    bw_moitie = 10e6;
    SNR_outputADC_v1(ii) = Calcul_SNR(basebandComplexSpectrum,adcSamplingRate,bw_moitie);

end

nBitADC   = [1:1:20]; 
SNR_outputADC_v2 = zeros(1,length(nBitADC));

for ii=1:length(nBitADC)
    %%% LNA %%%
    LNA_Gain = 15;   % (dB) Déterminé avec la séance sur le LNA
    LNA_IIP3 = 0;  % (dBm)
    LNA_NF_const = 3;
    
    [rfLNASignal, LNA_pc] = PC_rfLNA(rxSignal,LNA_Gain,LNA_NF_const,LNA_IIP3,Rin,continuousTimeSamplingRate/2);

    %%% Mixing down to BB %%%
    [basebandAnalog_raw_I,basebandAnalog_raw_Q, downMixer_pc] = PC_downMixer(rfLNASignal,Flo,continuousTimeSamplingRate);

    %%% Baseband Analog f_ilter %%%
    RXBB_Filt_NF    = 10;     %(in dB) FIXED!!
    RXBB_Filt_Fcut  = 15e6;  % Filter RX BB Fcut 3dB Frequency
    RXBB_Filt_Order = 6;     % Filter RX BB Order
    RXBB_Filt_pc = (10^(-10))*2*RXBB_Filt_Fcut*RXBB_Filt_Order; % Power consumption of the anti-aliasing filter
    % Instanciate filter (due to numerical issue, the filter has to be instanciated as SOS)
    [RXBB_Filt_z,RXBB_Filt_p,RXBB_Filt_k]=butter(RXBB_Filt_Order,RXBB_Filt_Fcut/(continuousTimeSamplingRate/2));
    RXBB_Filt_sos = zp2sos(RXBB_Filt_z,RXBB_Filt_p,RXBB_Filt_k);
    % Perform filtering
    basebandAnalog_filtrx_I = basebandAnalogFilt(basebandAnalog_raw_I,RXBB_Filt_sos,RXBB_Filt_NF,Rin,continuousTimeSamplingRate);
    basebandAnalog_filtrx_Q = basebandAnalogFilt(basebandAnalog_raw_Q,RXBB_Filt_sos,RXBB_Filt_NF,Rin,continuousTimeSamplingRate);


    %%% Baseband Gain %%%
    BBamp_Gain    = overallGain_max-LNA_Gain; % (dB)
    BBamp_IIP3    = 40; % (dBm) Fixed???
    BBamp_NF      = 0; % (dB) FIXED!!
    BBamp_pc = (10^(-10))*2*RXBB_Filt_Fcut;
    basebandAnalog_amp_I = BBamp(basebandAnalog_filtrx_I,BBamp_Gain,BBamp_NF,BBamp_IIP3,Rin,continuousTimeSamplingRate/2);
    basebandAnalog_amp_Q = BBamp(basebandAnalog_filtrx_Q,BBamp_Gain,BBamp_NF,BBamp_IIP3,Rin,continuousTimeSamplingRate/2);
    %basebandAnalog_amp   = rfLNA(rxSignal,LNA_Gain,LNA_NF,LNA_IIP3,Rin,continuousTimeSamplingRate/2); %Retourne le signal de sortie du LNA en WATTS




    %%% Analog to Digital Conversion %%%
    delay   = 0; % WARNING : non trivial value !!! to be thoroughly analyzed
    adcSamplingRate = basebandSamplingRate;
    % Perform conversion


    [basebandAnalog_adc_I, ADC_I_pc] = PC_ADC(basebandAnalog_amp_I,nBitADC(ii),Vref,adcSamplingRate,delay,continuousTimeSamplingRate);
    [basebandAnalog_adc_Q, ADC_Q_pc] = PC_ADC(basebandAnalog_amp_Q,nBitADC(ii),Vref,adcSamplingRate,delay,continuousTimeSamplingRate);

    %%% IQ combination for complex baseband signals %%%
    basebandComplexDigital                = complex(basebandAnalog_adc_I,basebandAnalog_adc_Q);


    % RX RRC and downsampling (reverse effect of resample(qamSig...) )
    % WARNING : this downsampling may create unexpected sampling effects due to butterworth filtering and phase distortion
    %           please check signals integrity before and after this step
    basebandComplexDigital_fir            = resample(basebandComplexDigital,1,basebandOverSampling,basebandRRC);

    % Normalize received symbols to UnitAveragePower (see qammod(inSig)) 
    % Trully effective when noise and distortions are not too large compared to the useful signal
    basebandComplexDigital_fir            = basebandComplexDigital_fir / sqrt(var(basebandComplexDigital_fir));

    % Coarse truncation of the transient parts. 
    % This should be optimized with respect to the filters delays. 
    basebandComplexDigital_fir_truncated  = basebandComplexDigital_fir(10:end-10);


    %%%SNR calcul%%%
    %Parameters for plot_spectrum
    win = 1;
    lineSpec_index = 3;
    fullband = 1;
    scaletype = 'lin';

    %We determinate the output SNR
    basebandComplexSpectrum = plot_spectrum(basebandComplexDigital, win, adcSamplingRate, lineSpec_index, fullband, scaletype);
    bw_moitie = 10e6;
    SNR_outputADC_v2(ii) = Calcul_SNR(basebandComplexSpectrum,adcSamplingRate,bw_moitie);

end

figure(1);
plot(LNA_NF, SNR_outputADC_v1);
title('SNR en fonction du NF du LNA');
xlabel('NF (dB)');
ylabel('SNR (dB)');
grid on;
line_hdl=get(gca,'children');
set(line_hdl,{'marker'},{'s'});
set(line_hdl,{'color'},{[64,61,88]/256});
set(line_hdl,'linewidth',2);
set(gca,'fontsize',15);
set(get(gca,'title'),'fontsize',15);
set(get(gca,'xlabel'),'fontsize',15);
set(get(gca,'ylabel'),'fontsize',15);

figure(2);
plot(nBitADC, SNR_outputADC_v2);
title('SNR en fonction du nombre de bits de l ADC');
xlabel('Nbits');
ylabel('SNR (dB)');
grid on;
line_hdl=get(gca,'children');
set(line_hdl,{'marker'},{'s'});
set(line_hdl,{'color'},{[64,61,88]/256});
set(line_hdl,'linewidth',2);
set(gca,'fontsize',15);
set(get(gca,'title'),'fontsize',15);
set(get(gca,'xlabel'),'fontsize',15);
set(get(gca,'ylabel'),'fontsize',15);

%------------- END OF CODE --------------

    