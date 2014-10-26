function imp = impureza( clasesEnEjemplos, metodo)
% Calcula la impureza del nodo dada la lista de clases por ejemplos. 
%   imp = impureza( clasesEnEjemplos, metodo)
%   clasesEnEjemplos: lista con la clase de cada ejemplo
%   imp: impureza calculada
%   metodo: utilizado para calcular la impureza, definido por un string:
%   - 'ent': calcula la impureza por la entropia.

cuentas = histClases(clasesEnEjemplos); % cantidad de ejemplos por clase
total = sum(cuentas);                   % cantidad de ejemplos en el nodo
imp = 0;                                % inicializo la impureza

if strcmp(metodo, 'ent') && all(cuentas ~= total)
    for i = 1:length(cuentas)
        imp = imp - (cuentas(i)/total) * log(cuentas(i)/total);
    end    
end

end

