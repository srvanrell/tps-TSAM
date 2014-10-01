function x = randgauss1D(mu, sigma, N)
%RANDGAUSSIAN genera un vector de numeros aleatorios con distribucion 
%gaussiana de media mu y varianza sigma. Los valores por defecto son mu =
%0, sigma = 1 y N = 1. El vector generado es vertical.

if nargin < 1
    mu = 0;
end
if nargin < 2
    sigma = 1;
end
if nargin < 3
    N = 1;
end

x = zeros(N,1);
for n=1:N
    x(n) = randgauss(mu,sigma);
end

end

