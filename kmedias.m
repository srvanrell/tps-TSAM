function [y, med] = kmedias( X, k, tolerancia, iterMax)
%[y, med] = kmedias( X, k, tolerancia, iterMax) agrupa los patrones X en k
%grupos. Devuelve la media de los grupos en med y el grupo asignado a cada
%patron en y.
%   X contiene los patrones, uno en cada renglon
%   k define la cantidad de grupos a utilizar
%   y grupo asignado a cada patron
%   med media de cada grupo por renglon
%   tolerancia para definir la convergencia de las medias
%   iterMax limita los ciclos posibles para ajustar la media
if nargin < 3
    tolerancia = 0.001; % tolerancia en la convergencia de las medias
end
if nargin < 4
    iterMax = 100; % tolerancia en el error de entrenamiento
end

N = size(X,1);         % cantidad de patrones
nCarac = size(X,2);
med = zeros(k,nCarac);
y = zeros(N,1);
grupo = cell(k,1);

% inicialización, asigno grupos al azar y en igual cantidad
indices = randperm(N); % orden arbitrario de los indices
Nini = floor(N/k); % cantidad de patrones en cada grupo

iter = 0;
cambio = 100;
while (iter < iterMax) && cambio > tolerancia
    iter = iter +1;
    
    % asignación de grupos
    if iter == 1
        % en la iteración inicial asigno arbitrariamente
        for g = 1:k
            if g == k
                grupo{g} = indices(1+Nini*(k-1):end);
            else
                grupo{g} = indices(1+Nini*(g-1):Nini*g);
            end
        end
    else
        % en las restantes iteraciones asigno cada patron al centroide mas 
        % cercano
        grupo = cell(k,1); % olvido los grupos del paso previo
        for n = 1:N
            for g = 1:k
                distancias(g) = norm( X(n,:) - med(g,:) );
            end
            [~, gmin] = min(distancias);
            grupo{gmin} = [grupo{gmin} n];
        end
    end
    
    % actualización de medias
    medAnteriores = med; % reservo las medias anteriores
    for g = 1:k
        med(g,:) = mean(X(grupo{g},:),1); % nuevas medias
        y(grupo{g})=g; % asignaciones de cada patron a cada grupo
    end
    cambio = norm(med - medAnteriores);
end

end

