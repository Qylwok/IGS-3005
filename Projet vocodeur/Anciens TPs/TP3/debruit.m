function [S_est] = debruit4(x,b,Fe);

N = length(x);

% Calcul de DSP
 Sxx = cal_dsp(x,Fe);
 Sbb = cal_dsp(b,Fe);

%Calcul du filtre (en fr�quence)
 H = 1 - (Sbb./Sxx);

%Filtrage dans le domaine fr�quentiel
 X = fft(x);
 Y = (H.*X);


 
 
%R�cup�ration du signal filtr� dans le domaine temporel
 y = real(ifft(Y,N));

S_est = y;

