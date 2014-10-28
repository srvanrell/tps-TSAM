function [sepMat] = fastica( Y )
%ICA devuelve la matriz de separación W
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



sepMat = cov(Y');

end

