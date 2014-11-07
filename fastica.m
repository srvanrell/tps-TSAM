function [sepMat] = fastica( X )
%[sepMat] = fastica( X ) devuelve la matriz de separación sepMat
%   Los versores de la descomposición se ubican como columnas en la matriz
%   de separación.
%   Las mezclas X deben ser de tamaño N x M, donde N corresponde a la
%   cantidad de mezclas y M a la cantidad de muestras que tiene cada señal.
%   Las mezclas en X deben tener media cero y la matriz de covarianza debe
%   ser identidad (realizar whitening de ser necesario)

tolerancia = 1e-6; 
optimizando = 0;  %
[N, M] = size(X); % N-dimensiones, M muestras

for p = 1:N
    error = 1;    % inicia el ciclo de optimización
    colineal = 0; % inicia el ciclo de optimización
    w(:,p) = 2*rand(N,1)-1; % inicialización aleatoria de wp
    
    while (error > tolerancia) && ~colineal
        want = w(:,p);
        
        % G(y) = (1/a) * log cosh (ay)
        % g(y) = tanh(ay)
        % gprima(y) = a(1-tanh(ay)^2)
        a = 1;
        g = ones(N,1) * tanh(a * want' * X) ;% g es de tamaño N x M
                                             % ones genera N filas iguales
                                             % de g evaluada en cada
                                             % a*want'*x
        gprima = a * (1 - tanh(a * want' * X).^2); % gprima es de tamaño 1 x M
        
        % Expresion para cada muestra
        % wnuevo = E[g(w'*x)*x] - E[gprima(w'*x)]*w
        % Expresion usando el vector X de todas las muestras
        w(:,p) = (-1) *(mean(g .* X, 2) - mean(gprima) * want);
             
        % El valor esperado de la ecuación original es estimado por el 
        % valor medio
        % g .* X es el equivalente de g(w'*x)*x considerando todos los
        % ejemplos
        
        % se ortogonaliza respecto a las wp ya encontradas
        for j = 1:p-1
            w(:,p) = w(:,p) - (w(:,p)' * w(:,j)) * w(:,j);
        end
        
        % se normaliza wp
        w(:,p) = w(:,p) ./ norm(w(:,p));
        
        error = norm(w(:,p) - want); % chequea convergencia de w(:,p)
        colineal = (1-abs(dot(want,w(:,p)))) < tolerancia; % si es colineal
                                                           % finalizo la
                                                           % búsqueda
    end
end

sepMat = w; % encontrados todos los wp los paso a la salida de la función

end

