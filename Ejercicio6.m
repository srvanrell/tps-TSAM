%% Ejercicio 6
% Redes neuronales dinámicas
clear all; close all; clc

%% 1
% Implemente la arquitectura y entrenamiento Hebbiano para una red
% recurrente de Hopfield con los patrones que se muestran en la Figura 1.

load('patrones5x5.mat') % cargo los patrones desde un archivo

%%
% Grafico los 3 patrones de la figura 1

N = size(patrones5x5,2);           % cantidad de patrones

invgray = flipud(colormap(gray));  % escala de colores a utilizar
colormap(invgray);                 % blanco y negro 

for p = 1:3
    patronReshaped = reshape(patrones5x5(p,:),[5 5]); % patron --> imagen   
    subplot(3,3,p); imagesc(patronReshaped'); axis equal tight
    title('Patron original')
end


%% 
% Dados los 3 patrones entreno con ellos una red de Hopfield y obtengo la
% matriz de pesos.

W = entrenarHopfield(patrones5x5); % matriz de pesos de la red

Pmax = N / (2*log(N));             % capacidad maxima de almacenamiento

fprintf(['La capacidad de almacenamiento %0.2f ' ...
         'supera la cantidad de patrones a recordar (3).\n'], Pmax);

%% 
% Ahora pruebo recuperar los patrones originales dados patrones ruidosos

cambiar = randperm(N,4); % 4 posiciones que voy a cambiar de signo

for p = 1:3
    ruidoso = patrones5x5(p,:);
    ruidoso(cambiar) = (-1)*ruidoso(cambiar);
    recup = recuperarHopfield(ruidoso, W); % recuperado
    recupReshaped = reshape(recup,[5 5]); % patron --> imagen   
    subplot(3,3,6+p); imagesc(recupReshaped'); axis equal tight
    title('Patron recuperado')
    subplot(3,3,3+p); imagesc(reshape(ruidoso,[5 5])'); axis equal tight
    title('Patron ruidoso')
end

%%
% Con el nivel de ruido introducido, 4 cambios en 25 elementos, el segundo 
% y tercer patrón son recuperados en la mayoría de las oprtunidades.
% En cambio el primer patrón es recuperado con un error en el bit central.
%
% El código de las funciones utilizadas se transcribe a continuación.

%% entrenarHopfield.m
dbtype entrenarHopfield.m

%% recuperarHopfield.m
dbtype recuperarHopfield.m



%% 2
% Utilice la red de Hopfield como memoria asociativa para los patrones de
% la figura 2.
clear all; figure

load('numeros7x5.mat')

numMax = 4;
numeros7x5 = numeros7x5(1:numMax,:);
N = size(numeros7x5,2);            % cantidad de números

invgray = flipud(colormap(gray));  % escala de colores a utilizar
colormap(invgray);                 % blanco y negro 

for p = 1:numMax % 10 es 0
    patronReshaped = reshape(numeros7x5(p,:),[5 7]); % patron --> imagen   
    subplot(4,numMax,p); imagesc(patronReshaped'); axis equal tight
    title('Patron original')
end

%% 
% Dados los 3 patrones entreno con ellos una red de Hopfield y obtengo la
% matriz de pesos.

W = entrenarHopfield(numeros7x5); % matriz de pesos de la red

Pmax = N / (2*log(N));             % capacidad maxima de almacenamiento

fprintf(['La capacidad de almacenamiento %0.2f ' ...
         'es inferior a la cantidad de patrones a recordar (10).\n'], Pmax);

%% 
% Ahora pruebo recuperar los patrones originales dados patrones ruidosos

ruidos = [0.1 0.2 0.5]; % procentajes de ruidos

for p = 1:numMax % 10 es 0
    for r = 1:3
        nCambios = floor(N*ruidos(r));
        cambiar = randperm(N,nCambios); % posiciones a cambiar de signo
        ruidoso = numeros7x5(p,:);
        ruidoso(cambiar) = (-1)*ruidoso(cambiar);
        recup = recuperarHopfield(ruidoso, W); % recuperado
        recupReshaped = reshape(recup,[5 7]); % patron --> imagen
        subplot(4,numMax,r*numMax+p); imagesc(recupReshaped'); axis equal tight
        tit = sprintf('%2.0f%% ruido',100*nCambios/N);
        title(tit)
    end
end

%% 3
% Agregue diferentes cantidades de ruido a los patrones de la Figura 2 y 
% utilice estos ejemplos ruidosos para acceder a las memorias fundamentales
% almacenadas como en el ejercicio anterior. Para simular cantidades 
% controladas de ruido se sugiere invertir (blanco a negro y viceversa) 
% cada pixel del dígito con probabilidades 0.1, 0.2 y 0.5.

%%
% Al entrenar con los 10 números se sobrepasa la capacidad de
% almacenamiento máxima de la red por lo que se recupera siempre el mismo
% digito (9) o su versión especular, aún en los niveles de ruidos más
% bajos.
%
% Reduciendo la cantidad de digitos en la memoria se observa que para
% cuatro digitos o menos se logra obtener cierto grado de recuperación. Si 
% se entrena con cuatro digitos (como se observa en la gráfica anterior) se
% logra recuperar el 1 y el 4, en cambio el 2 y el 3 al ser parecidos
% devuelven un patrón que se parece a ambos pero no es ninguno de ellos.
% Con el mayor nivel de ruido (50%) se pierde toda posibilidad de
% recuperación.
