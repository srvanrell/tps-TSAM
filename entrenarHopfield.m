function  W = entrenarHopfield( X )
%[y, W] = entrenarHopfield( X )
%   Cada renglon de X es un patron que se desea almacenar

N = size(X,2); % Longitud de cada patron
m = size(X,1); % Cantidad de patrones

% Entrenamiento Hebbiano
% W = x1' * x1 + x2' * x2 + ... + xm' * xm - m * I
% o lo que es igual
W = X' * X - m * eye(N);

end

