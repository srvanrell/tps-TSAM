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

            
% listaEjemplos = 1:14;
nombresCaract = {'pronóstico', 'temperatura', 'humedad', 'viento'};
debug = 1;

% Ejercicio 1.b
tipoImpureza = 'ent';
arbol1b = crecerArbol(datosCuadro1, [],nombresCaract,tipoImpureza,debug);
%%
% Este arbol da igual que el que hice a mano, sólo cambia la forma de
% expresar las preguntas. Por ejemplo, en 4 en vez de preguntar por
% ¿lluvioso o soleado? pregunta sólo por ¿lluvioso?
% En nodo 9 donde podria haber elegido temperatura también elige pronostico

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

