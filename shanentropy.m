function H = shanentropy( x )
%shanentropy(x) dada una señal x, devuelve una estimacion de la entropía
%medida en nats.

% estimador de una fdp, es decir una fdp empirica
[fdp, xi] = ksdensity(x);
% me devuelve un vector con la funcion fdp estimada evaluada en los puntos
% xi. Son 100 valores.

% factor (separación entre xi) para que la fdp realmente sea una fdp 
dxi = xi(2)-xi(1);

% entropia calculada a partir de la fdp empirica
H = - sum( dxi.*fdp .* log(fdp.*dxi) );

end

