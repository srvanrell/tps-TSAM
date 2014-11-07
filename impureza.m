function imp = impureza( clasesEnEjemplos, metodo)
% Calcula la impureza del nodo dada la lista de clases por ejemplos. 
%   imp = impureza( clasesEnEjemplos, metodo)
%   clasesEnEjemplos: lista con la clase de cada ejemplo
%   imp: impureza calculada
%   metodo: utilizado para calcular la impureza, definido por un string:
%   - 'ent': calcula la impureza por la entropia.
%   - 'gini': calcula la impureza de Gini
%   - 'miss': impureza por la minima probabilidad de errar la clasificación

cuentas = histClases(clasesEnEjemplos); % cantidad de ejemplos por clase
total = sum(cuentas);                   % cantidad de ejemplos en el nodo
imp = 0;                                % inicializo la impureza

% Si no son todos de la misma clase
if all(cuentas ~= total)
    if strcmp(metodo, 'ent')
        imp = - sum( (cuentas./total) .* log(cuentas./total) );
    elseif strcmp(metodo, 'gini')
        imp = 1 - sum((cuentas./total).^2);
    elseif strcmp(metodo, 'miss')
        imp = 1 - max(cuentas./total);
    else
        disp('------ Perdón, no sé calcular esa impureza :( ------');
    end
end

end

