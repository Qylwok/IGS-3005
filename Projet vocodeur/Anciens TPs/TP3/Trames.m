function Xt = Trames(x,dt,Fe);

%La fonction retourne une matrice Xt dont chaque colonne correspond � 1
%trame.
%Les trames correspondent au "d�coupage" du signal d'entr�e x en s�quences
%de dur�e dt (dt = dur�e d'une trame)

N = length(x);

%D�coupage en trames de dt secondes afin de travailler sur des portions
%"stationnaires" du signal

Nt = floor(dt*Fe);   %nombre d'�chantillons dans 1 trame
Nbt = floor(N/Nt);  %nombre total de trames "enti�res"

%Initialisation
Xt = zeros(Nt,Nbt);

for numt = 0:Nbt-1
Xt(:,numt+1) = x(numt*Nt+1:(numt+1)*Nt);
end

