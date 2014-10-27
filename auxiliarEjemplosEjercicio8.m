clc; clear all; close all;

% atributos de cada ejemplo: pronostico, temperatura, humedad, viento
% el ulitmo elemento de cada ejemplo es la clase
datosCuadro1 = {'soleado',  'calor',    'alta',     'no', 'N';
                'soleado',  'calor',    'alta',     'si', 'N';
                'nublado',  'calor',    'alta',     'no', 'P';
                'lluvioso', 'moderado', 'alta',     'no', 'P';
                'lluvioso', 'frio',     'normal',   'no', 'P';
                'lluvioso', 'frio',     'normal',   'si', 'N';
                'nublado',  'frio',     'normal',   'si', 'P';
                'soleado',  'moderado', 'alta',     'no', 'N';
                'soleado',  'frio',     'normal',   'no', 'P';
                'lluvioso', 'moderado', 'normal',   'no', 'P';
                'soleado',  'moderado', 'normal',   'si', 'P';
                'nublado',  'moderado', 'alta',     'si', 'P';
                'nublado',  'calor',    'normal',   'no', 'P';
                'lluvioso', 'moderado', 'alta',     'si', 'N';};

datosCuadro2 = {'soleado',  85,    85,   'no', 'N';
                'soleado',  80,    90,   'si', 'N';
                'nublado',  83,    78,   'no', 'P';
                'lluvioso', 70,    96,   'no', 'P';
                'lluvioso', 68,    80,   'no', 'P';
                'lluvioso', 65,    70,   'si', 'N';
                'nublado',  64,    65,   'si', 'P';
                'soleado',  72,    95,   'no', 'N';
                'soleado',  69,    70,   'no', 'P';
                'lluvioso', 75,    80,   'no', 'P';
                'soleado',  75,    70,   'si', 'P';
                'nublado',  72,    90,   'si', 'P';
                'nublado',  81,    75,   'no', 'P';
                'lluvioso', 71,    80,   'si', 'N';};

%%            
% listaEjemplos = 1:14;
nombresCaract = {'pron�stico', 'temperatura', 'humedad', 'viento'};
debug = 2;
%%
% Ejercicio 1.b
tipoImpureza = 'ent';
arbol1b = crecerArbol(datosCuadro1, [],nombresCaract,tipoImpureza,debug);
%%
% Este arbol da igual que el que hice a mano, s�lo cambia la forma de
% expresar las preguntas. Por ejemplo, en 4 en vez de preguntar por
% �lluvioso o soleado? pregunta s�lo por �lluvioso?
% En nodo 9 donde podria haber elegido temperatura tambi�n elige pronostico

% Ejercicio 1.c
tipoImpureza = 'gini';
arbol1c = crecerArbol(datosCuadro1, [],nombresCaract,tipoImpureza,debug);
%%
% Este arbol da igual que el que hice a mano y al del punto b

% Ejercicio 1.c
tipoImpureza = 'miss';
arbol1cc = crecerArbol(datosCuadro1, [],nombresCaract,tipoImpureza,debug);
%%
% Este arbol difiere de los anteriores desde la primera pregunta
% tiene dos nodos menos
% tiene una hoja impura (7), al contrario de los anteriores
% los grupos que se formaron al clasificar los ejemplos son distintos en su
% mayoria

%% Ejercicio 8.2
%
clc
tipoImpureza = 'ent';
arbol2 = crecerArbol(datosCuadro2, [],nombresCaract,tipoImpureza,debug);

%%
% en este caso no usa el pronostico mas alla del nodo raiz
% la humedad no la usa nunca
% la temperatura 3 veces, aprovechando que tiene mas cortes candidatos
% el viento una sola vez
% el arbol es mas profundo en este caso puede ser que se engolosine por ir 
% separanado y termine utilizando mas de lo necesario, tipico de busqueda
% en profundidad.
% es mas desbalanceado que en los casos anteriores, quiza por tener mas
% flexibilidad de eleccion prefiere ir dejando nodos hojas puros en el
% camino


