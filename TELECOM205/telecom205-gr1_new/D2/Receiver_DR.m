close all;

K=1.38e-23; %Boltzmann Constant
T=290;      %room temperature
R=50;       %Input impedance 

N=2^13;     %Number of signal points ADC
BW=10e6;    %Signal bandwidth
Flo=0.9e9;  %Central frequency




Fs_ADC=15e6;     %sampling frequency ADC
Fs_Cont=10e9;     %sampling frequency Simulation
Ts_Cont=1/Fs_Cont; %sampling period Simulation
Vref=1; % Reference voltage of the ADC
Nbits_ADC=10; %number of bits for the ADC



N_Sim=floor(N*Fs_Cont/Fs_ADC);     %Number of  Simulation points
t_Sim=0:Ts_Cont:(N_Sim-1)*Ts_Cont; %Time vetor Simulation 
f_Sim=0:Fs_Cont/N_Sim:Fs_Cont/2-Fs_Cont/N_Sim; %Frequency vector Simulation


Ts_ADC=1/Fs_ADC; %sampling period ADC 
t_ADC=0:Ts_ADC:(N-1)*Ts_ADC; %Time vetor Simulation 
f_ADC=0:Fs_ADC/N:Fs_ADC/2-Fs_ADC/N; %Frequency vector Simulation

fin_or=[1.1e6,2.1e6]; %Input sine frequency
Bin_in=round(fin_or./Fs_ADC*N); %Determining the input bin
fin=Bin_in.*Fs_ADC/N;%

AntennaNoise=randn(1,N_Sim)*sqrt(K*T*BW*R);
Pin=-40;  %Pin in dBm
Ain=sqrt(10.^((Pin-30)/10)*2*R);



G_LNA=30; %Gain of the first stage in dB
NF_LNA=4; %Noise figure of the first stage in dB
IIP3_LNA=-20; %set very high for Simplicity

Filter_order=7;

SNR_out=zeros(1,length(Ain));
SNR_in=zeros(1,length(Ain));
in=0;
for i=1:length(fin)
  in=in+Ain*sin(2*pi*(Flo+fin(i))*t_Sim+rand()*180); %Input signal
end
in=in+AntennaNoise;
out_LNA=Amplifier(in,G_LNA,NF_LNA,Fs_Cont/2,IIP3_LNA,R);      %output Signal of the amplifier

[outI,outQ] = DownMixer(out_LNA,Flo,Fs_Cont);



[filter_num,filter_denum] = butter(Filter_order,10*BW/Fs_Cont);
Out_Filter=filter(filter_num,filter_denum,outI);

DR=floor(Fs_Cont/Fs_ADC);
Out_Filter_dec=Out_Filter(1:DR:end);

Out_ADC=ADC(Out_Filter_dec,n,Vref);%
%SNR_out=perf_estim(Out_ADC,1,Bin_in,5,1);   


subplot(2,2,1)
dessiner(out_LNA*sqrt(1000/R),1,Fs_Cont);
title('spetrum output LNA')
xlabel('frequency(Hz)')
ylabel('PSD(dBm/bin)')
subplot(2,2,2)

dessiner(outI*sqrt(1000/R),1,Fs_Cont,1);
title('spetrum output mixer')
xlabel('frequency(Hz)')
ylabel('PSD(dBm/bin)')

subplot(2,2,3)
dessiner(Out_Filter*sqrt(1000/R),1,Fs_Cont,1);
title('spetrum output Filter')
xlabel('frequency(Hz)')
ylabel('PSD(dBm/bin)')


subplot(2,2,4)
dessiner(Out_ADC*sqrt(1000/R),1,Fs_ADC,1);
title('spetrum output ADC')
xlabel('frequency(Hz)')
ylabel('PSD(dBm/bin)')


