function y = TFCT_Interp(X,t,Nov) 
% X est la matrice issue de la TFCT
% t est le vecteur des indices sur lesquels doit �tre faite
% l�interpolation
% Nov est le nombre d��chantillons correspondant au chevauchement des
% fen�tres (trames) lors de la TFCT
[nl,nc] = size(X); % r�cup�ration des dimensions de X
N = 2*(nl-1); % calcul de N (= Nfft en principe)
% Initialisations
%-------------------
% Spectre interpol�
y = zeros(nl, length(t));
% Phase initiale
phi = angle(X(:,1));
% D�phasage entre chaque �chantillon de la TF
dphi0 = zeros(nl,1);
dphi0(2:nl) = (2*pi*Nov)./(N./(1:(N/2)));
dphi = dphi0;
% Premier indice de la colonne interpol�e � calculer
% (premi�re colonne de Y). Cet indice sera incr�ment�
% dans la boucle
ind_col = 1;
% On ajoute � X une colonne de z�ros pour �viter le probl�me de
% X( : , ind_col + 1) en fin de boucle
X = [X,zeros(nl,1)];
My = zeros(nl, nc);
% Boucle pour l'interpolation
%----------------------------
%Pour chaque valeur de t, on calcule la nouvelle colonne de Y � partir de 2
%colonnes successives de X
while ind_col < nc
    X2col = [X(:,ind_col), X(:,ind_col+1)]; % Deux colonnes (= TFCT) successives
    for tn = t % Pour chaque valeur temporelle 
                                % Exemple : tn = 6.39
        beta = tn - floor(tn);  % ==>   beta  = 0.39
        alpha = 1-beta;         %       alpha = 0.61
        % My = combinaison lin�aire de deux colonnes successives de X
        % My pour 'Module y'
        My(:,ind_col) = alpha * X2col(:,1) + beta * X2col(:,2);
        % Ajout du terme de phase (I suppose)
        y(:, ind_col) = My(:,ind_col).*exp(1i*phi);
        % Actualisation de la phase pour la prochaine it�ration (?)
        dphi = angle(X2col(:,2)-angle(X2col(:,1)-dphi0));
        dphi = dphi - 2 * pi *round(dphi/(2*pi));
        phi = phi + dphi + dphi0;
        
    end
    ind_col = ind_col +1;
end

