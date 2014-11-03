function [sec, est] = generarMOMSec( A, B, ini, N )
% GenerarMOMSec utiliza un Modelo Oculto de Markov para generar una 
% secuencia dada la matriz de transición, el vector de inicio y la cantidad
% de muestras.

est(1) = 0; % Estado inicial, incierto.

% A continuación se define el primer estado
if rand() < ini(1)
    est(1) = 1; % lluvioso
else
    est(1) = 2; % soleado
end

for i = 2:N
    if rand() < A(est(i-1),1)
        est(i) = 1; % lluvioso
    else
        est(i) = 2; % soleado
    end
end

sec = zeros(size(est));
for i = 1:N
    auxlim = cumsum(B(:,est(i)));
    auxrand = rand();
    j = 1;
    while auxrand > auxlim(j)
        j = j + 1;
    end
    sec(i) = j;
end
    
end

