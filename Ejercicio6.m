%% Ejercicio 6
% Redes neuronales dinámicas
clear all; close all; clc
% 1

load('patrones5x5.mat')
patronA = reshape(patrones5x5(1,:),[5 5]);
patronB = reshape(patrones5x5(2,:),[5 5]);
patronC = reshape(patrones5x5(3,:),[5 5]);

invgray = flipud(colormap(gray));

colormap(invgray)

subplot(1,3,1); imagesc(patronA'); axis equal; axis tight

subplot(1,3,2); imagesc(patronB'); axis equal; axis tight

subplot(1,3,3); imagesc(patronC'); axis equal; axis tight


%% Entrenamiento Hebbiano de los patrones
W = entrenarHopfield(patrones5x5);

N = size(patrones5x5,2);

Pmax = N / (2*log(N)); % capacidad maxima
% son 3 patrones por lo que debería funcionar

%% Recuperacion
xaleatorio = 2*(randi(2,1,N)-1) - 1;
xaletorio = (-1)*patrones5x5(1,:)
recup = recuperarHopfield(xaleatorio, W);
%%
recupA = recuperarHopfield((-1)*patrones5x5(1,:), W);
%%
recupB = recuperarHopfield((-1)*patrones5x5(2,:), W);
recupC = recuperarHopfield((-1)*patrones5x5(3,:), W);

recupA = reshape(recupA,[5 5]);
recupB = reshape(recupB,[5 5]);
recupC = reshape(recupC,[5 5]);

figure; colormap(invgray)

subplot(1,3,1); imagesc(recupA'); axis equal; axis tight

subplot(1,3,2); imagesc(recupB'); axis equal; axis tight

subplot(1,3,3); imagesc(recupC'); axis equal; axis tight


load('numeros7x5.mat')