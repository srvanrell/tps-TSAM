%% Ejercicio 5
% Aprendizaje basado en redes y algoritmos clÃ¡sicos
clc; clear all; close all;
%% 1
% Genere un conjunto de datos aleatorios bidimensionales...

N = 200; % cantidad de muestras

mu1 = [1 1.5];
sigma1 = [0.5 0.3;
          0.3 1.7];

mu2 = [4 4];
sigma2 = [1.2 -0.7;
          -0.7  3];

x1 = mvnrnd(mu1, sigma1, N); % ejemplos de la clase 1 (+)
x2 = mvnrnd(mu2, sigma2, N); % ejemplos de la clase 2 (o)
eti1 = ones(N,1);            % etiquetas de los ejemplos de la clase 1 (+)
eti2 = (-1)*ones(N,1);       % etiquetas de los ejemplos de la clase 2 (o)


hold on
plot(x1(:,1), x1(:,2),'+b')
plot(x2(:,1), x2(:,2),'or')
legend('clase 1','clase 2')
title('Distribuciones de los patrones')
xlabel('x_1'); ylabel('x_2');
axis equal
hold off


% Separacion entre entrenamiento y testeo, a utilizar cuando corresponda
nentre = floor(0.7 * N); % 70% de los patrones para entrenamiento
ntest = N - nentre;      % 30% de los patronespara testeo

xentre = vertcat(x1(1:nentre,:), x2(1:nentre,:)); % ejemplos de entrenamiento
etientre = vertcat(eti1(1:nentre), eti2(1:nentre));% etiquetas para entrenamiento supervisado
xtest = vertcat(x1(nentre+1:end,:), x2(nentre+1:end,:)); % ejemplos de testeo
etitest = vertcat(eti1(nentre+1:end), eti2(nentre+1:end));% etiquetas para testeo

% Ordeno de forma aleatoria los ejemplos de entrenamiento
ordenentre = randperm(2*nentre);
xentre = xentre(ordenentre,:);
etientre = etientre(ordenentre);

%% 2
% ImplementaciÃ³n perceptrÃ³n simple
aprendizaje = 0.001;
toler = 0.01;
% entrenamiento
w = perceptron(xentre,etientre,aprendizaje,toler);
% testeo
etipercep = sign([ones(2*ntest,1) xtest] * w');

x1test = xtest(etipercep == eti1(1),:);
x2test = xtest(etipercep == eti2(1),:);

figure
hold on
plot(x1test(:,1), x1test(:,2),'+b')
plot(x2test(:,1), x2test(:,2),'or')
plot(xtest(etipercep~=etitest,1), xtest(etipercep~=etitest,2),'.k')
plot([1 4],-(w(1)+w(2)*[1 4])./w(3),'k-')
legend('clase 1','clase 2','errores')
title('Clasificación con Perceptrón Simple')
xlabel('x_1'); ylabel('x_2');
axis equal
hold off

errorpercep = sum(etipercep~=etitest) / ntest

%% 3
% Implementar k-medias

[etikmed, med] = kmedias(xentre,2);

x1entre = xentre(etikmed == 1,:);
x2entre = xentre(etikmed == 2,:);

figure
hold on
plot(x1entre(:,1), x1entre(:,2),'+b')
plot(x2entre(:,1), x2entre(:,2),'or')
plot(med(1,1),med(1,2),'*k')
plot(med(2,1),med(2,2),'*k')
legend('grupo 1','grupo 2','medias')
title('Agrupamiento con k-medias')
xlabel('x_1'); ylabel('x_2');
axis equal
hold off


%% 5
% Implemente el algoritmo de los k-vecinos más cercanos
k = 10;
etikvec = kvecinos(xtest,k,xentre, etientre);

x1test = xtest(etikvec == eti1(1),:);
x2test = xtest(etikvec == eti2(1),:);

figure
hold on
plot(x1test(:,1), x1test(:,2),'+b')
plot(x2test(:,1), x2test(:,2),'or')
plot(xtest(etikvec~=etitest,1), xtest(etikvec~=etitest,2),'.k')
legend('clase 1','clase 2','errores')
title(['Clasificación con k-vecinos más cercanos (k=' num2str(k) ')'])
xlabel('x_1'); ylabel('x_2');
axis equal
hold off

errorkvec = sum(etikvec~=etitest) / ntest