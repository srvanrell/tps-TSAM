function  W = entrenarHopfield( X )
% W = entrenarHopfield( X )
%   X es una matriz donde cada renglón es un patrón que se desea almacenar.
%   W es la matriz de pesos de la red de Hopfield. Dado un patrón, recuerda
%     cuales elementos se [des]activaron simultáneamente. 

N = size(X,2); % Longitud de cada patron
m = size(X,1); % Cantidad de patrones

% Entrenamiento Hebbiano
% W = x1' * x1 + x2' * x2 + ... + xm' * xm - m * I
% La expresión anterior es euivalente a la siguiente
W = X' * X - m * eye(N);

end

