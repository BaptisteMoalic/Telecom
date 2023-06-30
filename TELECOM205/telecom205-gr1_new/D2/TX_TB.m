close all;
clear all;

%%DAC Specifications%%%
Nbits_DAC=12;
Vref_DAC=1;
Fs_DAC=15e6;
mode=1;
Flo=0.9e9;

%%%%%%%%%%%% PA %%%%%%%%%%%
PA_IIP3=20;
PA_NF=10;
PA_Gain=14;


%%Filter Specifications%%%
Fcut=11.121e6;   %Filter Fcut 3dB Frequency
Order=6;      %Filter Order


%%General%%%
Fs_Cont=10e9; %Operating Frequency to emulate the behavior of a continuous time system
Ts=1/Fs_Cont; %sampling period 
Ts_DAC=1/Fs_DAC;

Subsamp_fac=round(Fs_Cont/Fs_DAC);
N=2^13;  %Number of signal points
BW=10e6; %Signal bandwidth
K=1.38e-23; %Boltzmann Constant
T=290;      %room temperature

t_DAC=0:Ts_DAC:(N-1)*Ts_DAC; %Time vetor  

t=0:Ts:(N-1)*Ts; %Time vetor  
f=0:Fs_Cont/N:Fs_Cont/2-Fs_Cont/N; %Frequency vector
R=50;  %Matching impedance chosen equal to 50
AntennaNoise=randn(1,N)*sqrt(K*T*BW);


%%%%%%%%%%% Input signal %%%%%%%
fin_or=[0.5e6, 0.7e6];    %Input sine frequency
Bin_in=round(fin_or/Fs_DAC*N); %Determining the input bin
fin=Bin_in*Fs_DAC/N;
Ain=0.5;
PI=rand()*pi;
Input_I=Ain*sin(2*pi*fin(1)*t_DAC+PI)+Ain*sin(2*pi*fin(2)*t_DAC+PI);%Input signal I Channel
Input_Q=Ain*sin(2*pi*fin(1)*t_DAC+PI-pi/2)+Ain*sin(2*pi*fin(2)*t_DAC+PI-pi/2);%Input signal Q Channel



%%%%%%%%%RF%%%%%%%%%%%
TxOut=TX(Input_I,Input_Q,Vref_DAC,Nbits_DAC,Fs_DAC,Fs_Cont,mode,Order,Fcut,0,Flo,PA_IIP3,PA_NF,PA_Gain);
      

      
      

dessiner(TxOut*sqrt(1e3/R),2,Fs_Cont,1);
xlabel('frequency(Hz)')
ylabel('PSD(dBm/bin)')
title('TX Output')



axis([Flo-BW,Flo+BW,-150,30])





