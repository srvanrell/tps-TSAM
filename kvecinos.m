function Cdesc = kvecinos( Xdesc, k, Xcon, Ccon )
%Cdesc = kvecinos( Xdesc, k, Xcon, Ccon ) clasifica los patrones
%desconocidos a partir de los k vecinos más cercanos conocidos.
%   Xdesc son los patrones a clasificar, cada uno en un renglon
%   k es la cantidad de vecinos a buscar para asignar la clase
%   Xcon son los patrones de clase conocida dada en Ccon
%   Xcon tiene cada patron por renglon, y cada elemento de Ccon está
%   asociado al patrón de Xcon que se ubicado en igual posición.

Ndesc = size(Xdesc,1);  % cantidad de patrones desconocidos
Ncon = size(Xcon,1);    % cantidad de patrones conocidos
Cdesc = zeros(Ndesc,1); % clases asignadas a los patrones no vistos

distancias = zeros(Ncon,1);
% A cada patron no visto le asigno su clase
for nd = 1:Ndesc
    % Se calcula la distancia contra todos los conocidos
    for nc = 1:Ncon
        distancias(nc) = norm( Xcon(nc,:) - Xdesc(nd,:) );
    end
    
    % se ordenan las distancias de menor a mayor
    [~, orden] = sort(distancias); 
    
    % se listan las clases de los k vecinos mas cercanos
    kvecclases = Ccon(orden(1:k)); % clases de cada uno de los k vecinos
    clases = unique(kvecclases);    % clases posibles entre los k vecinos
    cuenta = zeros(size(clases));  % cuantos patrones hay de cada clase?
    for c = 1:length(clases)
        cuenta(c) = sum(clases(c) == kvecclases);
    end
    [~, cmax] = max(cuenta); % clase con mayor presencia entre los k
    
    Cdesc(nd) = clases(cmax);% asignación de clase al patron desconocido n
end

end

