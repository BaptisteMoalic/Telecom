% Test bench plottant le SNR et le puissance consommée en fonction du
% nombre de bits pour le DAC
%------------- BEGIN CODE --------------
close all;
clear;

%%DAC Specifications%%%
Nbits_DAC               = [1:1:20];
Vref_DAC                = 1;
Fs_DAC                  = 30e6;
basebandSamplingRate    = Fs_DAC;


%%General%%%
continuousTimeSamplingRate    = 900e6; %Operating Frequency to emulate the behavior of a continuous time system
Ts_Cont                       = 1/continuousTimeSamplingRate; %Continuous time sampling period
Subsamp_fac                   = round(continuousTimeSamplingRate/basebandSamplingRate);
N   = 2^13;  %Number of signal points
BW  = 10e6; %Signal bandwidth
fmin = 0;
fmax = 10e6;
K   = 1.38e-23; %Boltzmann Constant
T   = 290;      %room temperature
t_Cont = 0:Ts_Cont:(N*Subsamp_fac-1)*Ts_Cont; %Time vetor
f_Cont = 0:continuousTimeSamplingRate/N:continuousTimeSamplingRate/2-continuousTimeSamplingRate/N; %Frequency vector

Ts_BB  = 1/basebandSamplingRate; % Baseband sampling period
t_BB   = 0:Ts_BB:(N-1)*Ts_BB; % Baseband Time vetor


Rin   = 50;  %Matching impedance chosen equal to 50


%%/Input Signal Specifications%%%%
fin_or    = [1e6];    %Input sine frequency
Bin_In    = round(fin_or/basebandSamplingRate*N); %Determining the input bin
bin_min = max(round(fmin/Fs_DAC*N),1);                   %bin minimal de la bande d'intégration
bin_max = min(round(fmax/Fs_DAC*N),floor(N/2));          %bin maximal de la bande d'intégration
Bin_Limits = [bin_min,bin_max];
n = 3;
fin       = Bin_In*Fs_DAC/N;
Ain       = 1;
Input     = Ain*sin(2*pi*fin*t_BB+rand()*180);%Input signal
SNDR_impulse = zeros(1,length(Nbits_DAC));
SNDR_ZOH = zeros(1,length(Nbits_DAC));
PS_impulse = zeros(1,length(Nbits_DAC));
PS_ZOH = zeros(1,length(Nbits_DAC));
Pimpulse = zeros(1,length(Nbits_DAC));
Pzoh = zeros(1,length(Nbits_DAC));

for i = 1 : 1 : length(Nbits_DAC)  

    [AnalogOutputImpulse,P_cons_impulse(i)] = PC_DAC(Input',Nbits_DAC(i),Vref_DAC,'impulse',Fs_DAC,continuousTimeSamplingRate);
    [SNDR_impulse(i),PS_impulse(i)] = perf_estim(AnalogOutputImpulse,Bin_In,n,Bin_Limits,1);

    [AnalogOutputZOH,P_cons_zoh(i)] = PC_DAC(Input',Nbits_DAC(i),Vref_DAC,'zoh',Fs_DAC,continuousTimeSamplingRate);
    [SNDR_ZOH(i),PS_ZOH(i)] = perf_estim(AnalogOutputImpulse,Bin_In,n,Bin_Limits,1);
end

figure(1)
plot(Nbits_DAC,SNDR_impulse)
hold on
plot(Nbits_DAC,SNDR_ZOH,'--')
xlabel('nombre de bits'); 
ylabel('SNDR en dB');
title('SNDR en fct du nombre de bits pour un DAC')
legend('impulse','ZOH')
line_hdl=get(gca,'children');
set(line_hdl,{'marker'},{'s';'d'});
set(line_hdl,{'color'},{[64,61,88]/256;[252,119,83]/256});
set(line_hdl,'linewidth',2);
set(gca,'fontsize',15);
set(get(gca,'title'),'fontsize',15);
set(get(gca,'xlabel'),'fontsize',15);
set(get(gca,'ylabel'),'fontsize',15);

figure(2)
plot(Nbits_DAC,P_cons_impulse)
hold on
plot(Nbits_DAC,P_cons_zoh,'--')
xlabel('nombre de bits'); 
ylabel('puissance consommée');
title('Puissance consommé pour un DAC')
legend('impulse','ZOH')
line_hdl=get(gca,'children');
set(line_hdl,{'marker'},{'s';'d'});
set(line_hdl,{'color'},{[64,61,88]/256;[252,119,83]/256});
set(line_hdl,'linewidth',2);
set(gca,'fontsize',15);
set(get(gca,'title'),'fontsize',15);
set(get(gca,'xlabel'),'fontsize',15);
set(get(gca,'ylabel'),'fontsize',15);
%------------- END OF CODE --------------