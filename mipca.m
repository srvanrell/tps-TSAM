function [PC, autoval] = mipca( X )
%MIPCA devuelve la matriz que permite proyectar los datos X sobre las
%direcciones obtenidas por medio del análisis de componentes principales.
% X es una matriz de D por N, donde cada observación se acomoda como
% columna. D es la dimensión de cada observación y N es el
% número total de observaciones.
%
% PC es la matriz de transformación de la base original a las direcciones
% principales. Las columnas son los versores de la nueva base.
%
% autoval es un vector con los autovalores asociados a PC, en orden 
% decreciente.

% Matriz de covarianza (internamente realiza la resta de la media)
S = cov(X'); % traspongo para que tome bien las observaciones

% Obtengo la matriz de autovectores y una matriz con los autovalores de S
[autovec, autoval] = eig(S);

% Ordeno la matriz de transformación por orden descendente de autovalores
PC = fliplr(autovec);

% Autovalores ordenados por módulo decreciente
autoval = flipdim(diag(autoval),1);

end

