function [w, y] = perceptron( X, yd, alfa, tolerancia, iterMax)
% [w, y] = perceptron( X, yd, alfa, tolerancia, iterMax) entrena un 
% perceptron a partir de los patrones X y sus clases conocidas yd.
%   X son las caracteristicas, cada ejemplo en un renglon
%   yd es la salida deseada, la clase de cada ejemplo
%   alfa el coeficiente de aprendizaje
%   tolerancia de error admitida durante el entrenamiento
%   w es el vector de pesos aprendidos, el primer elemento es del bias, w0
%   y es el resultado de la clasificación de los patrones de entrenamiento 
if nargin < 3
    alfa = 0.05; % coef de aprendizaje
end
if nargin < 4
    tolerancia = 0.1; % tolerancia en el error de entrenamiento
end
if nargin < 5
    iterMax = 100; % tolerancia en el error de entrenamiento
end

N = size(X,1);          % cantidad de patrones de entrenamiento
nCarac = size(X,2);     % cantidad de caracteristicas

Xbias = [ones(N,1), X]; % agrego unos para entrenar bias
y = zeros(size(yd));    % clasificacion de los patrones de entrenamiento

w = 0.5*rand(1,nCarac+1); % inicializo los pesos, incluido el del bias
error = 1;
iter = 0;

while (error > tolerancia) && (iter < iterMax)
    iter = iter + 1;
    for n = 1:N
        % salida del perceptron para el patron X(j)
        y(n) = sign( dot( w, Xbias(n,:) ) );
        w = w + alfa * (yd(n) - y(n)) * Xbias(n,:); % ajuste de w
    end
    error = norm(yd-y) / N;
end

% Actualizo la clasificacion para los patrones de entrenamiento
y = sign(Xbias * w');
end