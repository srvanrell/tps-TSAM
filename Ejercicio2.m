%% Ejercicio 2
% Clasificación estadística de patrones.
%%
% 
% # Sea un clasificador geométrico lineal definido por:
% 
% * asdasd
% * asdas
% * asdasdfa
clc; close all; clear all;

% Genero la grilla
N = 100
x1 = linspace(-2,2,N);
x2 = linspace(-2,2,N);
for i = 1:N
    for j = 1:N
        g1(i,j) = - x1(i);
        g2(i,j) =   x1(i) + x2(j) -1;
        g3(i,j) =   x1(i) - x2(j) -1;
    end
end

hold on
surf(x1,x2,g1)
surf(x1,x2,g2)
surf(x1,x2,g3)
hold off

