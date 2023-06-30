%% [rej] = d4_perfs(mode,rx)


%% Rejection rate for deliverable D4
%%
%% mode = selected data rate for all the users ('40k','400k','4M','40M')
%% rx = selected receiver for all the users ('zf','dfe')

%% rej = rejection rate versus K (number of users)

%% Location : Telecom ParisTech
%% Author : Philippe Ciblat <ciblat@telecom-paristech.fr>
%% Date   : 10/12/2019


function [K, rej] = d4_perfs(mode,rx)

N = 100; %%frame size
Ts=1/(20e6);
Fs = 1/Ts;
B = 30e6; %%bandwidth
rho = 0.5; %%roll-off factor
fc = 2.4e9; %%carrier frequency
c = 3e8;
lambda = c/fc;
No = -174; %%dBm/Hz
Dmax = 2e3; %%maximum distance from bs
MC=1000; %%number of Monte-Carlo simulations
Ts_rho = (1+rho)/B; %%taking into account the roll-off


if(strcmp(mode,'40k')==1)
    R=40*10^(3);
    Kmax=2000;
end;

if(strcmp(mode,'400k')==1)
    R=400*10^(3);
    Kmax=200;
end;

if(strcmp(mode,'4M')==1)
    R=4*10^(6);
    Kmax=20;
end;

if(strcmp(mode,'40M')==1)
    R=40*10^(6);
    Kmax=2;
end;


%values below in dB
if(strcmp(rx,'zf')==1)
    %SNR_min_bpsk= [3.2, 10.5, 27]; %minimum Es/N0 for each channel (3-element vector);
    %SNR_min_16qam= [10.2, 15, 22.2]; %minimum Es/N0 for each channel (3-element vector);
    SNR_min_bpsk= [8, 13.4, 22.5]; 
    SNR_min_16qam= [15.1, 18.3, 33];
end;

if(strcmp(rx,'dfe')==1)
    %SNR_min_bpsk= [6, 7.8, 11]; %minimum Es/N0 for each channel (3-element vector);
    %SNR_min_16qam= [11, 13, 13.8]; %minim um Es/N0 for each channel (3-element vector);
    SNR_min_bpsk= [8.1, 11, 13.8]; 
    SNR_min_16qam= [14, 15.7, 21];
end;


K=[1:(floor(Kmax/10)+1):Kmax];
rej=zeros(1,length(K));

for kk=1:length(K)
    aux=0;
    
    for mm=1:MC
        xx= (rand(1, K(kk))*2-1)*1e3; % horizontal axis, uniformly-distributed distance over [-1km:1km] (K(kk)-element vector);
        yy= (rand(1, K(kk))*2-1)*1e3; % vertical axis, uniformly-distributed distance over [-1km:1km] (K(kk)-element vector);
        
        %%Squared
        %{
        d2=xx.^2+yy.^2;%% squared distance from the origin to each user
        num_inter = (lambda/4*pi)^2;
        a2=min(1, num_inter./d2);% square of the magnitude attenuation in Friis equation
        a2_dB=10*log10(a2);
        
        SNR_tx_max = 121; %dB
        SNR_rx_max=a2_dB+SNR_tx_max; %(calculate SNR at TX in dB)
        %}
        
        %%Not squared
        d=sqrt(xx.^2+yy.^2);%% distance from the origin to each user
        num_inter = lambda/(4*pi);
        a = min(1, num_inter./d);
        a_dB = 20*log10(a);
        
        SNR_tx_max = 20 + 10*log10(Ts_rho) - No; %dB %%121dB
        SNR_rx_max=a_dB+SNR_tx_max; %(calculate SNR at TX in dB)
        
        if(R*Ts*K(kk)<1)
            SNR_min=SNR_min_bpsk; %%ZF or DFE/BPSK: channel 1, channel 2, channel 3
        else
            SNR_min=SNR_min_16qam; %%ZF or DFE/16QAM: channel 1, channel 2, channel 3
        end
        
        SNR_rx_min=SNR_min(randi(3,K(kk),1));
        
        aux=aux+length((find(sign(SNR_rx_min-SNR_rx_max)+1)/2));
        
    end
    
    rej(kk)= aux/(K(kk)*MC);
    
    
end;


%% Channel display
%plot(K,rej,'r--');
%grid

endfunction
