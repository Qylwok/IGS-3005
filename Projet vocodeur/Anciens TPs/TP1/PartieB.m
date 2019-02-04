close all
clear
%%%%%%%%%%%%
% Partie B1
%%%%%%%%%%%%
% On travaille � une fr�quence d'�chantillonnage de 8 kHz 
% et sur 256 points (�chantillons)
Fe = 8000;
N = 256;

% On cr�e 2 sinuso�des : une � 100Hz et une � 800Hz
f1 = 100; f2 = 800;
t = [0:N-1]/Fe;
s1 = sin(2*pi*f1*t); 
s2 = 2*sin(2*pi*f2*t); 

% On cr�e 2 signaux diff�rents � partir des sinuso�des pr�c�dentes
% (on normalise l'amplitude � 1)
x1 = s1 + 2*s2;         % signal 1 = somme des 2 sinuso�des
x1 = x1/max(abs(x1));   % normalisation
X1 = (1/N)*fft(x1);
f1 = [0:N-1]*Fe/N;

x2 = [s1,2*s2];         % signal 2 = concat�nation des 2 sinuso�des
x2 = x2/max(abs(x2));   % normalisation
N2 = length(x2);
t2 = [0:N2-1]/Fe;
X2 = (1/N2)*fft(x2);
f2 = [0:N2-1]*Fe/N2;


% figure(1)
% subplot(311),plot(t,x1),grid
% title('Somme des sinuso�des')
% ylabel('signal temporel')
% subplot(312),plot(f1-Fe/2,fftshift(abs(X1))),grid
% ylabel('TFD')
% subplot(313),spectrogram(x1,64,63,64,Fe,'yaxis')
% ylabel('Spectrogramme')

% figure(2)
% subplot(311),plot(t2,x2),grid
% title('Concat�nation des sinuso�des')
% ylabel('signal temporel')
% subplot(312),plot(f2-Fe/2,fftshift(abs(X2))),grid
% ylabel('TFD')
% subplot(313),spectrogram(x2,64,63,64,Fe,'yaxis')
% ylabel('Spectrogramme')

%---------------------------------------------------------------
%%%%%%%%%%%%
% Partie B2
%%%%%%%%%%%%
%r�cup�ration du son et de sa fr�quence d'�chantillonnage 
%contenus dans le fichier ".wav"
[son,Fe]=audioread('Audio/ECG.wav');

%si le son est en st�r�o (2 voies), on n'en r�cup�re qu'une seule
%remarque vous pourez par la suite travailler sur les voies
x = son(:,1);  

%permet d'�couter le son � la bonne vitesse de lecture (d�finie par Fe)
soundsc(x,Fe)

N = length(x);
t = [0:N-1]/Fe;

X = (1/N)*fft(x);
f = [0:N-1]*Fe/N;

figure(3),
subplot(311),plot(t,x),grid
title('Son issu du fichier .wav')
ylabel('signal temporel')
subplot(312),plot(f-Fe/2,fftshift(abs(X))),grid
ylabel('TFD')
subplot(313),spectrogram(x,128,120,128,Fe,'yaxis')
ylabel('Spectrogramme')
