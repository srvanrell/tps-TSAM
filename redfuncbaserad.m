function [w, y] = redfuncbaserad( X, yd, alfa, tolerancia, iterMax)
%[w, y] = redfuncbaserad( X, yd, alfa, tolerancia, iterMax) entrena una red
%neuronal con funciones de base radial.
%   X es una matriz de patrones donde cada uno se ubica en un renglon
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

N = size(X,1);
nCarac = size(X,2);
y = zeros(size(yd));

% inicialización de los centroides de las funciones con k-medias
k = length(unique(yd));
[~, mu] = kmedias(X,k)

% % actualización de los centroides
% for j = 1:k
%     for n = 1:N
%         mu(j,:) = mu(j,:) + alfa * (X(n,:) - mu(j,:));
%     end
% end

% inicializacion aleatoria de los pesos
w = rand(1,k);

% considerando que las funciones de base radial son gaussianas con matriz
% de covarianza unitaria
phi = @(n,j) exp(-0.5 * norm( X(n,:)-mu(j,:) ).^2) ;

for n = 1:N
    for j = 1:k
        wi = w;
        for i = 1:k
            w = w - alfa * ( wi(i,:)*phi(n,i) - yd(n) ) * phi(n,j);
        end
    end
end





end

