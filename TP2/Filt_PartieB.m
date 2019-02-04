%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARTIE B : "SIMULATION DE LA VOIX HUMAINE"
%
%            CREATION DE SONS (VOYELLES) 
%            PAR FILTRAGE D'UN TRAIN D'IMPULSIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% close all
% clear

%%
%Paramètres de départ :
%----------------------
%On travaillera à une fréquence d'échantillonnage de 44,1 kHz
Fe=22050;

%Choix de fréquences (uniquement 2 harmoniques) pour chaque voyelles
% (ces fréquences peuvent être affinées)
fa = [800,1200];
fe = [600,1600];
fi = [400,3200];  
fo = [400,800];  
fu = [400,1800];  

%Fréquence fondamentale pour la voix d'un homme et pour la voix d'une femme
% (ces fréquences peuvent être affinées)
F_Homme = 125;
F_Femme = 210;


%%
%Choix des paramètres :
%----------------------
%quelle voyelle va-t-on prononcer ?
Fvoy = fa;    % à modifier selon la voyelle que nous voulons
%la voyelle sera prononcée par un homme ou par une femme ?
%F0=  F_Femme;  
F0 = F_Homme;  

%%
%Création de l'excitation sur N points :
%---------------------------------------
% c'est une suite d'impulsions espacées de T0 = 1/F0
N = 10000;           %nombre d'échantillons total
entree = zeros(1,N); %on initialise l'excitation à zéro

N0=ceil(Fe/F0);   %on a une impulsion tous les N0 échantillons tel que N0*Te = T0
entree(1:N0:N) = 1;


%%
%Calcul des coefficients du filtre et filtrage
%----------------------------------------------
r1 = 0.99;
r2 = 0.99;
theta1 = 2*pi*Fvoy(1)/Fe;
theta2 = 2*pi*Fvoy(2)/Fe;

C = poly([r1*exp(j*theta1) r1*exp(-j*theta1) r2*exp(j*theta2) r2*exp(-j*theta2)]);

figure(1)    %observation du comportement du filtre
subplot(211), freqz(1,C)
subplot(212), zplane(1,C)

sortie = filter(1,C,entree);   %filtrage

%%
%Tracé du signal
%---------------
t = [0:N-1]/Fe;
Naff = 500;
f = [0:N-1]*Fe/N; f = f-Fe/2;
figure(2)
subplot(311), plot(t(1:Naff),sortie(1:Naff)),grid
subplot(312), plot(f,fftshift(abs((1/N)*fft(sortie)))),grid
subplot(313), spectrogram(sortie,128,120,128,Fe,'yaxis')

%%
%Ecoute du résultat
%------------------
soundsc(sortie,Fe);


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Conclusion :
% les sons restent "synthétiques".
% Un modèle plus élaboré permettrait d'avoir des sons plus "naturels".
% A vous de proposer des solutions en vous aidant de la bibliographie
% (fournie ou obtenue par vous même)...
% Pistes : 
% - plus d'harmoniques pour chaque voyelle (utilisation de 3 "formants" au lieu de 2), 
% - affiner éventuellement F0
% - application d'une enveloppe pour que le début et la fin du son ne soient pas "brutaux"...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

