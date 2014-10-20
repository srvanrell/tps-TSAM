function x = randgauss1D(mu, sigma, N)
%RANDGAUSS1D(mu, sigma, N) genera un vector de números aleatorios con 
%distribución gaussiana de media mu y desvío sigma. Los valores por defecto
%son mu = 0, sigma = 1 y N = 1. El vector x es vertical (de tamaño N x 1).

if nargin < 1
    mu = 0;    % media por defecto
end
if nargin < 2
    sigma = 1; % desvío por defecto
end
if nargin < 3
    N = 1;     % tamaño por defecto
end

x = zeros(N,1); % inicializo
for n = 1:N
    x(n) = randgauss(); % relleno el vector
end
x = mu + sigma .* x; % ajusto a mu y sigma

end

