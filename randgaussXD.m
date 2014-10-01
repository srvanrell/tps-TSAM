function x = randgaussXD(MU, SIGMA)
%RANDGAUSSIANXD genera un numero aleatorio de dimension dim con 
%distribucion gaussiana multidimensional de vector vertical de media mu y 
%matriz de covarianza sigma. Los valores por defecto son mu =
%0, sigma = 1 y N = 1.

if nargin < 1
    MU = 0;
end
if nargin < 2
    SIGMA = 1;
end

triangSup = chol(SIGMA);
z = randgauss1D(0,1,size(SIGMA,1));
z = z'; % para que sea horizontal y multiplicarlo por la matriz triangSup
x = z * triangSup + MU;
end

