% Amplitude Attenuation in free space
carrierFreq1        = 2e9; 
carrierFreq2        = 2.8e9; 
c                  = 3e8; % speed of light in vacuum
distances = linspace(1.4, 1.4e4, 30);
ChannelAttenuation2k = 20*log10((c/carrierFreq1./(4*pi*distances)));
ChannelAttenuation2k8 = 20*log10((c/carrierFreq2./(4*pi*distances)));

figure(1)
semilogx(distances,ChannelAttenuation2k)
hold on
semilogx(distances,ChannelAttenuation2k8)
grid on
xlabel('Distance (in m)')
ylabel('Attenuation (in dB)')
title('Attenuation with respect to distance (for two different frequencies)')
line_hdl=get(gca,'children');
legend('Fc = 2e9 Hz','Fc = 2.8e9 Hz')
set(line_hdl,'linewidth',2);
set(gca,'fontsize',15);
set(get(gca,'title'),'fontsize',15);
set(get(gca,'xlabel'),'fontsize',15);
set(get(gca,'ylabel'),'fontsize',15);