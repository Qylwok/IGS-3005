close all
clear
%-------------------------------------------------------------------
%Partie A1
%Tracé du signal et de sa TFD pour 500 échantillons
Fe = 3000;
N = 500;
t = [0:N-1]/Fe;
f01 = 100;
f02 = 105;

x = cos(2*pi*f01*t)+0.5*cos(2*pi*f02*t);

X = (1/N)*fft(x,N);
f = [0:N-1]*Fe/N;
% 
% figure(1)
% plot(t,x),grid
% title('Signal dans le domaine temporel')
% 
figure(2)
plot(f-Fe/2,fftshift(abs(X)),'r'),
title('Partie A1 : Fe = 3 kHz et N = 500 échantillons')
hold on, stem(f-Fe/2,fftshift(abs(X))),grid, hold off

% %-------------------------------------------------------------------
% %Partie A2
% %1-On augmente la résolution fréquentielle avec du "zero padding"
% %On prend le nombre "théorique" de points
N2 = 600;
X2 = (1/N)*fft(x,N2); %On notera que l'on multiplie la fft par (1/N) et non par (1/N2) 
f2 = [0:N2-1]*Fe/N2;
% 
% figure(3)
% plot(f2-Fe/2,fftshift(abs(X2)),'r')
% title('Partie A2 : Fe = 3 kHz et "zero padding" avec N'' = 600 échantillons')
% hold on, stem(f2-Fe/2,fftshift(abs(X2))),grid, hold off
% 
% %2-On augmente encore la résolution fréquentielle
% N3 = 3000;
% X3 = (1/N)*fft(x,N3);
% f3 = [0:N3-1]*Fe/N3;
% 
% figure(4)
% plot(f3-Fe/2,fftshift(abs(X3)),'r'),
% title('Partie A2 : Fe = 3 kHz et "zero padding" avec N'' = 3000 échantillons')
% hold on, stem(f3-Fe/2,fftshift(abs(X3))),grid, hold off

% 
% %-------------------------------------------------------------------
% % Partie A3
% % On augmente l'information : on prend le bon nombre d'échantillons x(n)
% % On a donc augmenté la "durée d'observation" 
t4 = [0:N2-1]/Fe;
x2 = cos(2*pi*f01*t4)+0.5*cos(2*pi*f02*t4);

X4 = (1/N2)*fft(x2,N2);
f4 = [0:N2-1]*Fe/N2;

figure(5)
plot(f4-Fe/2,fftshift(abs(X4)),'r'),
title('Partie A3 : Fe = 3 kHz et N = 600 échantillons')
hold on, stem(f4-Fe/2,fftshift(abs(X4))),grid, hold off




