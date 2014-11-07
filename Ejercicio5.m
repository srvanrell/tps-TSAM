%% Ejercicio 5 - Aprendizaje basado en redes y algoritmos clÃ¡sicos
clc; clear all; close all;

%% Ejercicio 5.1
% Genere un conjunto de datos aleatorios bidimensionales separados en dos
% clases gaussianas correlacionadas con cierto grado de solapamiento.

N = 200; % cantidad de muestras

mu1 = [1 2];                % media clase 1 (+)
sigma1 = [0.9 0.3; 0.3 1.7];  % covarianza clase 1 (+)
mu2 = [4 4];                  % media clase 2 (o)
sigma2 = [1.5 -0.7; -0.7  3]; % covarianza clase 2 (o)

x1 = mvnrnd(mu1, sigma1, N); % ejemplos de la clase 1 (+)
x2 = mvnrnd(mu2, sigma2, N); % ejemplos de la clase 2 (o)
eti1 = ones(N,1);            % etiquetas de los ejemplos de la clase 1 (+)
eti2 = (-1)*ones(N,1);       % etiquetas de los ejemplos de la clase 2 (o)

% Graficacion de las distribuciones
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

% ejemplos de entrenamiento
xentre = vertcat(x1(1:nentre,:), x2(1:nentre,:));
% etiquetas para entrenamiento supervisado
etientre = vertcat(eti1(1:nentre), eti2(1:nentre));
% ejemplos de testeo
xtest = vertcat(x1(nentre+1:end,:), x2(nentre+1:end,:));
% etiquetas para testeo
etitest = vertcat(eti1(nentre+1:end), eti2(nentre+1:end));

% Ordeno de forma aleatoria los ejemplos de entrenamiento
ordenentre = randperm(2*nentre);
xentre = xentre(ordenentre,:);
etientre = etientre(ordenentre);


%% Ejercicio 5.2
% Implemente el algoritmo de entrenamiento de un perceptron simple y 
% pruebelo con los datos anteriores, grafique los resultados obtenidos.

%% perceptron.m
dbtype perceptron.m

aprendizaje = 0.001; % coeficiente de aprendizaje
toler = 0.01;        % error tolerado en el entrenamiento
% entrenamiento
w = perceptron(xentre,etientre,aprendizaje,toler);
% testeo
etipercep = sign([ones(2*ntest,1) xtest] * w');

x1test = xtest(etipercep == eti1(1),:);%patrones identificados como clase 1
x2test = xtest(etipercep == eti2(1),:);%patrones identificados como clase 2

figure
hold on
plot(x1test(:,1), x1test(:,2),'+b')
plot(x2test(:,1), x2test(:,2),'or')
plot(xtest(etipercep~=etitest,1), xtest(etipercep~=etitest,2),'.k')
plot([1.5 4],-(w(1)+w(2)*[1.5 4])./w(3),'k-')
legend('clase 1','clase 2','errores')
title('Clasificación con Perceptron Simple')
xlabel('x_1'); ylabel('x_2');
axis equal
hold off

errorpercep = sum(etipercep~=etitest) / ntest;


%% Ejercicio 5.3
% Implemente el algoritmo de aprendizaje no supervisado k-medias (batch) y
% pruebelo con los datos anteriores, grafique los resultados obtenidos.

%% kmedias.m
dbtype kmedias.m

[etikmed, med] = kmedias(xentre,2);

xAentre = xentre(etikmed == 1,:); %patrones asignados al grupo A
xBentre = xentre(etikmed == 2,:); %patrones asignados al grupo B

figure
hold on
plot(xAentre(:,1), xAentre(:,2),'xb')
plot(xBentre(:,1), xBentre(:,2),'dr')
plot(med(1,1),med(1,2),'*k')
plot(med(2,1),med(2,2),'*k')
legend('grupo A','grupo B','medias')
title('Agrupamiento con k-medias')
xlabel('x_1'); ylabel('x_2');
axis equal
hold off


%% Ejercicio 5.4
% Implemente el algoritmo de aprendizaje de las redes neuronales con 
% funciones de base radial y pruebelo con los datos anteriores, grafique 
% los resultados obtenidos.

%% redfuncbaserad.m
dbtype redfuncbaserad.m

%% funcbr.m
dbtype funcbr.m

aprendizaje = 0.005; % coeficiente de aprendizaje
toler = 0.01;        % error tolerado en el entrenamiento
% entrenamiento
[w,~,mu] = redfuncbaserad(xentre,etientre,aprendizaje,toler);
% testeo
etirnfbr = sign([ones(2*ntest,1) funcbr(xtest,mu)] * w');

x1test = xtest(etirnfbr == eti1(1),:);%patrones identificados como clase 1
x2test = xtest(etirnfbr == eti2(1),:);%patrones identificados como clase 2

figure
hold on
plot(x1test(:,1), x1test(:,2),'+b')
plot(x2test(:,1), x2test(:,2),'or')
plot(xtest(etirnfbr~=etitest,1), xtest(etirnfbr~=etitest,2),'.k')
% plot([1 4],-(w(1)+w(2)*[1 4])./w(3),'k-')
legend('clase 1','clase 2','errores')
title('Clasificación con Red Neuronal de Funciones de Base Radial')
xlabel('x_1'); ylabel('x_2');
axis equal
hold off

errorrnfbr = sum(etirnfbr~=etitest) / ntest;

%% Ejercicio 5.5
% 5. Implemente el algoritmo de los k-vecinos más cercanos y pruebelo con 
% los datos anteriores, grafique los resultados obtenidos.

%% kvecinos.m
dbtype kvecinos.m

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

errorkvec = sum(etikvec~=etitest) / ntest;

%% Ejercicio 5.6. 
% Compare y comente los resultados obtenidos por los distintos métodos.

%%
% Considerando los mismos grupos de testeo y entrenamiento los resultados
% durante el testeo fueron los siguientes:

fprintf('Tasa de error para el perceptron: %0.2f %%\n',100 * errorpercep);
fprintf('Tasa de error para la rn-fbr: %0.2f %%\n',100 * errorrnfbr);
fprintf('Tasa de error para el k-vecinos: %0.2f %%\n',100 * errorkvec);

%% ANALIZAR EN EL TEX
