%% Ejercicio 1
% Introducción y repaso de probabilidad y teoría de información.
%%
% Escriba un programa para generar números aleatorios $\mathbf{x}$ con una
% función de densidad de probabilidad ($fdp$) gaussiana 
% $\mathcal{N}(\mathbf{\mu},\mathbf{\Sigma})) en $d$ dimensiones:
% 
% 1. Para cada uno de los siguientes casos: i) $fdp$ gaussiana 
% unidimensional; ii) $fdp$ gaussiana bidimensional no correlacionada y 
% iii) $fdp$ gaussiana bidimensional correlacionada,
%  
% * Genere un conjunto de números aleatorios con esa $fdp$.
% * Estime la $fdp$ experimental mediante un histrograma normalizado.
% * Compare graficamente la estimación obtenida con la fdp teórica.
clc; close all; clear all;

%%
% i) $fdp$ gaussiana unidimensional;

total = 10000;
media = 3;
desvio = 2;

x = randgauss1D(media, desvio, total);  % Conjunto de números aleatorios

[cuentas, centros] = hist(x, 40);   % Histograma
bar(centros, cuentas/total)             % Dibuja histograma normalizado
t = -7:0.01:13;
p = normpdf(t,media,desvio);
hold on; plot(t,p);
hold off
% ESTA FALLANDO LO DEL HISTOGRAMA NORMALIZADO
std(x)
mean(x)

%% randgauss.m
dbtype randgauss.m

%% randgauss1D.m
dbtype randgauss1D.m

%%
% i) $fdp$ gaussiana bidimensional no correlacionada;

total = 10000;
media = [3 1];
covar = [2  0;
         0  4];
     
x = zeros(total,2);
ref = media;
for n=1:total
    x(n,:) = randgaussXD(media, covar);  % Conjunto de números aleatorios
%     ref(:,n) = mvnrnd(media, covar);
end

hist3(x,[40 40])
% hold on
% hist3(ref', [40 40])
% hold off

% [cuentas, centros] = hist(x, 40);   % Histograma
% bar(centros, cuentas*2*sqrt(desvio)/N)             % Dibuja histograma normalizado
% t = -7:0.01:13;
% p = normpdf(t,media,desvio);
% hold on; plot(t,p);
% hold off
% ESTA FALLANDO LO DEL HISTOGRAMA NORMALIZADO
% std(x)
% mean(x)

% %% randgauss2D.m
% dbtype randgauss2D.m

%%
% 
% 2. Compruebe numéricamente el teorema del límite central mediante la suma
% de números aleatorios con distribución uniforme.

total = 10000;
figure
for i = 1:4
    N =[1 2 4 40];
    for n= 1:total
        suma(n) = sum(2* rand(1,N(i)) - 1) ./ (0.5*N(i));
    end
    
    subplot(2,2,i)
    hist(suma,40)
    title(['N=' num2str(N(i))])
end


%%
% 
% 3. Compruebe numéricamente el teorema del límite central mediante la suma
% de números aleatorios con distribución uniforme.
