function x = randgaussXD(MU, SIGMA, N)
%RANDGAUSSXD(MU, SIGMA, N) genera un conjunto de números aleatorios de 
% dimensión D provenientes de una distribución gaussiana multidimensional, 
% cuyas medias quedan definidas por el vector MU (horizontal, de tamaño 
% 1 x D), la matriz de covarianza SIGMA (cuadrada, de tamaño D x D) y la
% cantidad de numeros N (1 por defecto). 
%
% x es de tamaño N x D, donde cada número de dimensión D se ubica por
% renglón.

if nargin < 3
    N = 1;     % tamaño por defecto
end

x = zeros(N,length(MU)); % inicializo
for n = 1:N
    x(n,:) = mvrandgauss(MU, SIGMA); % Conjunto de números aleatorios
end

end

