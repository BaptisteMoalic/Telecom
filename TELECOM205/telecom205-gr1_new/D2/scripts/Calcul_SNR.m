function [SNR] = Calcul_SNR(Xpsd,Fs,bw_moitie)


N = length(Xpsd);                                %nombre de points 
[~, sig_bin] = max(Xpsd);                        %bin du signal utile

bin_bw_moitie = round(bw_moitie/Fs*N); %On ne raisonne plus en fmin et fmax, mais on prend la bw et on prend deux zones symétriques autour de sig_bin
bin_centre = floor(N/2);                    
bin_min0 = max(bin_centre-bin_bw_moitie, 1);
bin_max0 = min(bin_centre+bin_bw_moitie, floor(N));


nintsig = 10;                                        %nombre de point autour du bin utile à integrer
err_bin_min = [bin_min0 : sig_bin-nintsig];
err_bin_max = [sig_bin+nintsig : bin_max0];



PS = sum(Xpsd(sig_bin-nintsig:sig_bin+nintsig)); %calcul de la puissance du signal utile à + ou - 2 points de sig_bin 
PN = sum(Xpsd(err_bin_min))+sum(Xpsd(err_bin_max));  %calcul de la puissance du bruit



SNR = 10*log10(PS/PN);   %calcul du SNR

end

