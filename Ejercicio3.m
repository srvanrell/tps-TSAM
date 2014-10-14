%% Ejercicio 3
% Análisis estadístico de datos - PCA.
clc; close all; clear all;

N = 1000;

gauss1 = randgauss1D(1, 2, N);
gauss2 = randgauss1D(3, 4, N);

S = horzcat(gauss1,gauss2);

% Matriz de mezcla
A = [ 1 1;
     1 1];

scatter(S(:,1), S(:,2))
axis equal

% acp(S)