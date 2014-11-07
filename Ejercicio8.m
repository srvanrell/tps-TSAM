%% Ejercicio 8 - Árboles de decisión
clc; clear all; close all;

%% Ejercicio 8.1
% Se tienen datos acerca de la realización o suspensión de partidos de 
% tenis en función del pronóstico del tiempo y los datos del día que se han
% volcado en el Cuadro 1:

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

%%
% * a) Construya "a mano" (haciendo todas las cuentas) y dibuje el árbol 
% binario de decisión que describa los datos sobre juegos de tenis del 
% cuadro. Utilice como impureza la entropía.

%%
% El árbol construido a mano se esquematiza en la página siguiente. 
% Los calculos realizados a mano se incluyen a continuación del esquema del
% árbol.

%%
% * b) Escriba un programa que permita crecer áboles de decisión binarios y
% utilícelo para generar automáticamente un árbol a partir de los datos
% anteriores. Contraste con el árbol generado por Ud.

%% crecerArbol.m

dbtype crecerArbol.m

%% impureza.m

dbtype impureza.m
%%

% listaEjemplos = 1:14; uso todos, no hace falta
nombresCaract = {'pronostico', 'temperatura', 'humedad', 'viento'};
debug = 1; % solo publica el arbol construido
tipoImpureza = 'ent';
arbol1b = crecerArbol(datosCuadro1, [],nombresCaract,tipoImpureza,debug);

%%
% Este arbol da igual que el que hice a mano, sólo cambia la forma de
% expresar las preguntas. Por ejemplo, en nodo 4 (D) en vez de preguntar por
% ¿soleado? pregunta por ¿lluvioso? que es equivalente porque hay dos
% posibilidades en ese momento (ya se había preguntado por nublado).
% En nodo 9 (I) donde podría haber elegido temperatura también elige 
% pronóstico
%
% En la página siguiente esquematizo el árbol encontrado

%%
% * c) Modifique el tipo de impureza empleada y comente las diferencias con
% el árbol generado en el punto anterior.
%

tipoImpureza = 'gini';
arbol1cgini = crecerArbol(datosCuadro1, [],nombresCaract,tipoImpureza,debug);

%%
% El árbol calculado con la impureza de gini es igual que el hecho a mano y
% que el del punto 1.b

tipoImpureza = 'miss';
arbol1cmiss = crecerArbol(datosCuadro1, [],nombresCaract,tipoImpureza,debug);
%%
% El árbol calculado con la impureza de clasificar mal difiere de los 
% anteriores desde la primera pregunta. Tiene dos nodos menos y tiene una 
% hoja impura (nodo 7), al contrario de los anteriores
% los grupos que se formaron al clasificar los ejemplos son distintos en su
% mayoria
%
% En la página siguiente esquematizo el árbol encontrado


%% Ejercicio 8.2
% Se han modificado los datos de juegos de tenis anteriores para incluir 
% valores numéricos de temperatura y humedad de acuerdo con el Cuadro 2: 
% Modifique el programa desarrollado para tratar con atributos numéricos y 
% genere un nuevo árbol con los datos del cuadro.

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


tipoImpureza = 'ent';
arbol2 = crecerArbol(datosCuadro2, [],nombresCaract,tipoImpureza,debug);

%%
% La función presentada anteriormente ya contiene los cambios realizados
% para tratar con atributos numéricos. No repito aquí el código por esa
% causa.
%
% En este caso no usa el pronóstico más allá del nodo raíz. La humedad no 
% la usa nunca. La temperatura la usa 3 veces, aprovechando que tiene más 
% cortes candidatos. El viento una sola vez. El árbol es más profundo en 
% este caso puede ser que se esmere por ir separanado en hojas y termine 
% utilizando más decisiones de las necesarias, típico de busqueda
% en profundidad.
% Es más desbalanceado que en los casos anteriores, quizá por tener más
% flexibilidad de elección prefiere ir dejando nodos hojas puros en el
% camino.


