%% Ejercicio 3
% Análisis estadístico de datos - PCA.
clc; close all; clear all;

N = 100;
S = zeros(3,N);
for n =1:N
    S(:,n) = mvnrnd([0; 0; 0],[1.5 2 0; 2 4 0; 0 0 3])';
end

% Matriz de mezcla
A = [ 1 1;
     -1 1];

scatter(S(1,:), S(2,:))
axis equal

% acp(S)