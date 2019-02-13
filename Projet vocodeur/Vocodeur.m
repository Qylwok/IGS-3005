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

% Courbes (évolution au cours du temps, spectre et spectrogramme)
%--------
% Ne pas oublier de créer les vecteurs temps, fréquences...
% A FAIRE !
N = length(y);
t = [0:N-1]/Fs;
f = [0:N-1]*Fs/N;

% Tracé temporel 
figure(1)
subplot(211),plot(t,y),grid, xlabel('Signal original')
title("Signal d'entrée")
% Spectrogramme
subplot(212),spectrogram(y,128,120,128,Fs,'yaxis'), xlabel('Spectrogramme')

% Ecoute
%-------
% A FAIRE !
% soundsc(y,Fs)
% pause

%%
%-------------------------------
% 1- MODIFICATION DE LA VITESSE
% (sans modification du pitch)
%-------------------------------
% PLUS LENT
rapp = 2/3;   %peut être modifié
ylent = PVoc(y,rapp,1024); 

% Ecoute
%-------
% A FAIRE !
soundsc(ylent,Fs)
pause

% Courbes
%--------
% A FAIRE !
% Tracé temporel 
Nlent = length(ylent);
tlent = [0:Nlent-1]/Fs;
flent = [0:Nlent-1]*Fs/Nlent;
figure(2)
subplot(211),plot(tlent,ylent),grid, xlabel('Signal original')
title("Signal ralenti")
% Spectre (TFCT)
% subplot(312),plot(f-Fs/2,fftshift(abs(ylent))),grid, xlabel('Spectre (TFD)')
% Spectrogramme
subplot(212),spectrogram(ylent,128,120,128,Fs,'yaxis'), xlabel('Spectrogramme')


%
% PLUS RAPIDE
rapp = 3/2;   %peut être modifié
yrapide = PVoc(y,rapp,1024); 


% Ecoute 
%-------
% A FAIRE !
soundsc(yrapide,Fs)
pause

% Courbes
%--------
% A FAIRE !
Nrapide = length(yrapide);
trapide = [0:Nrapide-1]/Fs;
frapide = [0:Nrapide-1]*Fs/Nrapide;
% Tracé temporel 
figure(3)
subplot(211),plot(trapide,yrapide),grid, xlabel('Signal original')
title("Signal accéléré")
% Spectrogramme
subplot(212),spectrogram(yrapide,128,120,128,Fs,'yaxis'), xlabel('Spectrogramme')

%%
%----------------------------------
% 2- MODIFICATION DU PITCH
% (sans modification de vitesse)
%----------------------------------
% Paramètres généraux:
%---------------------
[y,Fs]=audioread('Extrait.wav');   %signal d'origine
% Nombre de points pour la FFT/IFFT
Nfft = 256;

% Nombre de points (longueur) de la fenêtre de pondération 
% (par défaut fenêtre de Hanning)
Nwind = Nfft;

% Augmentation 
%--------------
a = 2;  b = 3;  %peut être modifié
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

% Ecoute
%-------
% A FAIRE !
soundsc(yreech,Fs)
pause
soundsc(ysomme,Fs)
pause

% Courbes
%--------
% A FAIRE !
% Tracé temporel 
figure(4)
subplot(211),plot(t,y),grid, xlabel('Signal réhaussé')
title("Signal réhaussé")
% Spectrogramme
subplot(212),spectrogram(y,128,120,128,Fs,'yaxis'), xlabel('Spectrogramme réhaussé')

figure(5)
subplot(211),plot(t,y),grid, xlabel('Signal sommé (augmenté)')
title("Signal sommé (augmenté)")
% Spectrogramme
subplot(212),spectrogram(y,128,120,128,Fs,'yaxis'), xlabel('Spectrogramme sommé')


%Diminution 
%------------

a = 3;  b = 2;   %peut être modifié
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
% Ecoute
%-------
% A FAIRE !
soundsc(yreech,Fs)
pause
soundsc(ysomme,Fs)
pause
% Courbes
%--------
% A FAIRE !
figure(6)
subplot(211),plot(t,y),grid, xlabel('Signal diminué')
title("Signal diminué")
% Spectrogramme
subplot(212),spectrogram(y,128,120,128,Fs,'yaxis'), xlabel('Spectrogramme réhaussé')

figure(7)
subplot(211),plot(t,y),grid, xlabel('Signal sommé (diminution)')
title("Signal sommé (diminution)")
% Spectrogramme
subplot(212),spectrogram(y,128,120,128,Fs,'yaxis'), xlabel('Spectrogramme sommé')


%
%----------------------------
% 3- ROBOTISATION DE LA VOIX
%-----------------------------
[y,Fs]=audioread('Diver.wav');   %signal d'origine
% Choix de la fréquence porteuse (2000, 1000, 500, 200)
Fc = 500;   %peut être modifié
cste = ones(N,1);
yrob = Rob(y,Fc,Fs);
csterob = Rob(cste, Fc, Fs);
% Ecoute
%-------
% A FAIRE !
soundsc(cste,Fs)
pause
soundsc(csterob,Fs)
% pause
% Courbes
%-------------
% A FAIRE !
% Signal temporel
figure(8)
subplot(211),plot(t,csterob),grid, xlabel('Signal robotisé')
title("Signal robotisé")
% Spectrogramme
subplot(212),spectrogram(csterob,128,120,128,Fs,'yaxis'), xlabel('Spectrogramme robotisé')

figure(9)
subplot(211),plot(t,yrob),grid, xlabel('Signal robotisé')
title("Signal robotisé")
% Spectrogramme
subplot(212),spectrogram(yrob,128,120,128,Fs,'yaxis'), xlabel('Spectrogramme robotisé')

%%
%----------------------------------
% 4 - Mariotisation d'un signal
%----------------------------------
% Objectif : jouer les premières notes du thème de Mario Bros
% à partir d'un extrait donné qu'on va repitcher à plusieurs 
% reprise
% ---------------------------------
% ENTREES : 
% x  : signal d'entrée
% Fs : fréquence d'echantillonnage du signal
% 
% et c'est tout !
[y,Fs]=audioread('Gabe_dog.mp3');   %signal d'origine (un chien qui aboie)
y_mario = Mariotisation(y, Fs);
soundsc(y_mario, Fs);
