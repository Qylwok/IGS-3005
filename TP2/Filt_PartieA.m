%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARTIE A : MODIFICATION DE SONS PAR FILTRAGE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
clear

%%
% R�cup�ration des 2 voies du son contenu dans le fichier ".wav", �coute et
% trac�s des courbes temporelle et fr�quentielle et spectrogramme 
% (fait dans le TP 1)
[son,Fe]=audioread('Extrait.wav');

%On travaillera en mono --> on r�cup�re 1 seule voie
x = son(:,1);  

N = length(son);
t = [0:N-1]/Fe;
f = [0:N-1]*Fe/N; f = f-Fe/2;
X = fftshift(abs((1/N)*fft(x)));

%Courbe temporelle
figure(1),
subplot(311)
title('Comparaison signaux temporels')
plot(t,x),grid
ylabel('Son original')

%Spectre
Nifreq = round(N/2); Nffreq =round((17000*N/Fe)+(N/2));
figure(2),
subplot(311)
title('Comparaison des spectres')
plot(f(Nifreq:Nffreq),X(Nifreq:Nffreq)),grid
ylabel('Voie 1')

%Spectrogramme
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ATTENTION : NE PAS PRENDRE TOUS LES POINTS SINON ON BLOQUERA MATLAB !!!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pour limiter le nombre de points d'observation, on d�finit l'indice
% initial (Nispec) et l'indice final (Nfspec)
Nispec = round(3*N/4);  Nfspec = N;   
figure(3)
subplot(311),spectrogram(x(Nispec:Nfspec),128,120,128,Fe,'yaxis')

% %Ecoute
% soundsc(x,Fe)
% pause
% %Remarque 1 :
% %si on veut �couter le signal en st�r�o, il suffit d'utiliser la
% %matrice � 2 colonne initiale
% soundsc(son,Fe)

%Remarque 2 :
% "pause" permet de faire une pause dans le programme (il n'execute pas les
% commandes qui suivent.
% pour qu'il continu, il suffit d'appuyer sur n'importe quelle touche du
% clavier. 
% Nous l'utilisons ici afin de ne pas lancer l'�coute du son st�r�o avant que le son
% mono ne soit termin� (sinon, on entend la superposition des 2).

%%
%------------
% FILTRAGE 
%------------

% 1- Suppression de la contre-basse
%-------------------------------
Fcb = 81.85;      % 81.85 arrondi

% Choix du module et de l'argument des racines
r = 1; % Car on veut avoir 0 ==> module = 1
theta = 2*pi*Fcb/Fe;

%Calcul des coefficients � partir des racines (les coefficients seront dans
%le vecteur C)
C = poly([r*exp(j*theta),r*exp(-j*theta)]);

%Coefficients du filtre :
% B : vecteur contenant les coefficients du num�rateur de H(z)
% A : vecteur contenant les coefficients du d�nominateur de H(z)
B = C;
A = 1;
figure(4),
subplot(211),freqz(B,A)   % trac� de la fonction de transfert en fr�quence du filtre
subplot(212),zplane(B,A)  % trac� des p�les et des z�ros dans le plan complexe

% Filtrage
y1 = filter(B,A,x); 
y1 = y1/max(y1);          %normalisation afin d'avoir toujours une amplitude comprise entre -1 et +1
Y1 = fftshift(abs((1/N)*fft(y1)));

%Trac� des courbes
figure(1),
subplot(312),plot(t,y1),grid
ylabel('suppression de la contrebasse')
figure(2)
subplot(312)
plot(f(Nifreq:Nffreq),Y1(Nifreq:Nffreq)),grid
ylabel('suppression de la contrebasse')
figure(3)
subplot(312)
spectrogram(y1(Nispec:Nfspec),128,120,128,Fe,'yaxis')
ylabel('suppression de la contrebasse')

% 2- R�haussement de la voix
%----------------------------
FNat = 329;
    

% Choix du module et de l'argument des racines
r = 0.9;
theta = 2*pi*FNat/Fe;

%Calcul des coefficients � partir des racines (les coefficients seront dans
%le vecteur C)
C = poly([r*exp(j*theta),r*exp(-j*theta)]);

%Coefficients du filtre :
% B : vecteur contenant les coefficients du num�rateur de H(z)
% A : vecteur contenant les coefficients du d�nominateur de H(z)
B = 1;
A = C;
figure(5),
subplot(211),freqz(B,A)   % trac� de la fonction de transfert en fr�quence du filtre
subplot(212),zplane(B,A)  % trac� des p�les et des z�ros dans le plan complexe

% Filtrage
y2 = filter(B,A,y1); 
y2 = y2/max(y2);          %normalisation afin d'avoir toujours une amplitude comprise entre -1 et +1
Y2 = fftshift(abs((1/N)*fft(y2)));

%Trac� des courbes
figure(1),
subplot(313),plot(t,y2),grid
ylabel('r�haussement de la voix')
figure(2)
subplot(313)
plot(f(Nifreq:Nffreq),Y2(Nifreq:Nffreq)),grid
ylabel('r�haussement de la voix')
figure(3)
subplot(313)
spectrogram(y2(Nispec:Nfspec),128,120,128,Fe,'yaxis')
ylabel('r�haussement de la voix')


% Ecoute des 3 sons l'un apr�s l'autre
pause
soundsc(x,Fe)    % son original
% pause
% soundsc(y1,Fe)   % son apr�s suppression de la contre basse
pause
soundsc(y2,Fe)   % son apr�s rehaussement de la voix (et des basses fr�quences "autour")


