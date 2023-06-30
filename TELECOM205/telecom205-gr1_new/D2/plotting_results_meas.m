close all
clear
%% Preparing the string arrays

dist_600 = [5.5, 10.4, 16.5, 23, 28.9, 34.9, 44];
distancelog_600 = 10*log10(dist_600);

dist_2500_ON = [0, 10.4, 23, 28.9, 34.9, 41, 44];
distancelog_2500_ON = 10*log10(dist_2500_ON);

dist_2500_OFF = [0, 5.5, 8.3, 10.4, 13.1, 16.5, 20, 23, 25.8, 32, 34.9, 38, 41, 44];
distancelog_2500_OFF = 10*log10(dist_2500_OFF);



%% Constants for the theorical SNR
lambda=3e8/2.4e9;   % The wavelength
alpha=-1.5;          % The path loss exponent =2 for the free space 
Pt=20;              % transmitted power in dBm 
ThermNoise=10*log10(1.38e-23*290*20e6)+30; % Therm Noise power in dBm at the receiver input KTB
NFreceiver=8; % Receiver NF in dB

%% 600MHz with VGA
fileName = 'f600_ON_';
fc = 600e6;
plot_600_ON = zeros(1,length(dist_600));

for k=1:length(dist_600)
    temp_fileName = strcat(fileName, num2str(dist_600(k)));
    temp_SNR = average_SNR(temp_fileName);
    plot_600_ON(k) = temp_SNR;
end

fittedcoef_600_ON=fitlm(distancelog_600,plot_600_ON);  %%% Linear fitting of the coefficient
fittedcurve_600_ON=fittedcoef_600_ON.Coefficients.Estimate(1)+10*fittedcoef_600_ON.Coefficients.Estimate(2)*log10(dist_600);

%% 600MHz without VGA
fileName = 'f600_OFF_';
fc = 600e6;
plot_600_OFF = zeros(1,length(dist_600));

for k=1:length(dist_600)
    temp_fileName = strcat(fileName, num2str(dist_600(k)));
    temp_SNR = average_SNR(temp_fileName);
    plot_600_OFF(k) = temp_SNR;
end

fittedcoef_600_OFF=fitlm(distancelog_600,plot_600_OFF);  %%% Linear fitting of the coefficient
fittedcurve_600_OFF=fittedcoef_600_OFF.Coefficients.Estimate(1)+10*fittedcoef_600_OFF.Coefficients.Estimate(2)*log10(dist_600);

%% 2,5GHz with VGA
fileName = 'f2500_ON_';
fc = 2500e6;
plot_2500_ON = zeros(1,length(dist_2500_ON));

for k=1:length(dist_2500_ON)
    temp_fileName = strcat(fileName, num2str(dist_2500_ON(k)));
    temp_SNR = average_SNR(temp_fileName);
    plot_2500_ON(k) = temp_SNR;
end

distancelog_2500_ON(1)=0;
fittedcoef_2500_ON=fitlm(distancelog_2500_ON,plot_2500_ON);  %%% Linear fitting of the coefficient
fittedcurve_2500_ON=fittedcoef_2500_ON.Coefficients.Estimate(1)+10*fittedcoef_2500_ON.Coefficients.Estimate(2)*log10(dist_2500_ON);

%% 2,5GHz without VGA
fileName = 'f2500_OFF_';
fc = 2500e6;
plot_2500_OFF = zeros(1,length(dist_2500_OFF));

for k=1:length(dist_2500_OFF)
    temp_fileName = strcat(fileName, num2str(dist_2500_OFF(k)));
    temp_SNR = average_SNR(temp_fileName);
    plot_2500_OFF(k) = temp_SNR;
end

distancelog_2500_OFF(1)=0;
fittedcoef_2500_OFF=fitlm(distancelog_2500_OFF,plot_2500_OFF);  %%% Linear fitting of the coefficient
fittedcurve_2500_OFF=fittedcoef_2500_OFF.Coefficients.Estimate(1)+10*fittedcoef_2500_OFF.Coefficients.Estimate(2)*log10(dist_2500_OFF);

%% Plotting
figure(1);
semilogx(dist_600, plot_600_ON);
hold on;
semilogx(dist_600, fittedcurve_600_ON);
title('600MHz with VGA ON');
xlabel('Distance (m)');
ylabel('SNR (dB)');
grid on;
line_hdl=get(gca,'children');
legend('SNR reel','SNR theorique')
set(line_hdl,{'marker'},{'s';'d'});
set(line_hdl,{'color'},{[64,61,88]/256;[252,119,83]/256});
set(line_hdl,'linewidth',2);
set(gca,'fontsize',15);
set(get(gca,'title'),'fontsize',15);
set(get(gca,'xlabel'),'fontsize',15);
set(get(gca,'ylabel'),'fontsize',15);

figure(2);
semilogx(dist_600, plot_600_OFF);
hold on;
semilogx(dist_600, fittedcurve_600_OFF);
title('600MHz with VGA OFF');
xlabel('Distance (m)');
ylabel('SNR (dB)');
grid on;
line_hdl=get(gca,'children');
legend('SNR reel','SNR theorique')
set(line_hdl,{'marker'},{'s';'d'});
set(line_hdl,{'color'},{[64,61,88]/256;[252,119,83]/256});
set(line_hdl,'linewidth',2);
set(gca,'fontsize',15);
set(get(gca,'title'),'fontsize',15);
set(get(gca,'xlabel'),'fontsize',15);
set(get(gca,'ylabel'),'fontsize',15);

figure(3);
semilogx(dist_2500_ON, plot_2500_ON);
hold on;
semilogx(dist_2500_ON, fittedcurve_2500_ON);
title('2,5GHz with VGA ON');
xlabel('Distance (m)');
ylabel('SNR (dB)');
grid on;
line_hdl=get(gca,'children');
legend('SNR reel','SNR theorique')
set(line_hdl,{'marker'},{'s';'d'});
set(line_hdl,{'color'},{[64,61,88]/256;[252,119,83]/256});
set(line_hdl,'linewidth',2);
set(gca,'fontsize',15);
set(get(gca,'title'),'fontsize',15);
set(get(gca,'xlabel'),'fontsize',15);
set(get(gca,'ylabel'),'fontsize',15);

figure(4);
semilogx(dist_2500_OFF, plot_2500_OFF);
hold on;
semilogx(dist_2500_OFF, fittedcurve_2500_OFF);
title('2,5GHz with VGA OFF');
xlabel('Distance (m)');
ylabel('SNR (dB)');
grid on;
line_hdl=get(gca,'children');
legend('SNR reel','SNR theorique')
set(line_hdl,{'marker'},{'s';'d'});
set(line_hdl,{'color'},{[64,61,88]/256;[252,119,83]/256});
set(line_hdl,'linewidth',2);
set(gca,'fontsize',15);
set(get(gca,'title'),'fontsize',15);
set(get(gca,'xlabel'),'fontsize',15);
set(get(gca,'ylabel'),'fontsize',15);

%% Auxiliary function (averaging)


function ave_SNR = average_SNR(fileName)
    SNR_1 = SNR_from_CSV(strcat(fileName,'m_1.csv'));
    SNR_2 = SNR_from_CSV(strcat(fileName,'m_2.csv'));
    SNR_3 = SNR_from_CSV(strcat(fileName,'m_3.csv'));
    ave_SNR = mean([SNR_1, SNR_2, SNR_3]);
end
