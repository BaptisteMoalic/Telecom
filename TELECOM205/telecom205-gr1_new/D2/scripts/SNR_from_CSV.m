function [SNR] = SNR_from_CSV(csvFileName)
%
%   Input: 
%   BasebandSignal, the complex signal we want to compute the SNR from
%   fc, the carrier frequency
%
%   Ouput:
%   SNR, the signal-to-noise ratio from the input baseband signal
%

basebandSignal = loadCSVmeasurements(csvFileName);

%Parameters for plot_spectrum
win = 1;
fs = 30.72e6;
lineSpec_index = 3; %???
fullband = 1;
scaletype = 'lin'; %'lin' ou 'log'

outputSpectrum = plot_spectrum(basebandSignal, win, fs, lineSpec_index, fullband, scaletype);

bw_moitie = 10e6;

SNR = Calcul_SNR(outputSpectrum, fs, bw_moitie);

end

