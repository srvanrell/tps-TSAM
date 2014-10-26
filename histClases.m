function [cuentas, clases] = histClases( clasesEnEjemplos)
% cuenta cuantos ejemplos de cada clase hay
%   cuentas = histClases( clasesEnEjemplos)
%   clasesEnEjemplos: lista con la clase de cada ejemplo
%   cuentas: cantidad de ejemplos por clase. Se conserva el orden de las 
%            clases
%   clases: lista de clases posibles, en el mismo orden de cuentas

clases = unique(clasesEnEjemplos); % lista con las posibles clases
cuentas = zeros(length(clases),1); % inicializacion de las cuentas
for i = 1:length(clases)
    cuentas(i) = sum(strcmp(clases{i}, clasesEnEjemplos));
end

end

