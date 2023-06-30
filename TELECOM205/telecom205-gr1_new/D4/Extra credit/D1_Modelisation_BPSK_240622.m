Ts = 0.05e-6;
M = 4;
L = 4;
n = 2*L+1;
r = 0.5;

% Channel 0 (AWGN)
A0 = [1];
tau0 = [0];

% BER vs SNR

% We start by generating the SNR in the x-axis
SNR_bit=[0:1:20];
R = 1;
scaling= R ; 
No = 1./(scaling*10.^(SNR_bit/10));
N = 100;                            % nombre de symboles a envoyer
const = 'PSK';
M_const = 2;
N_bits= N*log2(M_const)*R;          % nombre de bits d'information
H0 = eye(N);

% Parametres algo de codage
nb_err_min = 1000 ;
nb_iter_max = 1000 ;

BER_treshold1 = zeros(1,length(SNR_bit));
BER_multi_treshold1 = zeros(1,length(SNR_bit));
BER_multi_treshold2 = zeros(1,length(SNR_bit));

nb_err_treshold1 = zeros(1,length(SNR_bit)); 
nb_err_multi_treshold1 = zeros(1,length(SNR_bit)); 
nb_err_multi_treshold2 = zeros(1,length(SNR_bit)); 

% calcul du BER   
BER_treshold1=BER_treshold(nb_err_treshold1,BER_treshold1,SNR_bit,N_bits,N,nb_iter_max,nb_err_min,const,M_const,H0,No);
%BER_multi_treshold1=BER_multi_treshold(nb_err_treshold1,BER_treshold1,SNR_bit,N_bits,N,nb_iter_max,nb_err_min,const,M_const,H0,No);
BER_multi_treshold1=BER_multi_treshold_V2(nb_err_multi_treshold1,BER_multi_treshold1,SNR_bit,N_bits,N,nb_iter_max,nb_err_min,const,M_const,H0,No);
BER_multi_treshold2=BER_multi_treshold_V3(nb_err_multi_treshold2,BER_multi_treshold2,SNR_bit,N_bits,N,nb_iter_max,nb_err_min,const,M_const,H0,No);

% plotting
figure(1)
semilogy(SNR_bit,BER_treshold1)
grid on
hold on
semilogy(SNR_bit,BER_multi_treshold1)
hold on
semilogy(SNR_bit,BER_multi_treshold2)
hold off
xlabel('Eb/No (in dB)')
ylabel('BER')
title('BPSK non-code channel AWGN')
legend('1 user','3 users without MUI','3 users without MUI further')
line_hdl=get(gca,'children');
set(line_hdl,{'marker'},{'s';'d';'p'});
set(line_hdl,{'color'},{[64,61,88]/256;[252,119,83]/256;[100,50,83]/256});
set(line_hdl,'linewidth',2);
set(gca,'fontsize',15);
set(get(gca,'title'),'fontsize',15);
set(get(gca,'xlabel'),'fontsize',15);
set(get(gca,'ylabel'),'fontsize',15);


