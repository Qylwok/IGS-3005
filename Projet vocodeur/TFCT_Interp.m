function y = TFCT_Interp(X,t,Nov) 
% X est la matrice issue de la TFCT
% t est le vecteur des indices sur lesquels doit être faite
% l’interpolation
% Nov est le nombre d’échantillons correspondant au chevauchement des
% fenêtres (trames) lors de la TFCT
[nl,nc] = size(X); % récupération des dimensions de X
N = 2*(nl-1); % calcul de N (= Nfft en principe)
% Initialisations
%-------------------
% Spectre interpolé
y = zeros(nl, length(t));
% Phase initiale
phi = angle(X(:,1));
% Déphasage entre chaque échantillon de la TF
dphi0 = zeros(nl,1);
dphi0(2:nl) = (2*pi*Nov)./(N./(1:(N/2)));
dphi = dphi0;
% Premier indice de la colonne interpolée à calculer
% (première colonne de Y). Cet indice sera incrémenté
% dans la boucle
ind_col = 1;
% On ajoute à X une colonne de zéros pour éviter le problème de
% X( : , ind_col + 1) en fin de boucle
X = [X,zeros(nl,1)];
My = zeros(nl, nc);
% Boucle pour l'interpolation
%----------------------------
%Pour chaque valeur de t, on calcule la nouvelle colonne de Y à partir de 2
%colonnes successives de X
while ind_col ~= nc
    X2col = [X(:,ind_col), X(:,ind_col+1)];
    for tn = t
        
        beta = tn - floor(tn);
        alpha = 1-beta;
        My(:,ind_col) = alpha * X2col(:,1) + beta * X2col(:,2);
        y(:, ind_col) = My(:,ind_col).*exp(1i*phi);
        dphi = angle(X2col(:,2)-angle(X2col(:,1)-dphi0));
        dphi = dphi - 2 * pi *round(dphi/(2*pi));
        phi = phi + dphi + dphi0;
        
    end
    ind_col = ind_col +1;
end
