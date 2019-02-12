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
My = zeros(nl, length(t));
% Boucle pour l'interpolation
%----------------------------
%Pour chaque valeur de t, on calcule la nouvelle colonne de Y à partir de 2
%colonnes successives de X
coeff = length(t)/nc;
i = 1;
while ind_col < nc
    X2col = [X(:,ind_col), X(:,ind_col+1)]; % Deux colonnes (= TFCT) successives
    if round((ind_col+1)*coeff-1) < 0
        t_col = t(round(ind_col*coeff));
    elseif round(ind_col*coeff) == round((ind_col+1)*coeff)-1
        if round(ind_col*coeff) == 0
            t_col = t(1);
        else
            t_col = t(round(ind_col*coeff));
        end
    else
        t_col = t(round(ind_col*coeff):round((ind_col+1)*coeff)-1);
    end
    for tn = t_col
                                % Exemple : tn = 6.39
        beta = tn - floor(tn);  % ==>   beta  = 0.39
        alpha = 1-beta;         %       alpha = 0.61
        % My = combinaison linéaire de deux colonnes successives de X
        % My pour 'Module y'
        My(:,i) = alpha * X2col(:,1) + beta * X2col(:,2);
        % Ajout du terme de phase (I suppose)
        y(:, i) = My(:,i).*exp(1i*phi);
        % Actualisation de la phase pour la prochaine itération (?)
        dphi = angle(X2col(:,2)-angle(X2col(:,1)-dphi0));
        dphi = dphi - 2 * pi *round(dphi/(2*pi));
        phi = phi + dphi + dphi0;
        i = i + 1;
    end
    ind_col = ind_col +1;
end