function y = TFCT_Interp(X,t,Nov) ;
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
% Premier indice de la colonne interpolée à calculer
% (première colonne de Y). Cet indice sera incrémenté
% dans la boucle
Ncy = 1;
% On ajoute à X une colonne de zéros pour éviter le problème de
% X( : , Ncx2) en fin de boucle (Ncx2 peut être égal à nc+1)
X = [X,zeros(nl,1)];
% Boucle pour l'interpolation
%----------------------------
%Pour chaque valeur de t, on calcule la nouvelle colonne de Y à partir de 2
%colonnes successives de X
for tn=t
    if(tn <=1)
        Ncx1=1;
        Ncx2=2;
    else
        Ncx1=floor(tn);
        Ncx2=floor(tn)+1;
    end
    beta = tn - floor(tn);
    alpha = 1 - beta;
    My = alpha*X(:,Ncx1)+beta*X(:,Ncx2);
    y(:,Ncy) = My .*exp(j*phi);
    dphi = angle(X(:,Ncx2)) - angle(X(:,Ncx1)) - dphi0;
    dphi = dphi - 2*pi*round(dphi/2*pi);
    phi = phi + dphi + dphi0;
    Ncy = Ncy + 1;
end