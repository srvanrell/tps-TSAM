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
                'lluvioso', 'moderado', 'alta',     'si', 'N'};

listaEjemplos = 1:14;
listaCaracteristicas = 1:4;
ar = crecerArbol(datosCuadro1, listaEjemplos, listaCaracteristicas);

for aa = 1:length(ar)
    disp(ar{aa})
end