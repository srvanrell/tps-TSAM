function arbol = crecerArbol(datos, ejemplos, listaCaracteristicas,...
                             tipoImpureza, debugging)
%
%

if (nargin < 2) || isempty(ejemplos)
    n1.ejemplos = 1:size(datos,1); % inicializo con todos los ejemplos
else
    n1.ejemplos = ejemplos; % inicializo con los ejemplos dados
end
if (nargin < 3) || isempty(listaCaracteristicas)
    auxc = 1:(size(datos,2)-1); % todas las caracteristicas
    listaCaracteristicas = sprintf('Atributo%i ',auxc);
    listaCaracteristicas = strsplit(listaCaracteristicas(1:end-1));
end
if (nargin < 4) || isempty(tipoImpureza)
    tipoImpureza = 'ent'; % calcula impureza por entropia
end
if nargin < 5
    debugging = false; % Por defecto no imprime por pantalla
end


n1.id = 1;                     % id del nodo raiz
nodosARevisar = n1.id;         % el primer nodo a revisar es el nodo raiz
n1.tipo = 'aRevisar';          % tipo provisorio
arbol{1} = n1;                 % arbol inicial con nodo raiz

% mientras queden nodos por revisar
while ~isempty(nodosARevisar)
    % Reviso el siguiente nodo de la lista
    nodo.id = nodosARevisar(1);
    % enumero los ejemplos que le corresponden 
    ejemplos = arbol{nodosARevisar(1)}.ejemplos;
    
    % Genera una lista con las clases encontradas en los ejemplos
    clasesPorEjemplo = datos(ejemplos,end); %lista la clase de cada ejemplo
    clases = unique(clasesPorEjemplo);      %lista con las posibles clases

    %% Si todos los ejemplos pertenecen a la misma clase creo un nodo hoja
    if length(clases) == 1
        nodo.tipo = 'hoja';             % tipo de nodo
        nodo.clase = clases{1};         % clase del nodo hoja

    %% Si no son todos los ejemplos de la misma clase se debe elegir que 
    %  caracteristica utilizar
    else
        % Cantidad de ejemplos e impureza del nodo padre
        nPadre = length(ejemplos);                 
        iPadre = impureza(clasesPorEjemplo, tipoImpureza); 
        deltaimax = 0; %variable auxiliar para buscar la mejor ramificaci�n
        nodo.tipo = 'sinAsignar'; % etiqueta de control interno
        
        % Para cada caracteristica candidata
        for lc = 1:length(listaCaracteristicas)
            % si las caracteristicas son num�ricas
            auxcarac = horzcat(datos{ejemplos,lc});
            esNumerica = isnumeric(auxcarac);
            
            % exploro las alternativas de cada caracteristica
            if esNumerica
                % si es num�rica genero los candidatos ordenando por valor
                % y tomando el valor medio en cada salto de clase
                [valor, orden] = sort(horzcat(datos{ejemplos,lc}));
                clasesOrdenadas = clasesPorEjemplo(orden);
                decisionesCandidatas = [];
                for co = 2:length(clasesOrdenadas)
                    if ~strcmp(clasesOrdenadas(co-1),clasesOrdenadas(co))
                        vmedio = 0.5 * (valor(co-1) + valor(co));
                        decisionesCandidatas=[decisionesCandidatas vmedio];
                    end
                end
            else
                % si es categ�rica cada valor se vuelve candidato
                decisionesCandidatas = unique(datos(ejemplos,lc));
            end
            iterFinal = length(decisionesCandidatas); % itero sobre todas 
                                                      % las opciones
            
            % si hay dos valores posibles no necesita iterar m�s de una vez
            if (iterFinal == 2) && esNumerica
                iterFinal = 1;
            end
            
            % Para cada valor posible de la caracteristica candidata se calcula
            % el deltai, a la vez que se compara con el maximo almacenado.
            for dc = 1:iterFinal
                if esNumerica
                    auxHijoSi = (decisionesCandidatas(dc) > auxcarac);
                else
                    auxHijoSi = strcmp(decisionesCandidatas(dc), datos(ejemplos,lc));
                end
                auxHijoNo = ~auxHijoSi;
                nHijoSi = sum(auxHijoSi);
                nHijoNo = sum(auxHijoNo);
                iHijoSi = impureza(clasesPorEjemplo(auxHijoSi), tipoImpureza);
                iHijoNo = impureza(clasesPorEjemplo(auxHijoNo), tipoImpureza);
                
                deltai = iPadre - (nHijoSi/nPadre) * iHijoSi - ...
                    (nHijoNo/nPadre) * iHijoNo;
                   
                % Si deltai es mayor al maximo pasa a ser la decision elegida
                if deltai > deltaimax
                    deltaimax = deltai;
                    
                    % El nodo actual se divide en dos.
                    nodo.tipo = 'divisor';
                    % Se guarda la pregunta utilizada para dividir
                    if esNumerica
                        nodo.pregunta = ['�' listaCaracteristicas{lc} ...
                                         sprintf(' < %0.1f?', decisionesCandidatas(dc))];
                    else
                        nodo.pregunta = ['�' listaCaracteristicas{lc} ...
                                         '=' decisionesCandidatas{dc} '?'];
                    end
                    % Se asignan los id de los nodos que responden si y no
                    nodo.HijoSi = length(arbol) + 1;
                    nodo.HijoNo = length(arbol) + 2;
                    % Tipo provisorio
                    nodoHijoSi.tipo = 'aRevisar';
                    nodoHijoNo.tipo = 'aRevisar';
                    % Los ejemplos del padre se dividen entre los nodos hijos
                    nodoHijoSi.ejemplos = ejemplos(auxHijoSi);
                    nodoHijoNo.ejemplos = ejemplos(auxHijoNo);
                end
                
                if debugging > 1
                    if esNumerica
                        preg = ['¿' listaCaracteristicas{lc} ...
                                         sprintf(' < %0.1f?', decisionesCandidatas(dc))];
                    else
                        preg = ['¿' listaCaracteristicas{lc} ...
                                         '=' decisionesCandidatas{dc} '?'];
                    end
                    fprintf('pregunta: %s', preg)
                    fprintf('deltai: %0.5f\n', deltai)
                end
            end
        end
    end
    
    % Si no se pudo ramificar y el nodo contiene m�s de una clase
    if strcmp(nodo.tipo,'sinAsignar')
        cuentaXclase = histClases(clasesPorEjemplo); % simil histograma
        [~, imax] = max(cuentaXclase);  % indice de la clase mayoritaria
        nodo.clase = clases{imax};      % clase mayoritaria
        nodo.tipo = 'hoja';             % tipo de nodo
    end
    
    % Si est� activo el debugging imprimo en pantalla
    if debugging > 1
        fprintf('\nEn nodo %i reviso los ejemplos:\n',nodo.id);
        fprintf('%i, ',ejemplos);
        
        if strcmp(nodo.tipo,'hoja')
            fprintf('\nNodo hoja, clase: %s\n', nodo.clase);
            if length(clases) > 1
                fprintf('------�Impuro!----------\n')
                fprintf('%s\t', clases{:});
                fprintf('\n');
                fprintf('%i\t', cuentaXclase);
                fprintf('\n');
            end
        elseif strcmp(nodo.tipo,'divisor')
            fprintf('\nNodo divisor: %s\n', nodo.pregunta);
        else
            disp('---- �Ups! el �rbol tiene una rama seca ----');
        end
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
    
    % Limpieza antes del siguiente ciclo
    clear nodo nodoHijoSi nodoHijoNo; 
end

% Si est� activo el debugging imprime el �rbol creado
if debugging
    disp('-------------------------')
    disp('Detalles del �rbol creado')
    disp('-------------------------')
    for aa = 1:length(arbol)
        disp(arbol{aa})
    end
end

end