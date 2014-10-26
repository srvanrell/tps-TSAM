function arbol = crecerArbol(datos, ejemplos, listaCaracteristicas)
%arbol = crecerArbol(datos, ejemplosAClasif, listaCaracteristicas)

arbol = {}; % arbol inicial vacío
nodosARevisar = [1];
nodo.ejemplos = ejemplos; % inicializo con todos los ejemplos
nodo.tipo = 'aRevisar';
arbol{1} = nodo;

while ~isempty(nodosARevisar)
    auxe = 1:14;
    nodo.id = nodosARevisar(1);
    ejemplos = auxe(arbol{nodosARevisar(1)}.ejemplos);
    
    fprintf('\nEn nodo %i reviso los ejemplos:\n',nodo.id)
    fprintf('%i, ',ejemplos)
    fprintf('\n')
    
    
% Genera una lista con las clases encontradas en los ejemplos
clasesEnEjemplos = datos(ejemplos,end); % lista con la clase de cada ejemplo
clases = unique(clasesEnEjemplos); % lista con las posibles clases

%% Si todos los ejemplos pertenecen a la misma clase creo un nodo hoja
if length(clases) == 1
    nodo.tipo = 'hoja';             % tipo de nodo
    nodo.clase = clases{1};         % clase del nodo hoja
    
    fprintf('nodo hoja, clase: %s\n', nodo.clase)

%% Si no son todos los ejemplos de la misma clase y no quedan 
%  caracteristicas para utilizar la clase se define por mayoria entre los 
%  ejemplos
elseif isempty(listaCaracteristicas)
    cuentaXclase = histClases(clasesEnEjemplos); % simil histograma
    [~, imax] = max(cuentaXclase);% indice de la clase mayoritaria
    nodo.clase = clases{imax};      % clase mayoritaria
    nodo.tipo = 'hoja';             % tipo de nodo
    
    fprintf('nodo hoja impuro, clase: %s\n', nodo.clase)

%% Si no son todos los ejemplos de la misma clase y se puede ramificar
%  se debe elegir que caracteristica utilizar
else
    nPadre = length(ejemplos);                  % ejemplos en el nodo padre
    iPadre = impureza(clasesEnEjemplos, 'ent'); % impureza del nodo padre
    deltaimax = 0; % variable auxiliar para encontrar la mejor ramificación
    
    % Para cada caracteristica candidata
    for lc = 1:length(listaCaracteristicas)
        decisionesCandidatas = unique(datos(ejemplos,lc));
        
        % diferencia entre caracteristicas con dos o más valores
        if length(decisionesCandidatas) == 2
            iterFinal = 1; 
        else
            iterFinal = length(decisionesCandidatas);
        end
        
        % Para cada valor posible de la caracteristica candidata se calcula
        % el deltai
        for dc = 1:iterFinal
            auxHijoSi = strcmp(decisionesCandidatas(dc), datos(ejemplos,lc));
            auxHijoNo = ~auxHijoSi;
            nHijoSi = sum(auxHijoSi);
            nHijoNo = sum(auxHijoNo);
            iHijoSi = impureza(clasesEnEjemplos(auxHijoSi), 'ent');
            iHijoNo = impureza(clasesEnEjemplos(auxHijoNo), 'ent');
            
            deltai = iPadre - (nHijoSi/nPadre) * iHijoSi - ...
                     (nHijoNo/nPadre) * iHijoNo;
                 
            if deltai > deltaimax
                deltaimax = deltai;
                
                nodo.tipo = 'divisor';                   % tipo de nodo
                nodo.pregunta = decisionesCandidatas{dc}; % pregunta utilizada
                nodo.HijoSi = length(arbol) + 1;
                nodo.HijoNo = length(arbol) + 2;
                nodoHijoSi.tipo = 'aRevisar';
                nodoHijoNo.tipo = 'aRevisar';
                nodoHijoSi.ejemplos = ejemplos(auxHijoSi);
                nodoHijoNo.ejemplos = ejemplos(auxHijoNo);
            end
        end
    end
    
    fprintf('nodo divisor en: %s\n', nodo.pregunta)
end   
    % Definido el nodo lo agrego al arbol
    arbol{nodosARevisar(1)} = nodo;
    
    % Si es un nodo divisor agrego los hijos a la lista para revisar
    if strcmp(nodo.tipo, 'divisor')
        arbol{nodo.HijoSi} = nodoHijoSi;
        arbol{nodo.HijoNo} = nodoHijoNo;
        nodosARevisar = [nodosARevisar nodo.HijoSi nodo.HijoNo];
    end
    nodosARevisar = setdiff(nodosARevisar, nodosARevisar(1));
    
    clear nodo nodoHijoSi nodoHijoNo; 
end

