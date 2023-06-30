Ts = 0.05e-6;
M = 4;
L = 4;
n = 2*L+1;
r = 0.5;
N = 100;

% Channel 0 (AWGN)
A0 = [1];
tau0 = [0];

H0 = eye(N);


% BER vs SNR

% We start by generating the SNR in the x-axis
SNR_bit=[-2:2:20];
R = 1;
scaling= R ; 
No = 1./(scaling*10.^(SNR_bit/10));
N = 100;   %100      plutot que 31                   % nombre de symboles a envoyer
% Parametres algo de codage
nb_err_min = 500 ;
nb_iter_max = 150 ;

%BPSK with and without coding
const = 'PSK';
M_const = 2;
N_symb= N*log2(M_const)*R;

nb_corr_treshold_BPSK = zeros(1,length(SNR_bit));
throughput_treshold_BPSK = zeros(1,length(SNR_bit));

nb_corr_treshold_BPSK_BCH = zeros(1,length(SNR_bit));
throughput_treshold_BPSK_BCH = zeros(1,length(SNR_bit));

throughput_BPSK=BER_treshold(nb_corr_treshold_BPSK,throughput_treshold_BPSK,SNR_bit,N_symb,N,nb_iter_max,nb_err_min,const,M_const,H0,No);
throughput_BPSK_BCH = BER_treshold_BCH2(nb_corr_treshold_BPSK_BCH,throughput_treshold_BPSK_BCH,SNR_bit,N_symb,N,nb_iter_max,nb_err_min,const,M_const,H0,No);

%QPSK with coding
const = 'PSK';
M_const = 4;
N_symb= N*log2(M_const)*R;

nb_corr_treshold_QPSK_BCH = zeros(1,length(SNR_bit));
throughput_treshold_QPSK_BCH = zeros(1,length(SNR_bit));

throughput_QPSK_BCH=BER_treshold_BCH2(nb_corr_treshold_QPSK_BCH,throughput_treshold_QPSK_BCH,SNR_bit,N_symb,N,nb_iter_max,nb_err_min,const,M_const,H0,No);

%8-QAM with coding
const = 'QAM';
M_const = 8;
N_symb= N*log2(M_const)*R;

nb_corr_treshold_8QAM_BCH = zeros(1,length(SNR_bit));
throughput_treshold_8QAM_BCH = zeros(1,length(SNR_bit));

throughput_8QAM_BCH=BER_treshold_BCH2(nb_corr_treshold_8QAM_BCH,throughput_treshold_8QAM_BCH,SNR_bit,N_symb,N,nb_iter_max,nb_err_min,const,M_const,H0,No);

%16-QAM with and without coding
const = 'QAM';
M_const = 16;
N_symb= N*log2(M_const)*R;

nb_corr_treshold_16QAM = zeros(1,length(SNR_bit));
throughput_treshold_16QAM = zeros(1,length(SNR_bit));

nb_corr_treshold_16QAM_BCH = zeros(1,length(SNR_bit));
throughput_treshold_16QAM_BCH = zeros(1,length(SNR_bit));

throughput_16QAM=BER_treshold(nb_corr_treshold_16QAM,throughput_treshold_16QAM,SNR_bit,N_symb,N,nb_iter_max,nb_err_min,const,M_const,H0,No);
throughput_16QAM_BCH=BER_treshold_BCH2(nb_corr_treshold_16QAM_BCH,throughput_treshold_16QAM_BCH,SNR_bit,N_symb,N,nb_iter_max,nb_err_min,const,M_const,H0,No);

figure(1)
plot(SNR_bit,throughput_BPSK)
grid on
hold on
plot(SNR_bit,throughput_BPSK_BCH)
hold on
plot(SNR_bit,throughput_QPSK_BCH)
hold on
plot(SNR_bit,throughput_8QAM_BCH)
hold on
plot(SNR_bit,throughput_16QAM)
hold on
plot(SNR_bit,throughput_16QAM_BCH)
hold off
grid on
xlabel('Es/No (in dB)')
ylabel('Throughput')
title('Throughput with respect to Es/No for different MCS on an AWGN channel')
legend('BPSK','BPSK+BCH','QPSK+BCH','8-QAM+BCH','16-QAM','16-QAM+BCH')
line_hdl=get(gca,'children');
set(line_hdl,{'marker'},{'o';'+';'*';'.';'s';'d'});
set(line_hdl,{'color'},{'#0072BD';'#D95319';'#EDB120';'#7E2F8E';'#77AC30';'#4DBEEE'});
set(line_hdl,'linewidth',2);
set(gca,'fontsize',15);
set(get(gca,'title'),'fontsize',15);
set(get(gca,'xlabel'),'fontsize',15);
set(get(gca,'ylabel'),'fontsize',15);


%{
BER_treshold_1 = zeros(1,length(SNR_bit));
BER_tresholdBCH1_1 = zeros(1,length(SNR_bit));
BER_tresholdBCH2_1 = zeros(1,length(SNR_bit));

nb_err_treshold_1 = zeros(1,length(SNR_bit)); 
nb_err_tresholdBCH1_1 = zeros(1,length(SNR_bit)); 
nb_err_tresholdBCH2_1 = zeros(1,length(SNR_bit));

% calcul du BER   
%Threshold for H1
BER_treshold_1=BER_treshold(nb_err_treshold_1,BER_treshold_1,SNR_bit,N_symb,N,nb_iter_max,nb_err_min,const,M_const,H1_toeplitz,No);
BER_tresholdBCH1_1=BER_treshold_BCH1(nb_err_tresholdBCH1_1,BER_tresholdBCH1_1,SNR_bit,N_symb,N,nb_iter_max,nb_err_min,const,M_const,H1_toeplitz,No);
BER_tresholdBCH2_1=BER_treshold_BCH2(nb_err_tresholdBCH2_1,BER_tresholdBCH2_1,SNR_bit,N_symb,N,nb_iter_max,nb_err_min,const,M_const,H1_toeplitz,No);


figure(1)
semilogy(SNR_bit,BER_treshold_1)
grid on
hold on
semilogy(SNR_bit,BER_tresholdBCH1_1)
hold on
semilogy(SNR_bit,BER_tresholdBCH2_1)
hold off
xlabel('Eb/No (in dB)')
ylabel('BER')
title('BPSK and threshold detector for the channel h1')
legend('Uncoded','First BCH','Second BCH')
line_hdl=get(gca,'children');
set(line_hdl,{'marker'},{'s';'d';'p'});
set(line_hdl,{'color'},{[64,61,88]/256;[252,119,83]/256;[100,50,83]/256});
set(line_hdl,'linewidth',2);
set(gca,'fontsize',15);
set(get(gca,'title'),'fontsize',15);
set(get(gca,'xlabel'),'fontsize',15);
set(get(gca,'ylabel'),'fontsize',15);
%}
