function y = Mariotisation(x_stereo, Fs)
% Cette fonction joue les notes de Mario à partir d'un signal donné
% 
% On ne garde qu'une seule des deux pistes (on ne traite pas le stéréo)
x = x_stereo(:,1);
N = length(x);
t = [0:N-1]/Fs;
f = [0:N-1]*Fs/N;

% % Signal temporel
% figure(1)
% subplot(211),plot(t,x),grid, xlabel('Signal entré')
% title("Signal entré")
% % Spectrogramme
% subplot(212),spectrogram(x,128,120,128,Fs,'yaxis'), xlabel('Spectrogramme signal')


% Récupération du moment du son le plus fort
[valeur_max_t, argmax_t] = max(x);

% On ne garde que 1/4 de secondes autour de ce maximum
% 1 seconde       ==>  Fs echantillons
% 1/k de seconde  ==>  Fs/k echantillons
k = 3;
if N < Fs/k % Si l'extrait dure moins qu'1/6ème de secondes
    extrait_max = x;
elseif argmax_t-Fs/(4*k) < 0
    extrait_max = x(round(argmax_t) : round(argmax_t + Fs/k));
elseif argmax_t+Fs/(4/3*k) > N
    extrait_max = x(round(argmax_t - Fs/k) : round(argmax_t));
else
    extrait_max = x(round(argmax_t - Fs/(4*k)) : round(argmax_t + Fs/(4/3*k)));
end

% % Signal temporel
% figure(2)
% subplot(211),plot(t(1:round(Fs/k)+1),extrait_max),grid, xlabel('Signal à amplitude max')
% title("Signal à amplitude max (1/k ème de secondes)")
% % Spectrogramme
% subplot(212),spectrogram(extrait_max,128,120,128,Fs,'yaxis'), xlabel('Spectrogramme extrait')

% On a maintenant l'extrait qu'on va répéter : il nous reste plus 
% qu'à le re-pitcher aux notes de Mario et à accoler tout ça ensemble
%
% Les notes de mario font : Mi Mi - Mi - Do Mi - Sol - - - Sol-
% On a donc besoin de connaitre la fréquence de ces notes
f_do = [16.3, 32.7, 65, 131, 262, 523, 1046, 2093, 4186, 8372];
f_mi = [20.5, 41.2, 83, 165, 330, 659, 1318.5, 2637, 5274, 10548];
f_sol= [24.5, 49, 98, 196, 392, 784, 1568, 3136, 6272, 12544];

% On fait la transformée de Fourier de l'extrait (on considère 
% cet extrait de 1/6 de secondes comme stationnaire, même si c'est
% un peu abusé, je vous l'accorde ...), puis on regarde quelle fréquence
% a le plus d'énergie
tf_extrait = fftshift(abs(extrait_max));

[valeur_max_f, freq_max] = max(extrait_max);
freq_max = abs(freq_max);

% Extraction de l'octave de la fréquence max de l'extrait
indice = length(f_sol(f_sol < freq_max))+1;

% Modification du pitch pour avoir le mi le plus proche (arrondi au dessus)
% je veux faire plus aigue ==> a/b < 1 avec a = freq_max et b = f_mi
a = freq_max*10;
b = f_mi(:, indice)*10;
modif_mi = PVoc(extrait_max, a/b);
extrait_mi = resample(modif_mi, a, b);

% Pareil pour Do
b = f_do(:, indice)*10;
modif_do = PVoc(extrait_max, a/b);
extrait_do = resample(modif_do, a, b);

% Pareil pour Sol
b = f_sol(:, indice)*10;
modif_sol = PVoc(extrait_max, a/b);
extrait_sol = resample(modif_sol, a, b);

% Pareil pour Sol-
b = f_sol(:, indice-1)*10;
modif_solm = PVoc(extrait_max, a/b);
extrait_solm = resample(modif_solm, a, b);

% Construction du signal final
y = zeros(round(Fs/6*16), 1);

y(1:length(extrait_mi)) = extrait_mi;
y(round(1*Fs/6)+1:round(1*Fs/6)+length(extrait_mi)) = extrait_mi;
y(round(3*Fs/6)+1:round(3*Fs/6)+length(extrait_mi)) = extrait_mi;
y(round(5*Fs/6)+1:round(5*Fs/6)+length(extrait_do)) = extrait_do;
y(round(6*Fs/6)+1:round(6*Fs/6)+length(extrait_mi)) = extrait_mi;
y(round(8*Fs/6)+1:round(8*Fs/6)+length(extrait_sol)) = extrait_sol;
y(round(12*Fs/6)+1:round(12*Fs/6)+length(extrait_solm)) = extrait_solm;
end