%distances = [1.4, 14, 140, 1400, 14000, 140000];
distances = linspace(1.4, 1.4e4, 30)
BER = zeros(1,length(distances));

for ii=1:length(distances)
    BER(ii) = completeTxRx_BER(distances(ii))
end

figure(1)
semilogy(distances,BER)
grid on
xlabel('Distance (in m)')
ylabel('BER')
title('BER with respect to the distance Tx/Rx')
line_hdl=get(gca,'children');
set(line_hdl,'linewidth',2);
set(gca,'fontsize',15);
set(get(gca,'title'),'fontsize',15);
set(get(gca,'xlabel'),'fontsize',15);
set(get(gca,'ylabel'),'fontsize',15);