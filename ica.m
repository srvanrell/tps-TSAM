function [sepMat] = ica( X )
%ICA devuelve la matriz de separación
% 
% 
% REVISAR!!!!!!!!!!!!!!!!!!!!!!!!!!!
% que transforma los datos X de la base original a 
%la base obtenida por medio del análisis de componentes principales.
% X es una matriz de D por N, donde cada observación se acomoda como
% columna. D es la dimensión del espacio donde viven los datos y N es el
% número de observaciones.
%
% PC es la matriz de transformación de la base original a las direcciones
% principales. Las columnas son los versores de la nueva base.
% autoval es un vector con los autovalores asociados, en orden decreciente.


% Matriz de covarianza (internamente realiza la resta de la media)
S = cov(X'); % traspongo para que tome bien las observaciones

% Obtengo la matriz de autovectores y una matriz con los autovalores de S
[autovec, autoval] = eig(S);

% Ordeno la matriz de transformación por orden descendente de autovalores
PC = flipud(autovec);

% Autovalores ordenados por módulo decreciente
autoval = flipdim(diag(autoval),1);

end

