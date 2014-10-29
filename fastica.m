function [sepMat] = fastica( X )
%ICA devuelve la matriz de separación sepMat
% Los versores de la descomposición se ubican como columnas en la matriz
%
% 
% 
% REVISAR!!!!!!!!!!!!!!!!!!!!!!!!!!!
% que transforma los datos X de la base original a 
%la base obtenida por medio del análisis de componentes principales.
% X es una matriz de D por N, donde cada observación se acomoda como
% columna. D es la dimensión del espacio donde viven los datos y N es el
% número de observaciones.
%
% PC es la matriz de transformación de la base original a las direcciones
% principales. Las columnas son los versores de la nueva base.
% autoval es un vector con los autovalores asociados, en orden decreciente.



% Vector de descomposici�n
wnuevo = 2*rand(2,1)-1; % inicializaci�n aleatoria
wnuevo = wnuevo ./ norm(wnuevo);
w = [10; 10]; % valor para que entre en el while
errorLimite = 1e-6; 
optimizando = 0;
[N, M] = size(X); % N-dimensiones, M muestras

for p = 1:N
    error = 1;    % inicia el ciclo de optimización
    colineal = 0; % inicia el ciclo de optimización
    w(:,p) = 2*rand(N,1)-1; % inicialización aleatoria de wp
    
    while (error > errorLimite) && ~colineal
        want = w(:,p);
        
        % G(y) = (1/a) * log cosh (ay)
        % g(y) = tanh(ay)
        % gprima(y) = a(1-tanh(ay)^2)
        
        a = 1;
        g = ones(N,1) * tanh(a * want' * X) ; % g es de tamaño N x M
                                             % ones genera N filas iguales
                                             % de g evaluada en cada
                                             % a*want'*x
        gprima = a * (1 - tanh(a * want' * X).^2); % gprima es de tamaño 1 x M
        
        % Expresion para cada muestra
        % wnuevo = E[g(w'*x)*x] - E[gprima(w'*x)]*w
        % Expresion usando el vector X de todas las muestras
        w(:,p) = (-1) *(mean(g .* X, 2) - mean(gprima) * want);
        
%         size(X)
%         size(g)
%         size(g .* X)
        
        % El valor esperado es estimado por el valor medio
        % X * g' es el equivalente de g(w'*x)*x considerando todos los
        % ejemplos, antes de sacar la media
        
        % se ortogonaliza respecto a las wp ya encontradas
        for j = 1:p-1
            fprintf('antes = [%0.4f, %0.4f]. \n',w(:,p));
            w(:,p) = w(:,p) - (w(:,p)' * w(:,j)) * w(:,j);
            fprintf('despues = [%0.4f, %0.4f]. \n',w(:,p));
        end
        
        % se normaliza wp
        w(:,p) = w(:,p) ./ norm(w(:,p));
        
        error = norm(w(:,p) - want);
        colineal = (1 - abs(dot(want,w(:,p)))) < errorLimite;
        
        fprintf('w = [%0.4f, %0.4f]. ',w(:,p));
        fprintf('El error es %f\n',error);
        fprintf('Es colineal: %f\n',colineal);
%         pause

    end
    fprintf('Encontre w%i = [%0.4f, %0.4f]. \n',p,w(:,p));
%     pause
end

sepMat = w;

end

