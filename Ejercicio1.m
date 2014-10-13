%% Ejercicio 1
%% Introducción y repaso de probabilidad y teoría de información.
% Escriba un programa para generar números aleatorios $\mathbf{x}$ con una
% función de densidad de probabilidad ($fdp$) gaussiana 
% $\mathcal{N}(\mathbf{\mu},\mathbf{\Sigma})) en $d$ dimensiones:
%
clc; close all; clear all;
%% 1. 
% Para cada uno de los siguientes casos: i) $fdp$ gaussiana 
% unidimensional; ii) $fdp$ gaussiana bidimensional no correlacionada y 
% iii) $fdp$ gaussiana bidimensional correlacionada,
%  
% * Genere un conjunto de números aleatorios con esa $fdp$.
% * Estime la $fdp$ experimental mediante un histrograma normalizado.
% * Compare graficamente la estimación obtenida con la fdp teórica.


%% 1.i) $fdp$ gaussiana unidimensional

N      = 5000;  %
media  = 3;     % definición de fdp
desvio = 2;     %

x = randgauss1D(media, desvio, N);  % conjunto de números aleatorios

[alturas, centros] = hist(x, 40);   % histograma sin normalizar
ancho = centros(2) - centros(1);    % ancho de las barras del histograma
area  = sum(ancho .* alturas);      % area de las barras del histograma
bar(centros, alturas/area,'b');     % dibuja histograma normalizado
% std(x)
% mean(x)
t = -7:0.01:13;                     
pteorica = normpdf(t,media,desvio); % fdp teórica con igual media y desvio
hold on; plot(t,pteorica,'--k','LineWidth',2.5); hold off;
title({'fdp de una distribución gaussiana unidimensional';
       sprintf('mu = %0.1f, sigma = %0.1f', media, desvio)})
ylabel('p(x)'); xlabel('x');
legend('fdp experimental','fdp teorica')

%%
% Para normalizar el histograma se dividió por la suma de las áreas de 
% los rectángulos dado que la integral de una $fdp$ debe dar 1, aún en este
% caso donde es empírica la $fdp$. En la comparación gráfica con la teórica 
% se verifica su correspondencia.
% Debajo se muestra el código de las dos funciones propias utilizadas.

%% randgauss.m
dbtype randgauss.m

%% randgauss1D.m
dbtype randgauss1D.m



%%  1.ii) $fdp$ gaussiana bidimensional no correlacionada;

N = 100000;      %
media = [5 10];  % definición de fdp
covar = [2 0;   %
         0 1];  %
     
x = randgaussXD(media, covar, N);

[alturas, centros] = hist3(x,[30 30]);
ancho1 = centros{1}(2) - centros{1}(1);
ancho2 = centros{2}(2) - centros{2}(1);
volumen = sum(ancho1 * sum(ancho2 * alturas));
[xx, yy] = meshgrid(centros{1},centros{2});
% bar3(xx, alturas)
% surface(xx,yy,alturas ./ volumen); axis tight
% colormap winter

contour3(centros{1},centros{2},alturas./ volumen,15)
% ylabel('x_2'); xlabel('x_1'); zlabel('p(x_1,x_2)');

NN = 100;
t1 = linspace(-5,15,NN);
t2 = linspace(0,20,NN);

for i = 1:NN
    for j = 1:NN
        pteorica(i,j) = mvnpdf([t1(i) t2(j)],media,covar);
    end
end
hold on
contour3(t1,t2,pteorica,15,'k')
ylabel('x_2'); xlabel('x_1'); zlabel('p(x_1,x_2)');
hold off
% t = -7:0.01:13;                     
% pteorica = normpdf(t,media,desvio); % fdp teórica con igual media y desvio
% hold on; plot(t,pteorica,'--k','LineWidth',2.5); hold off;
% title({'fdp de una distribución gaussiana unidimensional';
%        sprintf('mu = %0.1f, sigma = %0.1f', media, desvio)})
% ylabel('p(x)'); xlabel('x');
% legend('fdp experimental','fdp teorica')


%% randgauss2D.m
dbtype randgauss2D.m

%%
% 
% 2. Compruebe numéricamente el teorema del límite central mediante la suma
% de números aleatorios con distribución uniforme.

% N = 10000;
% figure
% for i = 1:4
%     N =[1 2 4 40];
%     for n= 1:N
%         suma(n) = sum(2* rand(1,N(i)) - 1) ./ (0.5*N(i));
%     end
%     
%     subplot(2,2,i)
%     hist(suma,40)
%     title(['N=' num2str(N(i))])
% end


%%
% 
% 3. Compruebe numéricamente el teorema del límite central mediante la suma
% de números aleatorios con distribución uniforme.
