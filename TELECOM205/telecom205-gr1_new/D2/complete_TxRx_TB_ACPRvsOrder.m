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

addpath(genpath('./subblocks/'))

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Possible values of test_type are:
%%%%%                               'onetone' for a one-tone sine 
%%%%%                               'twotone' for a two-tone sine 
%%%%%                               'mod'     for a modulated QAM 16 signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                              

test_type='mod';
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
nBitDAC = 8;           % Number of bits of the DAC
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
TXBB_Filt_NF    = 00;    %(in dB)
TXBB_Filt_Fcut  = 15e6;  % Filter TX BB Fcut 3dB Frequency
TXBB_Filt_Order = [1:1:20];     % Filter TX BB Order
Rin             = 50;    % Input impedance of the filter
ACPR = zeros(1,length(TXBB_Filt_Order));
ACPR_high = zeros(1,length(TXBB_Filt_Order));
ACPR_low = zeros(1,length(TXBB_Filt_Order));
Pow_useful_band =zeros(1,length(TXBB_Filt_Order));

for ii=1:1:length(TXBB_Filt_Order)

    TXBB_Filt_pc = (10^(-10))*2*TXBB_Filt_Fcut*TXBB_Filt_Order(ii); % Power consumption of the reconstruction filter
    % Instanciate filter (due to numerical issue, the f ilter has to be instanciated as SOS)
    [TXBB_Filt_z,TXBB_Filt_p,TXBB_Filt_k]=butter(TXBB_Filt_Order(ii),TXBB_Filt_Fcut/(continuousTimeSamplingRate/2));
    TXBB_Filt_sos = zp2sos(TXBB_Filt_z,TXBB_Filt_p,TXBB_Filt_k);
    % Perform filtering
    basebandAnalog_filt_I = basebandAnalogFilt(basebandAnalog_dac_I,TXBB_Filt_sos,TXBB_Filt_NF,Rin,continuousTimeSamplingRate);
    basebandAnalog_filt_Q = basebandAnalogFilt(basebandAnalog_dac_Q,TXBB_Filt_sos,TXBB_Filt_NF,Rin,continuousTimeSamplingRate);
    
    %%% Mixing up to RF %%%
    Flo      = 2.4e9; % Local Oscillator Frequency
    [rfSignal, upMixer_pc] = PC_upMixer(basebandAnalog_filt_I,basebandAnalog_filt_Q,Flo,continuousTimeSamplingRate);
    
    %%% RF Amplification %%%
    PA_IIP3       = 100;   % PA IIP3 ; in dBm
    PA_NF         = 5;     % PA Noise figure ; in dB
    PA_Gain       = 25;    % PA Gain ; in dB power
    
    rfPASignal    = rfPA(rfSignal,PA_Gain,PA_NF,PA_IIP3,Rin,continuousTimeSamplingRate/2);
    [ACPR_high(ii), ACPR_low(ii), Pow_useful_band(ii)] = ACPR_PA(rfPASignal, Flo, Rin, continuousTimeSamplingRate);

end

figure(1)
plot(TXBB_Filt_Order,ACPR_high)
xlabel('Ordre'); 
ylabel('ACPR');
title("ACPR en fonction de l'ordre du filtre")
figure(2)
plot(TXBB_Filt_Order,Pow_useful_band)
xlabel('Ordre'); 
ylabel('Puissance utile');
title("Puissance utile en fonction de l'ordre du filtre")

%consommation_TX = DAC_I_pc + DAC_Q_pc + TXBB_Filt_pc + upMixer_pc;
%disp(['Puissance consommée par le TX ', num2str(consommation_TX), ' W']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                      Channel                        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Channel %%%
carrierFreq        = Flo; % Center frequency of the transmission
c                  = 3e8; % speed of light in vacuum
distance           = 100; % Distance between Basestation and UE : [1.4,1.4e3] metres
% Amplitude Attenuation in free space
ChannelAttenuation = (c/carrierFreq./(4*pi*distance));
rxSignal           = rfPASignal*ChannelAttenuation;

ChannelAttenuation_min = 10*log10((c/carrierFreq./(4*pi*1.4)));
ChannelAttenuation_max = 10*log10((c/carrierFreq./(4*pi*1400)));

disp(['The maximum of channel attenuation is ', num2str(ChannelAttenuation_max), ' dB']);
disp(['The minimum of channel attenuation is ', num2str(ChannelAttenuation_min), ' dB']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                     Receiver                        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% LNA %%%
LNA_Gain = 15;   % (dB)
LNA_IIP3 = 100;  % (dBm)
LNA_NF   = 1;    % (dB)
[rfLNASignal, LNA_pc] = PC_rfLNA(rxSignal,LNA_Gain,LNA_NF,LNA_IIP3,Rin,continuousTimeSamplingRate/2);

%%% Mixing down to BB %%%
[basebandAnalog_raw_I,basebandAnalog_raw_Q, downMixer_pc] = PC_downMixer(rfLNASignal,Flo,continuousTimeSamplingRate);

%%% Baseband Analog filter %%%
RXBB_Filt_NF    = 0;     %(in dB)
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
BBamp_Gain    = 20; % (dB)
BBamp_IIP3    = 40; % (dBm)
BBamp_NF      = 10; % (dB)
BBamp_pc = (10^(-10))*2*RXBB_Filt_Fcut*2; %Est-ce que c'est le bon Bw? + *2 parce que I et Q?
basebandAnalog_amp_I = BBamp(basebandAnalog_filtrx_I,BBamp_Gain,BBamp_NF,BBamp_IIP3,Rin,continuousTimeSamplingRate/2);
basebandAnalog_amp_Q = BBamp(basebandAnalog_filtrx_Q,BBamp_Gain,BBamp_NF,BBamp_IIP3,Rin,continuousTimeSamplingRate/2);
basebandAnalog_amp   = rfLNA(rxSignal,LNA_Gain,LNA_NF,LNA_IIP3,Rin,continuousTimeSamplingRate/2); %Retourne le signal de sortie du LNA en WATTS




%%% Analog to Digital Conversion %%%
nBitADC = 18;
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

consommation_RX = LNA_pc + downMixer_pc + RXBB_Filt_pc + BBamp_pc + ADC_I_pc + ADC_Q_pc;
disp(['Puissance consommée par le RX ', num2str(consommation_RX), ' W']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%            Plot section            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
window_number       = 1;
lineSpec_index      = 1;
fullband_spectrum   = true;

plot_spectrum(basebandSig,window_number,...
               adcSamplingRate,lineSpec_index,fullband_spectrum);
title('TX Digital Complex recombined signal')

window_number       = window_number+1;
plot_spectrum(basebandComplexDigital,window_number,...
               adcSamplingRate,lineSpec_index,fullband_spectrum);
title('Receiver complex recombined output')

window_number       = window_number+1;
fullband_spectrum   = false;
plot_spectrum(rfPASignal,window_number,...
               continuousTimeSamplingRate,lineSpec_index,fullband_spectrum);
title('PA spectrum')


if strcmp(test_type, 'mod')
   figure()
   subplot(1,2,1)
   plot(qamSig,'d')
   title('constellation at TX')
   subplot(1,2,2)
   plot(basebandComplexDigital_fir_truncated,'d')
   title('constellation at RX')
   % WARNING : the received constellation has almost no sense until phase
   %           distortion and filters delays have been thoroughly analyzed and
   %           repaired
   %           Quick and dirty solution : use FIR filters instead of Butterworth
   %           for 'modulation' case
end
%}



%------------- END OF CODE --------------
    