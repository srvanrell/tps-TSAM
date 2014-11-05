%% Ejercicio 5
% Aprendizaje basado en redes y algoritmos clásicos
clc; clear all; close all;
%% 1
% Genere un conjunto de datos aleatorios bidimensionales...

N = 400; % cantidad de muestras

mu1 = [1 1.5];
sigma1 = [0.5 0.3;
          0.3 1.7];

mu2 = [4 4];
sigma2 = [1.2 -0.7;
          -0.7 3];

x1 = mvnrnd(mu1, sigma1, N);
x2 = mvnrnd(mu2, sigma2, N);

hold on
plot(x1(:,1), x1(:,2),'+b')
plot(x2(:,1), x2(:,2),'or')
hold off


%% 2
% Implementación perceptrón simple

