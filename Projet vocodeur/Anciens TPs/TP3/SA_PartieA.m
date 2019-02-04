%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARTIE A
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARTIE A1
% ETUDE DE LA STATIONNARITE ET DE L'ERGODISME
%----------------------------------------------------------

N=500;     % nombre de points par r�alisations
K=200;     % nombre total de r�alisations 

%----------------------------------------------------------
% SINUSOIDE + BRUIT
% cr�ation d'un bruit avec K r�alisations, chacune sur N valeurs 
b = randn(K,N);
% cr�ation de K sinuso�des, chacune sur N points
S = ones(K,1)*sin(2*pi*[1:N]/N);
% signal + bruit�
X = S + b;

%----------------------------------------------------------
% AFFICHAGE PAR LA FONCTION "plot-rea"
M=4; % Nombre de r�alisations affich�es
% ce sont les r�alisations dont les indices sont contenues 
% dans le vecteur v
k=[1:M+1]; % (ici les M premi�res), 
%ou tout autre vecteur de taille M
plot_rea(X,k,1)

%----------------------------------------------------------
% PARTIE A2
% ETUDE DE BRUITS ET TRACE D'HISTOGRAMME
%----------------------------------------------------------

% BRUITS SUR N POINTS
N=10000;

X1 = randn(1,N);
plot_sighisto(X1,30,2)

X2 = rand(1,N);
X2=X2-mean(X2);
plot_sighisto(X2,30,3)


% COMPARAISON DES AUTO-CORRELATIONS
[Rxx1,tau1] = xcorr(X1,N/2,'unbiased');
[Rxx2,tau2] = xcorr(X2,N/2,'unbiased');

figure(4),
subplot(2,1,1),plot(tau1,Rxx1),grid
title('Auto-corr�lations')
subplot(2,1,2),plot(tau2,Rxx2),grid
