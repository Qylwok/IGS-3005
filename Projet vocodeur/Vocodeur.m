close all
clear
fprintf("\n\n\n\n\n\n\n\n\n\n\n\n");
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VOCODEUR : Programme principal réalisant un vocodeur de phase 
% et permettant de :
%
% 1- modifier le tempo (la vitesse de "prononciation")
%   sans modifier le pitch (fréquence fondamentale de la parole)
%
% 2- modifier le pitch 
%   sans modifier la vitesse 
%
% 3- "robotiser" une voix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Récupération d'un signal audio
%--------------------------------

[y,Fs]=audioread('Diner.wav');   %signal d'origine
% [y,Fs]=audioread('Extrait.wav');   %signal d'origine
% [y,Fs]=audioread('Halleluia.wav');   %signal d'origine
% [y,Fs]=audioread('Gabe_dog.mp3');   %signal d'origine

% Remarque : si le signal est en stéréo, ne traiter qu'une seule voie à la
% fois
y = y(:,1);
N = length(y);
t = [0:N-1]/Fs;
f = [0:N-1]*Fs/N;

% Courbes (évolution au cours du temps, spectre et spectrogramme)
%--------
% Ne pas oublier de créer les vecteurs temps, fréquences...
% A FAIRE !
% Tracé temporel 
figure(1)
subplot(211),plot(t,y),grid%, xlabel('Signal original')
title("Signal d'entrée")
% Spectrogramme
subplot(212),spectrogram(y,128,120,128,Fs,'yaxis')%, xlabel('Spectrogramme')
fprintf("Signal original (next : ralentissement)\n");

% Ecoute
%-------
% A FAIRE !
soundsc(y,Fs)
pause

fprintf("\n");
%%
%-------------------------------
% 1- MODIFICATION DE LA VITESSE
% (sans modification du pitch)
%-------------------------------
fprintf("PARTIE 1 : MODIFICATION DE LA VITESSE\n");
% PLUS LENT
rapp = 2/3;   %peut être modifié
ylent = PVoc(y,rapp,1024); 

% Courbes
%--------
% A FAIRE !
% Tracé temporel 
Nlent = length(ylent);
tlent = [0:Nlent-1]/Fs;
flent = [0:Nlent-1]*Fs/Nlent;
figure(2)
subplot(211),plot(tlent,ylent),grid%, xlabel('Signal original')
title("Signal ralenti")
% Spectrogramme
subplot(212),spectrogram(ylent,128,120,128,Fs,'yaxis')%, xlabel('Spectrogramme')
fprintf("\tSignal ralenti (next : acceleration)\n");

% Ecoute
%-------
% A FAIRE !
soundsc(ylent,Fs)
pause

%
% PLUS RAPIDE
rapp = 3/2;   %peut être modifié
yrapide = PVoc(y,rapp,1024); 

% Courbes
%--------
% A FAIRE !
Nrapide = length(yrapide);
trapide = [0:Nrapide-1]/Fs;
frapide = [0:Nrapide-1]*Fs/Nrapide;
% Tracé temporel 
figure(3)
subplot(211),plot(trapide,yrapide),grid%, xlabel('Signal original')
title("Signal accéléré")
% Spectrogramme
subplot(212),spectrogram(yrapide,128,120,128,Fs,'yaxis')%, xlabel('Spectrogramme')
fprintf("\tSignal accéléré (next : augmentation du pitch)\n");

% Ecoute 
%-------
% A FAIRE !
soundsc(yrapide,Fs)
pause

fprintf("\n");
%%
%----------------------------------
% 2- MODIFICATION DU PITCH
% (sans modification de vitesse)
%----------------------------------
fprintf("PARTIE 2 : MODIFICATION DU PITCH\n");
% Paramètres généraux:
%---------------------
clear;
[y,Fs]=audioread('Diner.wav');   %signal d'origine
y = y(:,1);
N = length(y);
t = [0:N-1]/Fs;
f = [0:N-1]*Fs/N;
% Nombre de points pour la FFT/IFFT
Nfft = 256;

% Nombre de points (longueur) de la fenêtre de pondération 
% (par défaut fenêtre de Hanning)
Nwind = Nfft;



% Augmentation 
%--------------
a = 3;  b = 4;  %peut être modifié
rapp = a/b;
yvoc = PVoc(y, rapp,Nfft,Nwind);

% Ré-échantillonnage du signal temporel afin de garder la même vitesse
% A FAIRE !
yreech = resample(yvoc, a, b);

%Somme de l'original et du signal modifié
%Attention : on doit prendre le même nombre d'échantillons
%Remarque : vous pouvez mettre un coefficient à ypitch pour qu'il
%intervienne + ou - dans la somme...
% A FAIRE !
ypitch = 1;
ysomme = y(1:length(yreech)) + ypitch*yreech;

% Courbes
%--------
% A FAIRE !
% Tracé temporel 
figure(4)
subplot(411),plot(t,y),grid%, xlabel('Signal augmenté')
title("Signal augmenté")
% Spectrogramme
subplot(412),spectrogram(y,128,120,128,Fs,'yaxis')%, xlabel('Spectrogramme augmenté')

subplot(413),plot(t,y),grid%, xlabel('Signal sommé (augmenté)')
title("Signal sommé (augmenté)")
% Spectrogramme
subplot(414),spectrogram(y,128,120,128,Fs,'yaxis')%, xlabel('Spectrogramme sommé')
fprintf("\tSignal augmenté (next : original + augmenté)\n");

% Ecoute
%-------
% A FAIRE !
soundsc(yreech,Fs)
pause
fprintf("\tSignal original + signal augmenté (next : diminution)\n");
soundsc(ysomme,Fs)
pause

%Diminution 
%------------

a = 4;  b = 3;   %peut être modifié
rapp = a/b;
yvoc = PVoc(y, rapp,Nfft,Nwind); 

% Ré-échantillonnage du signal temporel afin de garder la même vitesse
% A FAIRE !
yreech = resample(yvoc, a, b);

%Somme de l'original et du signal modifié
%Attention : on doit prendre le même nombre d'échantillons
%Remarque : vous pouvez mettre un coefficient à ypitch pour qu'il
%intervienne + ou - dans la somme...
% A FAIRE !
ypitch = 3;
Nmin = min(N, length(yreech));
ysomme = y(1:Nmin) + ypitch*yreech(1:Nmin);

% Courbes
%--------
% A FAIRE !
figure(5)
subplot(411),plot(t,y),grid%, xlabel('Signal diminué')
title("Signal diminué")
% Spectrogramme
subplot(412),spectrogram(y,128,120,128,Fs,'yaxis')%, xlabel('Spectrogramme augmenté')

subplot(413),plot(t,y),grid%, xlabel('Signal sommé (diminution)')
title("Signal sommé (diminution)")
% Spectrogramme
subplot(414),spectrogram(y,128,120,128,Fs,'yaxis')%, xlabel('Spectrogramme sommé')
fprintf("\tSignal diminué (next : original + diminué)\n");

% Ecoute
%-------
% A FAIRE !
soundsc(yreech,Fs)
pause
fprintf("\tSignal original + signal diminué (next : robotisation)\n");
soundsc(ysomme,Fs)
pause

fprintf("\n");
%%
%----------------------------
% 3- ROBOTISATION DE LA VOIX
%-----------------------------
fprintf("PARTIE 3 : ROBOTISATION\n");

clear;
[y,Fs]=audioread('Diner.wav');   %signal d'origine
y = y(:,1);
N = length(y);
t = [0:N-1]/Fs;
f = [0:N-1]*Fs/N;

% Choix de la fréquence porteuse (2000, 1000, 500, 200)
Fc = 500;   %peut être modifié
yrob = Rob(y,Fc,Fs);
% cste = ones(N,1);
% csterob = Rob(cste, Fc, Fs);

% Courbes
%-------------
% A FAIRE !
% Signal temporel
figure(6)
subplot(211),plot(t,yrob),grid%, xlabel('Signal robotisé')
title("Signal robotisé")
% Spectrogramme
subplot(212),spectrogram(yrob,128,120,128,Fs,'yaxis')%, xlabel('Spectrogramme robotisé')
fprintf("\tSignal robotisé (next : signal qui va être mariotisé)\n");

% Ecoute
%-------
% A FAIRE !
% soundsc(cste,Fs)
% pause
% soundsc(csterob,Fs)
% pause
soundsc(yrob,Fs)
pause

fprintf("\n");

%%
%----------------------------------
% 4 - Mariotisation d'un signal
%----------------------------------
fprintf("PARTIE 4 : MARIOTISATION\n");
% Objectif : jouer les premières notes du thème de Mario Bros
% à partir d'un extrait donné qu'on va repitcher à plusieurs 
% reprise
% ---------------------------------
% ENTREES : 
% x  : signal d'entrée
% Fs : fréquence d'echantillonnage du signal
% 
% et c'est tout !
clear;
[y,Fs]=audioread('Gabe_dog.mp3');   %signal d'origine (un chien qui aboie)
y = y(:,1);
N = length(y);
t = [0:N-1]/Fs;
f = [0:N-1]*Fs/N;

y_mario = Mariotisation(y, Fs);

% Signal temporel
figure(6)
subplot(211),plot(t, y),grid%, xlabel('Signal robotisé')
title("Signal destiné à être mariotisé")
% Spectrogramme
subplot(212),spectrogram(y,128,120,128,Fs,'yaxis')%, xlabel('Spectrogramme robotisé')

% Ecoute
soundsc(y, Fs);
fprintf("\tSignal destiné à être mariotisé (durée : 33 secondes (désolé ...)) (next : signal mariotisé)\n");
pause

% Signal temporel
figure(7)
subplot(211),plot(t(1:length(y_mario)), y_mario),grid%, xlabel('Signal robotisé')
title("Signal mariotisé")
% Spectrogramme
subplot(212),spectrogram(y_mario,128,120,128,Fs,'yaxis')%, xlabel('Spectrogramme robotisé')

% Ecoute mariotisé
soundsc(y_mario, Fs);
fprintf("\tSignal mariotisé (end)\n");

