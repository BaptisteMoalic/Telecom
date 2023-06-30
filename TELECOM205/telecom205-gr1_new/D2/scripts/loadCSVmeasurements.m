
function [basebandSignal] = loadCSVmeasurements(csvFileName)
%loadCSVmeasurements - Reads a CSV file output from IIO Oscilloscope
%
% Syntax:  [basebandSignal] = loadCSVmeasurements(csvFileName)
%
% Inputs:
%    csvFileName: [string] the filename (may contain path) of the CSV file
%
% Outputs:
%    basebandSignal: [complex matrix] the baseband signal (complex matrix)
%
% Example: 
%    signal = loadCSVmeasurements('measurement-test.csv')
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: csvread
% Author: Germain Pham
% Télécom Paris
% email: dpham@telecom-paris.fr
% Mar 2021; Last revision: 

%------------- BEGIN CODE --------------

csvdata           = csvread(csvFileName);
basebandSignal    = complex(csvdata(:,1),csvdata(:,2));

%------------- END OF CODE --------------

