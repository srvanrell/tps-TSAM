function [w, y, mu] = redfuncbaserad( X, yd, alfa, tolerancia, iterMax)
%[w, y] = redfuncbaserad( X, yd, alfa, tolerancia, iterMax) entrena una red
%neuronal con funciones de base radial.
%   X es una matriz de patrones donde cada uno se ubica en un renglon
%   yd es la salida deseada, la clase de cada ejemplo
%   alfa el coeficiente de aprendizaje
%   tolerancia de error admitida durante el entrenamiento
%   w es el vector de pesos aprendidos, el primer elemento es del bias, w0
%   y es el resultado de la clasificación de los patrones de entrenamiento
%   la cantidad de funciones utilizadas es igual a la de clases presentes
%   en yd
if nargin < 3
    alfa = 0.05; % coef de aprendizaje
end
if nargin < 4
    tolerancia = 0.1; % tolerancia en el error de entrenamiento
end
if nargin < 5
    iterMax = 100; % tolerancia en el error de entrenamiento
end

N = size(X,1);       % cantidad de patrones de entrenamiento
nCarac = size(X,2);  % cantidad de caracteristicas
y = zeros(size(yd)); % clasificacion de los patrones de entrenamiento

% inicialización de las medias de las gaussianas con k-medias
k = length(unique(yd)); % k igual a la cantidad de clases
[~, mu] = kmedias(X,k); % utilizo las medias

% considerando que las funciones de base radial son gaussianas con matriz
% de covarianza identidad, se definen como:
phi = @(xn,muj) exp(-0.5 * norm( xn-muj ).^2);

% de cada patron obtengo nuevas características por medio de las gaussianas
Xnuevas = zeros(N,k); % nuevas caracteristicas
for n = 1:N
    for j = 1:k
        Xnuevas(n,j) = phi(X(n,:),mu(j,:));
    end
end

% ahora entreno un perceptron simple con las nuevas caracteristicas
w = perceptron(Xnuevas,yd,alfa,tolerancia,iterMax);

% clasifico los patrones de entrenamiento
y = sign([ones(N,1) Xnuevas] * w');

end

