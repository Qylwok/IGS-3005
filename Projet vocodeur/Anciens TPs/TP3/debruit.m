function [S_est] = debruit4(x,b,Fe);

N = length(x);

% Calcul de DSP
 Sxx = cal_dsp(x,Fe);
 Sbb = cal_dsp(b,Fe);

%Calcul du filtre (en fréquence)
 H = 1 - (Sbb./Sxx);

%Filtrage dans le domaine fréquentiel
 X = fft(x);
 Y = (H.*X);


 
 
%Récupération du signal filtré dans le domaine temporel
 y = real(ifft(Y,N));

S_est = y;

