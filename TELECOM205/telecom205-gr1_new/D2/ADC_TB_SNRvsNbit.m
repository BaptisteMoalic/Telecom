% Test bench plottant le SNR et le puissance consommée en fonction du
% nombre de bits pour l'ADC
%------------- BEGIN CODE --------------
close all;
clear;

%%ADC Specifications%%%
Nbits_ADC               = [1:1:20];
Vref_ADC               = 1;
Fs_ADC                  = 30e6;
basebandSamplingRate    = Fs_ADC;


%%General%%%
continuousTimeSamplingRate    = 900e6; %Operating Frequency to emulate the behavior of a continuous time system
Ts_Cont                       = 1/continuousTimeSamplingRate; %Continuous time sampling period
Subsamp_fac                   = round(continuousTimeSamplingRate/basebandSamplingRate);
N   = 30*2^15;  %Number of signal points
BW  = 10e6; %Signal bandwidth
fmin = 0;
fmax = 10e6;
K   = 1.38e-23; %Boltzmann Constant
T   = 290;      %room temperature
t_Cont = 0:Ts_Cont:(N-1)*Ts_Cont; %Time vetor
f_Cont = 0:continuousTimeSamplingRate/N:continuousTimeSamplingRate/2-continuousTimeSamplingRate/N; %Frequency vector


Ndig  = round(N*basebandSamplingRate/continuousTimeSamplingRate);
Ts_BB  = 1/basebandSamplingRate; % Baseband sampling period
t_BB   = 0:Ts_BB:(Ndig-1)*Ts_BB; % Baseband Time vetor


Rin   = 50;  %Matching impedance chosen equal to 50

%%/Input Signal Specifications%%%%
fin_or    = [2.1e6];    %Input sine frequency
Bin_In    = round(fin_or/basebandSamplingRate*Ndig); %Determining the input bin
bin_min = max(round(fmin/Fs_ADC*Ndig),1);                   %bin minimal de la bande d'intégration
bin_max = min(round(fmax/Fs_ADC*Ndig),floor(Ndig/2));          %bin maximal de la bande d'intégration
Bin_Limits = [bin_min,bin_max];
n = 3;
fin       = Bin_In*basebandSamplingRate/Ndig;
Ain       = 1;
Input     = Ain*sin(2*pi*fin*t_Cont+rand()*180);%Input signal
SNDR = zeros(1,length(Nbits_ADC));
PS = zeros(1,length(Nbits_ADC));
P_cons = zeros(1,length(Nbits_ADC));

for i = 1 : 1 : length(Nbits_ADC)  
    [Digitaloutput,P_cons(i)] = PC_ADC(Input',Nbits_ADC(i),Vref_ADC,Fs_ADC,0,continuousTimeSamplingRate);
    [SNDR(i),PS(i)] = perf_estim(Digitaloutput,Bin_In,n,Bin_Limits);
end

figure(1)
plot(Nbits_ADC,SNDR)
xlabel('nombre de bits'); 
ylabel('SNDR');
title('SNDR en fct du nombre de bits pour un ADC')
line_hdl=get(gca,'children');
set(line_hdl,{'marker'},{'s'});
set(line_hdl,{'color'},{[64,61,88]/256});
set(line_hdl,'linewidth',2);
set(gca,'fontsize',15);
set(get(gca,'title'),'fontsize',15);
set(get(gca,'xlabel'),'fontsize',15);
set(get(gca,'ylabel'),'fontsize',15);
figure(2)
plot(Nbits_ADC,P_cons)
xlabel('nombre de bits'); 
ylabel('P consommée');
title('Puissance consommé pour un ADC')
line_hdl=get(gca,'children');
set(line_hdl,{'marker'},{'s'});
set(line_hdl,{'color'},{[64,61,88]/256});
set(line_hdl,'linewidth',2);
set(gca,'fontsize',15);
set(get(gca,'title'),'fontsize',15);
set(get(gca,'xlabel'),'fontsize',15);
set(get(gca,'ylabel'),'fontsize',15);
%------------- END OF CODE --------------