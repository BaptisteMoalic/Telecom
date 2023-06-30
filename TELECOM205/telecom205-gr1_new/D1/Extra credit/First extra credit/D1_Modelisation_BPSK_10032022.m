Ts = 0.05e-6;
M = 4;
L = 4;
n = 2*L+1;
r = 0.5;

% Channel 0 (AWGN)
A0 = [1];
tau0 = [0];

% Channel 1
A1 = [1, 0.1, 0.1, 0.1, 0.1];
tau1 = [0, 0.5, 1, 1.5, 2]*Ts;

% Channel 2
A2 = [1, 0.8, 0.6, 0.4, 0.2];
tau2 = [0, 0.5, 1, 1.5, 2]*Ts;

% Channel 3
A3 = [1, 0.8, 0.8, 0.8, 0.8];
tau3 = [0, 0.5, 1, 1.5, 2]*Ts;

% initialization of the h channels
h1 = zeros(1,n);
h2 = zeros(1,n);
h3 = zeros(1,n);

% we are building the h vectors
for ii=1:n
  for jj=1:M+1
    h1(ii)=h1(ii)+A1(jj)*nyquist((ii-(L+1))*Ts-tau1(jj),Ts,r);
    h2(ii)=h2(ii)+A2(jj)*nyquist((ii-(L+1))*Ts-tau2(jj),Ts,r);
    h3(ii)=h3(ii)+A3(jj)*nyquist((ii-(L+1))*Ts-tau3(jj),Ts,r);
  end
end

% normalization
h1 = h1/norm(h1);
h2 = h2/norm(h2);
h3 = h3/norm(h3);


% BER vs SNR

% We start by generating the SNR in the x-axis
SNR_bit=[0:2:20];
R = 1;
scaling= R ; 
No = 1./(scaling*10.^(SNR_bit/10));
N = 100;   %100      plutot que 31                   % nombre de symboles a envoyer
const = 'PSK';
M_const = 2;
N_symb= N*log2(M_const)*R;          % nombre de bits d'information
%N_bits_1 = 26;
%N_bits_2 = 21;

H0 = eye(N);

% Parametres algo de codage
nb_err_min = 800 ;
nb_iter_max = 800 ;

BER_treshold_1 = zeros(1,length(SNR_bit));
BER_tresholdBCH1_1 = zeros(1,length(SNR_bit));
BER_tresholdBCH2_1 = zeros(1,length(SNR_bit));

nb_err_treshold_1 = zeros(1,length(SNR_bit)); 
nb_err_tresholdBCH1_1 = zeros(1,length(SNR_bit)); 
nb_err_tresholdBCH2_1 = zeros(1,length(SNR_bit));

BER_treshold_2 = zeros(1,length(SNR_bit));
BER_tresholdBCH1_2 = zeros(1,length(SNR_bit));
BER_tresholdBCH2_2 = zeros(1,length(SNR_bit));

nb_err_treshold_2 = zeros(1,length(SNR_bit)); 
nb_err_tresholdBCH1_2 = zeros(1,length(SNR_bit)); 
nb_err_tresholdBCH2_2 = zeros(1,length(SNR_bit));

BER_treshold_3 = zeros(1,length(SNR_bit));
BER_tresholdBCH1_3 = zeros(1,length(SNR_bit));
BER_tresholdBCH2_3 = zeros(1,length(SNR_bit));

nb_err_treshold_3 = zeros(1,length(SNR_bit)); 
nb_err_tresholdBCH1_3 = zeros(1,length(SNR_bit)); 
nb_err_tresholdBCH2_3 = zeros(1,length(SNR_bit));

BER_ZF_1 = zeros(1,length(SNR_bit));
BER_ZFBCH1_1 = zeros(1,length(SNR_bit));
BER_ZFBCH2_1 = zeros(1,length(SNR_bit));

nb_err_ZF_1 = zeros(1,length(SNR_bit));
nb_err_ZFBCH1_1 = zeros(1,length(SNR_bit));
nb_err_ZFBCH2_1 = zeros(1,length(SNR_bit));

BER_ZF_2 = zeros(1,length(SNR_bit));
BER_ZFBCH1_2 = zeros(1,length(SNR_bit));
BER_ZFBCH2_2 = zeros(1,length(SNR_bit));

nb_err_ZF_2 = zeros(1,length(SNR_bit));
nb_err_ZFBCH1_2 = zeros(1,length(SNR_bit));
nb_err_ZFBCH2_2 = zeros(1,length(SNR_bit));

BER_ZF_3 = zeros(1,length(SNR_bit));
BER_ZFBCH1_3 = zeros(1,length(SNR_bit));
BER_ZFBCH2_3 = zeros(1,length(SNR_bit));

nb_err_ZF_3 = zeros(1,length(SNR_bit));
nb_err_ZFBCH1_3 = zeros(1,length(SNR_bit));
nb_err_ZFBCH2_3 = zeros(1,length(SNR_bit));

BER_DFE_1 = zeros(1,length(SNR_bit));
BER_DFEBCH1_1 = zeros(1,length(SNR_bit));
BER_DFEBCH2_1 = zeros(1,length(SNR_bit));

nb_err_DFE_1 = zeros(1,length(SNR_bit));
nb_err_DFEBCH1_1 = zeros(1,length(SNR_bit));
nb_err_DFEBCH2_1 = zeros(1,length(SNR_bit));

BER_DFE_2 = zeros(1,length(SNR_bit));
BER_DFEBCH1_2 = zeros(1,length(SNR_bit));
BER_DFEBCH2_2 = zeros(1,length(SNR_bit));

nb_err_DFE_2 = zeros(1,length(SNR_bit));
nb_err_DFEBCH1_2 = zeros(1,length(SNR_bit));
nb_err_DFEBCH2_2 = zeros(1,length(SNR_bit));

BER_DFE_3 = zeros(1,length(SNR_bit));
BER_DFEBCH1_3 = zeros(1,length(SNR_bit));
BER_DFEBCH2_3 = zeros(1,length(SNR_bit));

nb_err_DFE_3 = zeros(1,length(SNR_bit));
nb_err_DFEBCH1_3 = zeros(1,length(SNR_bit));
nb_err_DFEBCH2_3 = zeros(1,length(SNR_bit));

% Building the first line of the H toeplitz matrix
first_line_h1 = zeros(1,N);
first_line_h2 = zeros(1,N);
first_line_h3 = zeros(1,N);

for kk = 1:L+1
  first_line_h1(kk)=h1(kk+L);
  first_line_h2(kk)=h2(kk+L);
  first_line_h3(kk)=h3(kk+L);
end

% Building the first column of the H toeplitz matrix
first_column_h1 = zeros(1,N);
first_column_h2 = zeros(1,N);
first_column_h3 = zeros(1,N);

h1_inv = flip(h1);
h2_inv = flip(h2);
h3_inv = flip(h3);

for kk = 1:L+1
  first_column_h1(kk)=h1_inv(kk+L);
  first_column_h2(kk)=h2_inv(kk+L);
  first_column_h3(kk)=h3_inv(kk+L);
end

% Construction of the H's toeplitz matrixes
H1_toeplitz = toeplitz(first_column_h1, first_line_h1);
H2_toeplitz = toeplitz(first_column_h2, first_line_h2);
H3_toeplitz = toeplitz(first_column_h3, first_line_h3);


% calcul du BER   
%Threshold for H1
%{
BER_treshold_1=BER_treshold(nb_err_treshold_1,BER_treshold_1,SNR_bit,N_symb,N,nb_iter_max,nb_err_min,const,M_const,H1_toeplitz,No);
BER_tresholdBCH1_1=BER_treshold_BCH1(nb_err_tresholdBCH1_1,BER_tresholdBCH1_1,SNR_bit,N_symb,N,nb_iter_max,nb_err_min,const,M_const,H1_toeplitz,No);
BER_tresholdBCH2_1=BER_treshold_BCH2(nb_err_tresholdBCH2_1,BER_tresholdBCH2_1,SNR_bit,N_symb,N,nb_iter_max,nb_err_min,const,M_const,H1_toeplitz,No);
%}
%Threshold for H2
BER_treshold_2=BER_treshold(nb_err_treshold_2,BER_treshold_2,SNR_bit,N,N,nb_iter_max,nb_err_min,const,M_const,H2_toeplitz,No);
BER_tresholdBCH1_2=BER_treshold_BCH1(nb_err_tresholdBCH1_2,BER_tresholdBCH1_2,SNR_bit,N_symb,N,nb_iter_max,nb_err_min,const,M_const,H2_toeplitz,No);
BER_tresholdBCH2_2=BER_treshold_BCH2(nb_err_tresholdBCH2_2,BER_tresholdBCH2_2,SNR_bit,N_symb,N,nb_iter_max,nb_err_min,const,M_const,H2_toeplitz,No);
%{
%Threshold for H3
BER_treshold_3=BER_treshold(nb_err_treshold_3,BER_treshold_3,SNR_bit,N,N,nb_iter_max,nb_err_min,const,M_const,H3_toeplitz,No);
BER_tresholdBCH1_3=BER_treshold_BCH1(nb_err_tresholdBCH1_3,BER_tresholdBCH1_3,SNR_bit,N_symb,N,nb_iter_max,nb_err_min,const,M_const,H3_toeplitz,No);
BER_tresholdBCH2_3=BER_treshold_BCH2(nb_err_tresholdBCH2_3,BER_tresholdBCH2_3,SNR_bit,N_symb,N,nb_iter_max,nb_err_min,const,M_const,H3_toeplitz,No);

%ZF for H1
BER_ZF_1=BER_ZF(nb_err_ZF_1,BER_ZF_1,SNR_bit,N,N,nb_iter_max,nb_err_min,const,M_const,H1_toeplitz,No);
BER_ZFBCH1_1=BER_ZF_BCH1(nb_err_ZFBCH1_1,BER_ZFBCH1_1,SNR_bit,N_symb,N,nb_iter_max,nb_err_min,const,M_const,H1_toeplitz,No);
BER_ZFBCH2_1=BER_ZF_BCH2(nb_err_ZFBCH2_1,BER_ZFBCH2_1,SNR_bit,N_symb,N,nb_iter_max,nb_err_min,const,M_const,H1_toeplitz,No);

%ZF for H2
BER_ZF_2=BER_ZF(nb_err_ZF_2,BER_ZF_2,SNR_bit,N,N,nb_iter_max,nb_err_min,const,M_const,H2_toeplitz,No);
BER_ZFBCH1_2=BER_ZF_BCH1(nb_err_ZFBCH1_2,BER_ZFBCH1_2,SNR_bit,N_symb,N,nb_iter_max,nb_err_min,const,M_const,H2_toeplitz,No);
BER_ZFBCH2_2=BER_ZF_BCH2(nb_err_ZFBCH2_2,BER_ZFBCH2_2,SNR_bit,N_symb,N,nb_iter_max,nb_err_min,const,M_const,H2_toeplitz,No);

%ZF for H3
BER_ZF_3=BER_ZF(nb_err_ZF_3,BER_ZF_3,SNR_bit,N,N,nb_iter_max,nb_err_min,const,M_const,H3_toeplitz,No);
BER_ZFBCH1_3=BER_ZF_BCH1(nb_err_ZFBCH1_3,BER_ZFBCH1_3,SNR_bit,N_symb,N,nb_iter_max,nb_err_min,const,M_const,H3_toeplitz,No);
BER_ZFBCH2_3=BER_ZF_BCH2(nb_err_ZFBCH2_3,BER_ZFBCH2_3,SNR_bit,N_symb,N,nb_iter_max,nb_err_min,const,M_const,H3_toeplitz,No);
%}
%DFE for H1
BER_DFE_1=BER_DFE(nb_err_DFE_1,BER_DFE_1,SNR_bit,N,N,nb_iter_max,nb_err_min,const,M_const,H1_toeplitz,No);
BER_DFEBCH1_1=BER_DFE_BCH1(nb_err_DFEBCH1_1,BER_DFEBCH1_1,SNR_bit,N_symb,N,nb_iter_max,nb_err_min,const,M_const,H1_toeplitz,No);
BER_DFEBCH2_1=BER_DFE_BCH2(nb_err_DFEBCH2_1,BER_DFEBCH2_1,SNR_bit,N_symb,N,nb_iter_max,nb_err_min,const,M_const,H1_toeplitz,No);
%{
%DFE for H2
BER_DFE_2=BER_DFE(nb_err_DFE_2,BER_DFE_2,SNR_bit,N,N,nb_iter_max,nb_err_min,const,M_const,H2_toeplitz,No);
BER_DFEBCH1_2=BER_DFE_BCH1(nb_err_DFEBCH1_2,BER_DFEBCH1_2,SNR_bit,N_symb,N,nb_iter_max,nb_err_min,const,M_const,H2_toeplitz,No);
BER_DFEBCH2_2=BER_DFE_BCH2(nb_err_DFEBCH2_2,BER_DFEBCH2_2,SNR_bit,N_symb,N,nb_iter_max,nb_err_min,const,M_const,H2_toeplitz,No);

%DFE for H3
BER_DFE_3=BER_DFE(nb_err_DFE_3,BER_DFE_3,SNR_bit,N,N,nb_iter_max,nb_err_min,const,M_const,H3_toeplitz,No);
BER_DFEBCH1_3=BER_DFE_BCH1(nb_err_DFEBCH1_3,BER_DFEBCH1_3,SNR_bit,N_symb,N,nb_iter_max,nb_err_min,const,M_const,H3_toeplitz,No);
BER_DFEBCH2_3=BER_DFE_BCH2(nb_err_DFEBCH2_3,BER_DFEBCH2_3,SNR_bit,N_symb,N,nb_iter_max,nb_err_min,const,M_const,H3_toeplitz,No);


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

figure(2)
semilogy(SNR_bit,BER_ZF_1)
grid on
hold on
semilogy(SNR_bit,BER_ZFBCH1_1)
hold on
semilogy(SNR_bit,BER_ZFBCH2_1)
hold off
xlabel('Eb/No (in dB)')
ylabel('BER')
title('BPSK with a ZF equalizer for the channel h1')
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
figure(3)
semilogy(SNR_bit,BER_DFE_1)
grid on
hold on
semilogy(SNR_bit,BER_DFEBCH1_1)
hold on
semilogy(SNR_bit,BER_DFEBCH2_1)
hold off
xlabel('Eb/No (in dB)')
ylabel('BER')
title('BPSK with a DFE equalizer for the channel h1')
legend('Uncoded','First BCH','Second BCH')
line_hdl=get(gca,'children');
set(line_hdl,{'marker'},{'s';'d';'p'});
set(line_hdl,{'color'},{[64,61,88]/256;[252,119,83]/256;[100,50,83]/256});
set(line_hdl,'linewidth',2);
set(gca,'fontsize',15);
set(get(gca,'title'),'fontsize',15);
set(get(gca,'xlabel'),'fontsize',15);
set(get(gca,'ylabel'),'fontsize',15);

figure(4)
semilogy(SNR_bit,BER_treshold_2)
grid on
hold on
semilogy(SNR_bit,BER_tresholdBCH1_2)
hold on
semilogy(SNR_bit,BER_tresholdBCH2_2)
hold off
xlabel('Eb/No (in dB)')
ylabel('BER')
title('BPSK and threshold detector for the channel h2')
legend('Uncoded','First BCH','Second BCH')
line_hdl=get(gca,'children');
set(line_hdl,{'marker'},{'s';'d';'p'});
set(line_hdl,{'color'},{[64,61,88]/256;[252,119,83]/256;[100,50,83]/256});
set(line_hdl,'linewidth',2);
set(gca,'fontsize',15);
set(get(gca,'title'),'fontsize',15);
set(get(gca,'xlabel'),'fontsize',15);
set(get(gca,'ylabel'),'fontsize',15);
%{
figure(5)
semilogy(SNR_bit,BER_ZF_2)
grid on
hold on
semilogy(SNR_bit,BER_ZFBCH1_2)
hold on
semilogy(SNR_bit,BER_ZFBCH2_2)
hold off
xlabel('Eb/No (in dB)')
ylabel('BER')
title('BPSK with a ZF equalizer for the channel h2')
legend('Uncoded','First BCH','Second BCH')
line_hdl=get(gca,'children');
set(line_hdl,{'marker'},{'s';'d';'p'});
set(line_hdl,{'color'},{[64,61,88]/256;[252,119,83]/256;[100,50,83]/256});
set(line_hdl,'linewidth',2);
set(gca,'fontsize',15);
set(get(gca,'title'),'fontsize',15);
set(get(gca,'xlabel'),'fontsize',15);
set(get(gca,'ylabel'),'fontsize',15);

figure(6)
semilogy(SNR_bit,BER_DFE_2)
grid on
hold on
semilogy(SNR_bit,BER_DFEBCH1_2)
hold on
semilogy(SNR_bit,BER_DFEBCH2_2)
hold off
xlabel('Eb/No (in dB)')
ylabel('BER')
title('BPSK with a DFE equalizer for the channel h2')
legend('Uncoded','First BCH','Second BCH')
line_hdl=get(gca,'children');
set(line_hdl,{'marker'},{'s';'d';'p'});
set(line_hdl,{'color'},{[64,61,88]/256;[252,119,83]/256;[100,50,83]/256});
set(line_hdl,'linewidth',2);
set(gca,'fontsize',15);
set(get(gca,'title'),'fontsize',15);
set(get(gca,'xlabel'),'fontsize',15);
set(get(gca,'ylabel'),'fontsize',15);

figure(7)
semilogy(SNR_bit,BER_treshold_3)
grid on
hold on
semilogy(SNR_bit,BER_tresholdBCH1_3)
hold on
semilogy(SNR_bit,BER_tresholdBCH2_3)
hold off
xlabel('Eb/No (in dB)')
ylabel('BER')
title('BPSK and threshold detector for the channel h3')
legend('Uncoded','First BCH','Second BCH')
line_hdl=get(gca,'children');
set(line_hdl,{'marker'},{'s';'d';'p'});
set(line_hdl,{'color'},{[64,61,88]/256;[252,119,83]/256;[100,50,83]/256});
set(line_hdl,'linewidth',2);
set(gca,'fontsize',15);
set(get(gca,'title'),'fontsize',15);
set(get(gca,'xlabel'),'fontsize',15);
set(get(gca,'ylabel'),'fontsize',15);

figure(8)
semilogy(SNR_bit,BER_ZF_3)
grid on
hold on
semilogy(SNR_bit,BER_ZFBCH1_3)
hold on
semilogy(SNR_bit,BER_ZFBCH2_3)
hold off
xlabel('Eb/No (in dB)')
ylabel('BER')
title('BPSK with a ZF equalizer for the channel h3')
legend('Uncoded','First BCH','Second BCH')
line_hdl=get(gca,'children');
set(line_hdl,{'marker'},{'s';'d';'p'});
set(line_hdl,{'color'},{[64,61,88]/256;[252,119,83]/256;[100,50,83]/256});
set(line_hdl,'linewidth',2);
set(gca,'fontsize',15);
set(get(gca,'title'),'fontsize',15);
set(get(gca,'xlabel'),'fontsize',15);
set(get(gca,'ylabel'),'fontsize',15);

figure(9)
semilogy(SNR_bit,BER_DFE_3)
grid on
hold on
semilogy(SNR_bit,BER_DFEBCH1_3)
hold on
semilogy(SNR_bit,BER_DFEBCH2_3)
hold off
xlabel('Eb/No (in dB)')
ylabel('BER')
title('BPSK with a DFE equalizer for the channel h3')
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
