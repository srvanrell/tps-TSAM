function x = randgauss(mu, sigma)
%RANDGAUSSIAN genera un numero aleatorio con distribucion gaussiana de 
%media mu y varianza sigma. Los valores por defecto son mu = 0 y sigma = 1.

if nargin < 1
    mu = 0;
end
if nargin < 2
    sigma = 1;
end

s=1;
while s >= 1
% x1 y x2 son variables aleatorias uniformes e independientes en (-1, +1)
    x1 = 2.0 * rand() - 1.0;
    x2 = 2.0 * rand() - 1.0; 

    s = x1 .* x1 + x2 .* x2;  % nueva variable aleatoria uniforme en (0, 1)
end

% variable aleatoria de una distribucion normal
x = x1 .* sqrt( (-2.0 .* log( s ) ) ./ s ); 

% variable aleatoria de la distribucion gaussiana indicada
x = x .* sigma + mu;

end

