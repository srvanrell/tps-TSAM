function sec = generarSec( A, ini, N )
%GenerarSec utiliza una cadena de Markov para generar una secuencia dada la
% matriz de transición, el vector de inicio y la cantidad de muestras.

sec(1) = 0; % Estado inicial, incierto.

% A continuación se define el primer estado
if rand() < ini(1)
    sec(1) = 1; % lluvioso
else
    sec(1) = 2; % soleado
end

for i = 2:N
    if rand() < A(sec(i-1),1)
        sec(i) = 1; % lluvioso
    else
        sec(i) = 2; % soleado
    end
end

