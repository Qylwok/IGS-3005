function plot_sighisto(X,M,fig)
% Syntaxe : plot_sighisto(X,M,fig)
% Trace, sur la figure fig,  le signal et l'histogramme correspondant, sur M bins
% (c) jfb 2010 - 17/01/2010
% Dernière mise à jour 19/01/2010

[N]=length(X);
figure(fig)
C=10; %nombre de cellules pour affichage sioux
subplot(C,C,[1:C*(C-2)])
D=max(X)-min(X); 
plot(X,[1:N]); ylabel('Temps'); axis([min(X)-D/10 max(X)+D/10 0 N])
subplot(C,C,(C-2)*C+[1:2*C])
h=hist(X,M);
hist(X,M); xlabel('Amplitude');  axis([min(X)-D/10 max(X)+D/10 0 1.1*max(h)])
% Reset the bottom subplot to have xticks
set(gca,'xtickMode', 'auto')
