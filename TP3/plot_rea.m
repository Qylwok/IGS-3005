function plot_rea(X,k,fig)
% Syntaxe : plot_rea(X,k,fig)
% Pour une matrice de taille KxN, contenant K réalisations 
% de N points, affiche sur la figure fig les M réalisations dont les indices 
% sont contenus dans le vecteur k 
% (c) jfb 2010 - 17/01/2010
% Dernière mise à  jour 17/01/2010

[K,N]=size(X);
M=length(k);

% fig: numéro de figure
%N: Nombre de points par rÃ©alisations
%K: nombre total de rÃ©alisations 
%M Nombre de rÃ©alisations affichÃ©es
% dont les indices sont contenues  dans le vecteur k


figure(fig)
subplot(M,M,[1:M-1]*M)
 plot (mean(X(k,:)'),[1:M],'r')
 set(gca,'ytick',[])
 ylabel('Moyenne temporelle')
for i=0:M-2
    subplot(M,M,i*M+[1:M-1])
    plot (X(k(i+1),:))
    %axis off
    set(gca,'xtick',[],'ytick',[])
end
i=i+1;
subplot(M,M,i*M+[1:M-1])
plot (mean(X),'g')
% Reset the bottom subplot to have xticks
set(gca,'xtickMode', 'auto')
xlabel('Moyenne d''ensemble')