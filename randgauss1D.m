function x = randgauss1D(mu, sigma, N)
%RANDGAUSS1D(mu, sigma, N) genera un vector de n�meros aleatorios con 
%distribuci�n gaussiana de media mu y desvio sigma. Los valores por defecto
%son mu = 0, sigma = 1 y N = 1. El vector x es vertical (de tama�o N x 1).

if nargin < 1
    mu = 0;    % media por defecto
end
if nargin < 2
    sigma = 1; % desv�o por defecto
end
if nargin < 3
    N = 1;     % tama�o por defecto
end

x = zeros(N,1); % inicializo
for n = 1:N
    x(n) = randgauss(); % relleno el vector
end
x = mu + sigma .* x; % ajusto a mu y sigma

end

