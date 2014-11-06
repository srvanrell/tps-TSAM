function [y, w] = perceptron( X, yd, alfa, tolerancia, iterMax)
%UNTITLED6 Summary of this function goes here
%   X son las caracteristicas, cada ejemplo en un renglon
%   yd es la salida deseada, la clase de cada ejemplo
%   alfa el coeficiente de aprendizaje
%   tolerancia de error admitida durante el entrenamiento
%   w es el vector de pesos aprendidos, el primer elemento es del bias, w0
if nargin < 3
    alfa = 0.05; % coef de aprendizaje
end
if nargin < 4
    tolerancia = 0.1; % tolerancia en el error de entrenamiento
end
if nargin < 5
    iterMax = 100; % tolerancia en el error de entrenamiento
end

N = size(X,1);
nCarac = size(X,2);

Xbias = [ones(N,1), X];
y = zeros(size(yd));

w = 0.5*rand(1,nCarac+1); % inicializo los pesos, incluido el del bias
error = 1;
iter = 0;

while (error > tolerancia) && (iter < iterMax)
    iter = iter + 1;
    for n = 1:N
        y(n) = sign( dot( w, Xbias(n,:) ) );% salida del perceptron para el ejemplo X(j)
        w = w + alfa * (yd(n) - y(n)) * Xbias(n,:); % ajuste de w, si d ~= y
    end
    error = norm(yd-y) / N;
end
iter

%Encontrado w actualizo las clases predichas
for n = 1:N
    y(n) = sign( dot( w, Xbias(n,:) ) );% salida del perceptron para el ejemplo X(j)
end

end

