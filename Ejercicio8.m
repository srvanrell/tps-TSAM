clc; clear all;
format long

numpadre = 5;
ipadre = 0.50040;

% nodo hijo izquierdo (responde si)
numizq = 2;
nizq = 1;
pizq = 1;

% nodo hijo derecho (responde no)
numder = 3;
nder = 0;
pder = 3;

%calculos
if (numizq == nizq)  || (numizq == pizq)
    iizq = 0
else
    iizq = -(nizq/numizq) * log(nizq/numizq) - (pizq/numizq) * log(pizq/numizq)
end

if (numder == nder)  || (numder == pder)
    ider = 0
else
    ider = -(nder/numder) * log(nder/numder) - (pder/numder) * log(pder/numder)
end

if (numizq == numpadre)  || (numder == numpadre)
    deltai = 0
else
    deltai = ipadre - (numizq/numpadre) * iizq - (numder/numpadre) * ider
end

format short
