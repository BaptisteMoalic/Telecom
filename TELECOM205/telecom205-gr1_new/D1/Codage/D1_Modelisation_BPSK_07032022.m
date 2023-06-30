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

H0 = eye(31);


% BER vs SNR

% We start by generating the SNR in the x-axis
SNR_bit=[0:1:10];
R = 1;
scaling= R ; 
No = 1./(scaling*10.^(SNR_bit/10));
N = 31;                            % nombre de symboles a envoyer
const = 'PSK';
M_const = 2;
%N_bits= N*log2(M_const)*R;          % nombre de bits d'information
N_bits_1 = 26;
N_bits_2 = 21;

% Parametres algo de codage
nb_err_min = 200 ;
nb_iter_max = 200 ;

BER_treshold1 = zeros(1,length(SNR_bit));
BER_tresholdBCH1 = zeros(1,length(SNR_bit));
BER_tresholdBCH2 = zeros(1,length(SNR_bit));

nb_err_treshold1 = zeros(1,length(SNR_bit)); 
nb_err_tresholdBCH1 = zeros(1,length(SNR_bit)); 
nb_err_tresholdBCH2 = zeros(1,length(SNR_bit));


% calcul du BER   
BER_treshold1=BER_treshold(nb_err_treshold1,BER_treshold1,SNR_bit,N,N,nb_iter_max,nb_err_min,const,M_const,H0,No);
BER_tresholdBCH1=BER_treshold_BCH1(nb_err_tresholdBCH1,BER_tresholdBCH1,SNR_bit,N_bits_1,N,nb_iter_max,nb_err_min,const,M_const,H0,No);
BER_tresholdBCH2=BER_treshold_BCH2(nb_err_tresholdBCH2,BER_tresholdBCH2,SNR_bit,N_bits_2,N,nb_iter_max,nb_err_min,const,M_const,H0,No);


figure(1)
semilogy(SNR_bit,BER_treshold1)
grid on
hold on
semilogy(SNR_bit,BER_tresholdBCH1)
hold on
semilogy(SNR_bit,BER_tresholdBCH2)
hold off
xlabel('Eb/No (in dB)')
ylabel('BER')
title('BPSK for an AWGN channel')
legend('Uncoded','First BCH','Second BCH')
line_hdl=get(gca,'children');
set(line_hdl,{'marker'},{'s';'d';'p'});
%set(line_hdl,{'color'},{[64,61,88]/256;[252,119,83]/256;[100,50,83]/256});
set(line_hdl,{'color'},{'r';'g';'b'});
set(line_hdl,'linewidth',2);
set(gca,'fontsize',15);
set(get(gca,'title'),'fontsize',15);
set(get(gca,'xlabel'),'fontsize',15);
set(get(gca,'ylabel'),'fontsize',15);