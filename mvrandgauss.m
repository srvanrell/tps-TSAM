function x = mvrandgauss(MU, SIGMA)
%MVRANDGAUSS genera un número aleatorio de dimension D proveniente de una 
% distribucion gaussiana multidimensional, cuyas medias quedan definidas
% por el vector MU (horizontal, de tamaño D x 1) y la matriz de covarianza 
% SIGMA (cuadrada, de tamaño D x D)
% Los valores por defecto son MU = 0 y SIGMA = matriz identidad.

if nargin < 1
    MU = 0;
end
if nargin < 2
    SIGMA = eye(length(MU));
end
D = size(SIGMA,1);

if (size(MU,2) ~= D) || (size(MU,1) ~= 1) || (D ~= size(SIGMA,2))
   error(message('Error en los tamaños de MU o SIGMA'));
end

% Como SIGMA es definida positiva puede usarse la descomposición de Cholesky 
triangSup = chol(SIGMA); % SIGMA = triangSup' * triangSup

% z es un número aleatorio normal estándar de tamaño 1 x D
z = randgauss1D(0,1,D)';  % E[z' * z] = I

x = z * triangSup + MU;

% Demostración de que la expresión anterior devuelve el resultado esperado
% -------------------------------------------------------------------------
% Si se toma x = z * triangSup se cumple que:
% E[x' * x] = E[(z * triangSup)' * (z * triangSup)]
%           = E[ triangSup' * z' * z * triangSup ]
%           = triangSup' * E[ z' * z ] * triangSup
%           = triangSup' * I * triangSup
%           = triangSup' * triangSup
%           = SIGMA
% Entonces z * triangSup cumple con la matriz de covarianza dada SIGMA
% Por último desplazo la distribucion con MU sin alterar  E[x' * x]

end