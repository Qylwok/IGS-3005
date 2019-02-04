
%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % PARTIE B1 : ETUDE D'UN SIGNAL DE PAROLE BRUITE
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% % R�cup�ration et manipulation du signal original
% %------------------------------------------------
[s,Fe] = audioread('Diner.wav');
%[s,Fe] = audioread('PereNoel.wav');

s=s-mean(s);                    %juste pour centrer le signal en z�ro
s = s(:,1)/abs(max(s(:,1)));    %juste pour avoir un signal qui varie entre -1 et +1
N = length(s);

% Calcul de la puissance moyenne du signal : Pmoy = Rss(0) = max(Rss(k))
[Rss,trs] = xcorr(s);   %autocorr�lation du signal
Rss = Rss/N;            %normalisation car Rxx(k) = lim (1/N).somme(x(n).x(n-k))
Ps = max(Rss);          %puissance moyenne du signal


% Cr�ation d'un bruit blanc Gaussien 
% pour avoir un RSB donn�
%------------------------------------------------
RSB = 10;                        %choix du RSB (en dB)
sigma = sqrt(Ps/(10^(RSB/10)));  %calcul de l'�cart type du bruit en fonction du RSB et de la puissance du signal
noise = sigma*randn(size(s));    %cr�ation du BBG centr� de m�me dimension que le signal


% Cr�ation du signal bruit�
%------------------------------------------------
s_noisy = s + noise;

%%
% Observation des signaux
%------------------------------------------------
% Dans le domaine temporel
 t = [0:N-1]/Fe;
 
figure(1)
subplot(411),plot(t,s),grid, xlabel('Signal original')
title('Signaux temporels')

subplot(412),plot(t,noise),grid, xlabel('Bruit')
subplot(413),plot(t,s_noisy),grid, xlabel('Signal bruit�')

% Les spectrogrammes
figure(2)
subplot(411),spectrogram(s,128,120,128,Fe,'yaxis');
title('Spectrogrammes')
subplot(412),spectrogram(noise,128,120,128,Fe,'yaxis');
subplot(413),spectrogram(s_noisy,128,120,128,Fe,'yaxis');

% Les fonctions de corr�lation
% (calcul par la fonction Matlab xcorr)
[Rbb,trb] = xcorr(noise);  
Rbb = Rbb/N;
[Rsb,trsb] = xcorr(s_noisy); 
Rsb = Rsb/N;

figure(3)
subplot(411),plot(trs,Rss),grid
title('Autocorr�lations')
subplot(412),plot(trb,Rbb),grid
subplot(413),plot(trsb,Rsb),grid

% Les densit�s spectrales de puissance
% (calcul des DSP par la fonction Matlab CPSD)
[Sss,fs] = cpsd(s,s,[],[],[],Fe,'twosided');
[Sbb,fs] = cpsd(noise,noise,[],[],[],Fe,'twosided');
[Ssb,fs] = cpsd(s_noisy,s_noisy,[],[],[],Fe,'twosided');

figure(4)
subplot(411),plot(fs-Fe/2,fftshift(Sss)),grid
title('Densit�s Spectrales de Puissance')
subplot(412),plot(fs-Fe/2,fftshift(Sbb)),grid
subplot(413),plot(fs-Fe/2,fftshift(Ssb)),grid

%%
%REMARQUE : Quelques v�rifications "th�oriques"
%------------------------------------------------

% A-t-on bien puissance du bruit Pb = max(Rbb) = sigma� = variance
Pb = max(Rbb)
Var_b = sigma^2

% On r�cup�re bien le RSB que l'on avait choisi ?
RSB2 = 10*log10(Ps/Pb)

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PATIE B2 : DE-BRUITAGE : filtre de Wiener
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% D�coupage en trames de ~30 ms pour traiter des portions "stationnaires" du signal. 
% Xt sera une matrice dont le nombre de ligne (Ne) correspondra au nombre
% d'�chantillons dans chaque trame (--> Ne*Te = 30 ms)) et le nombre de
% colonnes correspondra au nombre de trames obtenues --> 1 trame par
% colonne
dt = 30e-3;
Xt = Trames(s_noisy,dt,Fe);

%Application du d�bruitage � chaque trame
[Ne,Nt] = size(Xt);
s_trame = zeros(size(Xt));

for ind_t = 1:Nt
s_trame(:,ind_t) = debruit(Xt(:,ind_t),noise((ind_t-1)*Ne+1:ind_t*Ne),Fe);
end

%Concat�nation des trames pour former le signal estim� complet :
%s_est = [s_trame(:,1) ; s_trame(:,2) ; s_trame(:,3)...]
s_est = s_trame(:).';

%%
%Trac� des courbes
[Rsest,test] = xcorr(s_est); 
Rsest = Rsest/length(s_est);
[Ssest,fs] = cpsd(s_est,s_est,[],[],[],Fe,'twosided');

t = [0:length(s_est)-1]/Fe;

figure(1),
subplot(414),plot(t,s_est),grid, xlabel('Signal d�bruit�')
figure(2)
subplot(414),spectrogram(s_est,128,120,128,Fe,'yaxis');
figure(3)
subplot(414),plot(test,Rsest),grid
figure(4)
subplot(414),plot(fs-Fe/2,fftshift(Ssest)),grid




% %%
% %Ecoute
% soundsc(s,Fe)
% pause
% soundsc(s_noisy,Fe)
% pause
% soundsc(s_est,Fe)
% %%
% 
% 
% 
% 

















