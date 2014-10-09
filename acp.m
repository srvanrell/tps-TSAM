function [PD, autoval] = acp( X )
%ACP devuelve la matriz que transforma los datos X de la base original a la
%base obtenida por medio del analisi de componentes principales.
% X es una matriz de d por n, donde cada observacion se acomoda como
% columna. d es la dimension del espacio donde viven los datos y n es el
% numero de observaciones.
% PD es la matriz de transformacion de la base original a las direcciones
% principales. Los renglones son los vectores de la nueva base.
% autoval es un vector con los autovalores asociados en orden decreciente.

% Matriz de covarianza (como debe, internamente resta la media)
S = cov(X'); % traspongo para que tome bien las observaciones

% Obtengo la matriz de autovectores y una matriz con los autovalores de S
[autovec, autoval] = eig(S);

% Ordeno la matriz de transformacion por orden descendente de autovalores
PD = flipud(autovec);
% Autovalores ordenados en orden decendente
autoval = diag(rot90(autoval,2));

end

