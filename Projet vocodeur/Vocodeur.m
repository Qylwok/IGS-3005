close all
clear
fprintf("\n\n\n\n\n\n\n\n\n\n\n\n");
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VOCODEUR : Programme principal r�alisant un vocodeur de phase 
% et permettant de :
%
% 1- modifier le tempo (la vitesse de "prononciation")
%   sans modifier le pitch (fr�quence fondamentale de la parole)
%
% 2- modifier le pitch 
%   sans modifier la vitesse 
%
% 3- "robotiser" une voix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% R�cup�ration d'un signal audio
%--------------------------------

[y,Fs]=audioread('Diner.wav');   %signal d'origine
% [y,Fs]=audioread('Extrait.wav');   %signal d'origine
% [y,Fs]=audioread('Halleluia.wav');   %signal d'origine
% [y,Fs]=audioread('Gabe_dog.mp3');   %signal d'origine

% Remarque : si le signal est en st�r�o, ne traiter qu'une seule voie � la
% fois
y = y(:,1);
N = length(y);
t = [0:N-1]/Fs;
f = [0:N-1]*Fs/N;

% Courbes (�volution au cours du temps, spectre et spectrogramme)
%--------
% Ne pas oublier de cr�er les vecteurs temps, fr�quences...
% A FAIRE !
% Trac� temporel 
figure(1)
subplot(211),plot(t,y),grid%, xlabel('Signal original')
title("Signal d'entr�e")
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
rapp = 2/3;   %peut �tre modifi�
ylent = PVoc(y,rapp,1024); 

% Courbes
%--------
% A FAIRE !
% Trac� temporel 
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
rapp = 3/2;   %peut �tre modifi�
yrapide = PVoc(y,rapp,1024); 

% Courbes
%--------
% A FAIRE !
Nrapide = length(yrapide);
trapide = [0:Nrapide-1]/Fs;
frapide = [0:Nrapide-1]*Fs/Nrapide;
% Trac� temporel 
figure(3)
subplot(211),plot(trapide,yrapide),grid%, xlabel('Signal original')
title("Signal acc�l�r�")
% Spectrogramme
subplot(212),spectrogram(yrapide,128,120,128,Fs,'yaxis')%, xlabel('Spectrogramme')
fprintf("\tSignal acc�l�r� (next : augmentation du pitch)\n");

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
% Param�tres g�n�raux:
%---------------------
clear;
[y,Fs]=audioread('Diner.wav');   %signal d'origine
y = y(:,1);
N = length(y);
t = [0:N-1]/Fs;
f = [0:N-1]*Fs/N;
% Nombre de points pour la FFT/IFFT
Nfft = 256;

% Nombre de points (longueur) de la fen�tre de pond�ration 
% (par d�faut fen�tre de Hanning)
Nwind = Nfft;



% Augmentation 
%--------------
a = 3;  b = 4;  %peut �tre modifi�
rapp = a/b;
yvoc = PVoc(y, rapp,Nfft,Nwind);

% R�-�chantillonnage du signal temporel afin de garder la m�me vitesse
% A FAIRE !
yreech = resample(yvoc, a, b);

%Somme de l'original et du signal modifi�
%Attention : on doit prendre le m�me nombre d'�chantillons
%Remarque : vous pouvez mettre un coefficient � ypitch pour qu'il
%intervienne + ou - dans la somme...
% A FAIRE !
ypitch = 1;
ysomme = y(1:length(yreech)) + ypitch*yreech;

% Courbes
%--------
% A FAIRE !
% Trac� temporel 
figure(4)
subplot(411),plot(t,y),grid%, xlabel('Signal augment�')
title("Signal augment�")
% Spectrogramme
subplot(412),spectrogram(y,128,120,128,Fs,'yaxis')%, xlabel('Spectrogramme augment�')

subplot(413),plot(t,y),grid%, xlabel('Signal somm� (augment�)')
title("Signal somm� (augment�)")
% Spectrogramme
subplot(414),spectrogram(y,128,120,128,Fs,'yaxis')%, xlabel('Spectrogramme somm�')
fprintf("\tSignal augment� (next : original + augment�)\n");

% Ecoute
%-------
% A FAIRE !
soundsc(yreech,Fs)
pause
fprintf("\tSignal original + signal augment� (next : diminution)\n");
soundsc(ysomme,Fs)
pause

%Diminution 
%------------

a = 4;  b = 3;   %peut �tre modifi�
rapp = a/b;
yvoc = PVoc(y, rapp,Nfft,Nwind); 

% R�-�chantillonnage du signal temporel afin de garder la m�me vitesse
% A FAIRE !
yreech = resample(yvoc, a, b);

%Somme de l'original et du signal modifi�
%Attention : on doit prendre le m�me nombre d'�chantillons
%Remarque : vous pouvez mettre un coefficient � ypitch pour qu'il
%intervienne + ou - dans la somme...
% A FAIRE !
ypitch = 3;
Nmin = min(N, length(yreech));
ysomme = y(1:Nmin) + ypitch*yreech(1:Nmin);

% Courbes
%--------
% A FAIRE !
figure(5)
subplot(411),plot(t,y),grid%, xlabel('Signal diminu�')
title("Signal diminu�")
% Spectrogramme
subplot(412),spectrogram(y,128,120,128,Fs,'yaxis')%, xlabel('Spectrogramme augment�')

subplot(413),plot(t,y),grid%, xlabel('Signal somm� (diminution)')
title("Signal somm� (diminution)")
% Spectrogramme
subplot(414),spectrogram(y,128,120,128,Fs,'yaxis')%, xlabel('Spectrogramme somm�')
fprintf("\tSignal diminu� (next : original + diminu�)\n");

% Ecoute
%-------
% A FAIRE !
soundsc(yreech,Fs)
pause
fprintf("\tSignal original + signal diminu� (next : robotisation)\n");
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

% Choix de la fr�quence porteuse (2000, 1000, 500, 200)
Fc = 500;   %peut �tre modifi�
yrob = Rob(y,Fc,Fs);
% cste = ones(N,1);
% csterob = Rob(cste, Fc, Fs);

% Courbes
%-------------
% A FAIRE !
% Signal temporel
figure(6)
subplot(211),plot(t,yrob),grid%, xlabel('Signal robotis�')
title("Signal robotis�")
% Spectrogramme
subplot(212),spectrogram(yrob,128,120,128,Fs,'yaxis')%, xlabel('Spectrogramme robotis�')
fprintf("\tSignal robotis� (next : signal qui va �tre mariotis�)\n");

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
% Objectif : jouer les premi�res notes du th�me de Mario Bros
% � partir d'un extrait donn� qu'on va repitcher � plusieurs 
% reprise
% ---------------------------------
% ENTREES : 
% x  : signal d'entr�e
% Fs : fr�quence d'echantillonnage du signal
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
subplot(211),plot(t, y),grid%, xlabel('Signal robotis�')
title("Signal destin� � �tre mariotis�")
% Spectrogramme
subplot(212),spectrogram(y,128,120,128,Fs,'yaxis')%, xlabel('Spectrogramme robotis�')

% Ecoute
soundsc(y, Fs);
fprintf("\tSignal destin� � �tre mariotis� (dur�e : 33 secondes (d�sol� ...)) (next : signal mariotis�)\n");
pause

% Signal temporel
figure(7)
subplot(211),plot(t(1:length(y_mario)), y_mario),grid%, xlabel('Signal robotis�')
title("Signal mariotis�")
% Spectrogramme
subplot(212),spectrogram(y_mario,128,120,128,Fs,'yaxis')%, xlabel('Spectrogramme robotis�')

% Ecoute mariotis�
soundsc(y_mario, Fs);
fprintf("\tSignal mariotis� (end)\n");

