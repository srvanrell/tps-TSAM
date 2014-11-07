function H = entropia( x )
%entropia(x) dada una señal x, devuelve una estimacion de la entropía
%medida en nats.

[alturas, centros] = hist(x, 30);   % histograma sin normalizar
ancho = centros(2) - centros(1);    % ancho de las barras del histograma
alturas = alturas(alturas>0);
area  = sum(ancho .* alturas);      % area de las barras del histograma
fdpexp = alturas/area;              % fdp experimental
% bar(centros, fdpexp,'b');         % dibuja histograma normalizado

H = - sum( fdpexp * ancho .* log(fdpexp) ) - log(ancho);

end

