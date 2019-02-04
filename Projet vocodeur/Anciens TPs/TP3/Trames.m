function Xt = Trames(x,dt,Fe);

%La fonction retourne une matrice Xt dont chaque colonne correspond à 1
%trame.
%Les trames correspondent au "découpage" du signal d'entrée x en séquences
%de durée dt (dt = durée d'une trame)

N = length(x);

%Découpage en trames de dt secondes afin de travailler sur des portions
%"stationnaires" du signal

Nt = floor(dt*Fe);   %nombre d'échantillons dans 1 trame
Nbt = floor(N/Nt);  %nombre total de trames "entières"

%Initialisation
Xt = zeros(Nt,Nbt);

for numt = 0:Nbt-1
Xt(:,numt+1) = x(numt*Nt+1:(numt+1)*Nt);
end

