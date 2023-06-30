function rfPASignal=TX(basebandDigital_I,basebandDigital_Q,Vref, nBitDAC,basebandSamplingRate,continuousTimeSamplingRate,dacType,TXBB_Filt_Order,TXBB_Filt_NF,TXBB_Filt_Fcut,Flo,PA_IIP3,PA_NF,PA_Gain)
Rin=50;


% Perform conversion
basebandAnalog_dac_I = DAC(basebandDigital_I,nBitDAC,Vref,dacType,basebandSamplingRate,continuousTimeSamplingRate);
basebandAnalog_dac_Q = DAC(basebandDigital_Q,nBitDAC,Vref,dacType,basebandSamplingRate,continuousTimeSamplingRate);


% Instanciate filter (due to numerical issue, the filter has to be instanciated as SOS)
[TXBB_Filt_z,TXBB_Filt_p,TXBB_Filt_k]=butter(TXBB_Filt_Order,TXBB_Filt_Fcut/(continuousTimeSamplingRate/2));
TXBB_Filt_sos = zp2sos(TXBB_Filt_z,TXBB_Filt_p,TXBB_Filt_k);
% Perform filtering
basebandAnalog_filt_I = basebandAnalogFilt(basebandAnalog_dac_I,TXBB_Filt_sos,TXBB_Filt_NF,Rin,continuousTimeSamplingRate);
basebandAnalog_filt_Q = basebandAnalogFilt(basebandAnalog_dac_Q,TXBB_Filt_sos,TXBB_Filt_NF,Rin,continuousTimeSamplingRate);

%%% Mixing up to RF %%%
rfSignal = upMixer(basebandAnalog_filt_I,basebandAnalog_filt_Q,Flo,continuousTimeSamplingRate);

%%% RF Amplification %%%
rfPASignal = rfPA(rfSignal,PA_Gain,PA_NF,PA_IIP3,Rin,continuousTimeSamplingRate/2);