function [ACPR_high, ACPR_low, Pow_useful_band] = ACPR_PA(PA_out, Flo, Rin, continuousTimeSamplingRate)

%Parameters
N_Cont = length(PA_out);
window_number       = 1;
lineSpec_index      = 3;

spectrum = plot_spectrum(PA_out*sqrt(1e3/Rin),window_number,continuousTimeSamplingRate,lineSpec_index);


fin_or_minus15  = Flo-15e6; 
Bin_in_minus15  = round(fin_or_minus15/continuousTimeSamplingRate*N_Cont);

fin_or_minus45  = Flo-45e6; 
Bin_in_minus45  = round(fin_or_minus45/continuousTimeSamplingRate*N_Cont);

fin_or_plus45   = Flo+45e6; 
Bin_in_plus45   = round(fin_or_plus45/continuousTimeSamplingRate*N_Cont);

fin_or_plus15   = Flo+15e6; 
Bin_in_plus15   = round(fin_or_plus15/continuousTimeSamplingRate*N_Cont);

Pow_useful_band = sum(spectrum(Bin_in_minus15:Bin_in_plus15));
ACPR_low = Pow_useful_band/sum(spectrum(Bin_in_minus45:Bin_in_minus15));
ACPR_high = Pow_useful_band/sum(spectrum(Bin_in_plus15:Bin_in_plus45));
ACPR_low = 10*log10(ACPR_low);
ACPR_high = 10*log10(ACPR_high);
Pow_useful_band = 10*log10(Pow_useful_band);