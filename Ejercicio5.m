%% Ejercicio 5
% Aprendizaje basado en redes y algoritmos cl√°sicos
clc; clear all; close all;
%% 1
% Genere un conjunto de datos aleatorios bidimensionales...

N = 200; % cantidad de muestras

mu1 = [1 1.5];
sigma1 = [0.5 0.3;
          0.3 1.7];

mu2 = [4 4];
sigma2 = [1.2 -0.7;
          -0.7 3];

x1 = mvnrnd(mu1, sigma1, N); % ejemplos de la clase 1 (+)
x2 = mvnrnd(mu2, sigma2, N); % ejemplos de la clase 2 (o)
eti1 = ones(N,1);            % etiquetas de los ejemplos de la clase 1 (+)
eti2 = (-1)*ones(N,1);       % etiquetas de los ejemplos de la clase 2 (o)


hold on
plot(x1(:,1), x1(:,2),'+b')
plot(x2(:,1), x2(:,2),'or')
legend('clase 1','clase 2')
title('Distribuciones originales')
axis equal
hold off


% Separacion entre entrenamiento y testeo, para cuando corresponda
ntrain = floor(0.7 * N); % 70% de los ejemplos son entrenamiento
                         % 30% para testeo

xtrain = vertcat(x1(1:ntrain,:), x2(1:ntrain,:)); % ejemplos de entrenamiento
etitrain = vertcat(eti1(1:ntrain), eti2(1:ntrain));% etiquetas para entrenamiento supervisado
xtest = vertcat(x1(ntrain+1:end,:), x2(ntrain+1:end,:)); % ejemplos de testeo
etitest = vertcat(eti1(ntrain+1:end), eti2(ntrain+1:end));% etiquetas para testeo

% Ordeno de forma aleatoria los ejemplos de entrenamiento
ordentrain = randperm(2*ntrain);
xtrain = xtrain(ordentrain,:);
etitrain = etitrain(ordentrain);

%% 2
% Implementaci√≥n perceptr√≥n simple
aprendizaje = 0.001;
toler = 0.01;
[etipercep, w] = perceptron(xtrain,etitrain,aprendizaje,toler);

x1train = xtrain(etipercep == eti1(1),:);
x2train = xtrain(etipercep == eti2(1),:);

figure
hold on
plot(x1train(:,1), x1train(:,2),'+b')
plot(x2train(:,1), x2train(:,2),'or')
plot(xtrain(etipercep~=etitrain,1), xtrain(etipercep~=etitrain,2),'.k')
plot([1 4],-(w(1)+w(2)*[1 4])./w(3),'k-')
legend('clase 1','clase 2','errores')
title('ClasificaciÛn con PerceptrÛn Simple')
axis equal
hold off



%% 3
% Implementar k-medias

