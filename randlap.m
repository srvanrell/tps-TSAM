function x = randlap(N, mu, beta)
%randlap(N, mu, beta) genera N numeros aleatorios provenientes de una
%distribucion laplaciana con parametros mu y beta.
%
% Para ello se utiliza la inversa de la funcion de distribucion acumulada 
% laplaciana, porque permite transformar numeros de una distribucion 
% uniforme en (0, 1) a numeros de una distribucion laplaciana en (-inf inf)

p = rand(N,1); % p se distribuye uniformemente en (0, 1)

% la inversa de la funcion de distribucion acumulada laplaciana dice que: 
% si p >= 0.5 => x = mu - beta * ln( 2 * (1 - p) )
% si p <  0.5 => x = mu + beta * ln( 2 * p )

% se obtiene una nueva variable aleatoria q, uniforme en (-1, +1)
q = -1 + 2 .* p; 

% ahora x puede expresarse sinteticamente como:
x = mu + sign(q) .* beta .* log(1 - abs(q));

end

