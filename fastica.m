function [sepMat] = fastica( X )
%ICA devuelve la matriz de separación W
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
errorLimite = 1e-9; 
optimizando = 0;
[N, M] = size(X); % N-dimensiones, M muestras

for p = 1:N
    error = 1; % inicia el ciclo de optimizaci�n
    w(:,p) = rand(N,1)-0.5; % inicializaci�n aleatoria de wp
    
    while error > errorLimite
        % for i = 1:5
        want = w(:,p);
        
        % G(y) = (1/a) * log cosh (ay)
        % g(y) = tanh(ay)
        % gprima(y) = a(1-tanh(ay)^2)
        
        a = 1;
        g = tanh(a * want' * X); % g es de tama�o 1 x M
        gprima = a * (1 - tanh(a * want' * X).^2); % gprima es de tama�o 1 x M
        
        % wnuevo = E[gprima(w'*x)]* w - E[g(w'*x)*x]
        w(:,p) = -1 *( mean(gprima) * want - mean(X * g'));
        % El valor esperado es estimado por el valor medio
        % X * g' es el equivalente de g(w'*x)*x considerando todos los
        % ejemplos, antes de sacar la media
        
        % se ortogonaliza respecto a las wp ya encontradas
        for j = 1:p-1
            disp('entre')
            fprintf('antes = [%0.4f, %0.4f]. \n',w(:,p));
            w(:,p) = w(:,p) - (w(:,p)' * w(:,j)) * w(:,j);
            fprintf('despues = [%0.4f, %0.4f]. \n',w(:,p));
        end
        
        % se normaliza wp
        w(:,p) = w(:,p) ./ norm(w(:,p));
        
        error = norm(w(:,p) - want);
        fprintf('w = [%0.4f, %0.4f]. ',w(:,p));
        fprintf('El error es %f\n',error);
        pause
    end
    pause
    fprintf('Encontre w%i = [%0.4f, %0.4f]. \n',p,w(:,p));
end

sepMat = cov(X');

end

