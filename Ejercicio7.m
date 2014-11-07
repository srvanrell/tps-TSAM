%% Ejercicio 7 - Modelos de Markov
clc; close all; clear all;

%% Ejercicio 7.1
% La Secretaría de Turismo de una ciudad quiere modelar el clima diario 
% local para planificar distintas actividades. Para ello se propone el 
% modelo probabilístico de la Figura 3 basado en autómatas observables de 
% Markov, con los siguientes parámetros:

% Matriz de probabilidades de transición
A = [0.7 0.3;
     0.6 0.4];

% Probabilidades iniciales
PI = [0.6 0.4];

%% 
% * a) Realice la simulación computacional del mismo como modelo generativo.
% * b) Genere varias secuencias climáticas y grafíquelas.

nMuestras = 10;
nObservaciones = 100;
observaciones = zeros(nObservaciones,nMuestras);

for s = 1:nObservaciones
    observaciones(s,:) = generarSec(A,PI,nMuestras);  
end

figure
plot(observaciones(1:2,:)','o-'); axis tight;
hold on; plot(observaciones(2,:)','*:'); axis tight; hold off
ylim([0.8 2.2])
set(gca,'YTick', [1, 2]) 
set(gca,'YTickLabel', {'lluvioso','soleado'});
xlabel('tiempo')
title('Secuencias de climáticas (2 ejemplos)')

%% generarSec.m
dbtype generarSec.m

%% 
% * c) Utilice las secuencias de salida generadas para re-estimar los 
% valores de A y $\pi$: ¿Cómo influye la cantidad de secuencias y el largo 
% de las mismas en la estimación de los parámetros del autómata? ¿Sería 
% este modelo válido para todas las estaciones del año?

% Contadores de saltos para realizar las estimaciones
gammai = zeros(2,1); % contador de visitas el estado i
gammaij = zeros(2);  % contador de veces que se saltó del estado i al j

for s = 1:nObservaciones
    for n = 1:nMuestras-1
        i = observaciones(s,n);   % estado actual
        j = observaciones(s,n+1); % estado siguiente
        gammai(i) = gammai(i) + 1; % visitas al estado i
        gammaij(i,j) = gammaij(i,j) + 1; % saltos de i a j
    end
end

% estimación de comenzar en un estado u otro
% numSecuenciasQueArrancanEnEstadoi / NumSecuecuencias
PIest = [sum(observaciones(:,1)==1) sum(observaciones(:,1)==2)] ...
         ./ nObservaciones

Aest = zeros(size(A));
Aest(1,:) = gammaij(1,:) / gammai(1);
Aest(2,:) = gammaij(2,:) / gammai(2);
Aest

errorAest = abs(Aest - A) / norm(A)
errorPIest = abs(PIest - PI) / norm(PI)

%%
% Los valores de Aest y PIest son estimados con un error menor al 5%
% 
% El largo de las secuencias no influye sobre la estimación de PI dado que
% sólo se utilizan los estados iniciales de cada secuencia. En cambio, si
% se aumenta en uno la cantidad de secuencias se tiene conocimiento de un
% estado más para estimar las probabilidades de comenzar con uno u otro
% estado.
%
% La estimación de A es influida por la longitud de las secuencias así como
% por la cantidad de secuencias. 
% Si se mantiene la longitud de las secuencias, al aumentar en uno la 
% cantidad de secuencias se tienen tantos saltos nuevos para estimar la 
% matriz de transición cómo longitud tengan las secuencias.
% En cambio, si se mantiene la cantidad de secuencias, el aumentar en uno  
% la longitud de las secuencias se tendrá tantos saltos nuevos cómo
% cantidad de secuencias se tengan.
%
% Este modelo no sería para todas las estaciones del año ya que sería de
% esperar que en cada estación la relación entre días lluviosos y soleados
% cambien. Por ejemplo sería esperable que llueva más en primavera o verano
% antes que en invierno.



%% 
% * d) ¿Cómo convertiría este modelo en un modelo oculto de Markov? Realice
% los cambios que correspondan en la simulación para este caso, genere
% nuevas secuencias con este modelo y comente los resultados comparados
% con el caso anterior.

%%
% Podria pensar en que las variables observables sean lluvia (1) y sol (2)
% Entonces la matriz de observación quedaría como:
B = [0.75 0.4;
     0.25 0.6];
%%
% donde cuando llueve hay un 75% de probabilidad de que el clima sea
% lluvioso y 25% de que el día esté soleado.
% En cambio, cuando hay sol hay 60% de que el día se mantenga soleado y 40%
% de que llueva.
%
% La secuencia de estados se ve alterada en algunos casos, donde días que
% se observó sol en realidad era un día lluvioso y días donde hubo lluvia
% era un día soleado.


[observaciones, estados] = generarMOMSec(A,B,PI,nMuestras)

%% generarMOMSec.m
dbtype generarMOMSec.m

clear all; close all; clc
%% Ejercicio 7.2
% La Secretaría de Turismo quiere ahora modelar la actividad principal 
% diaria de los turistas que visitan la ciudad y su relación con el clima. 
% Para ello se propone completar el modelo anterior para convertirlo en un
% modelo oculto de Markov como el de la Figura 4, con los siguientes 
% parámetros:

% Matriz de probabilidades de transición
A = [0.7 0.3;  % (lluvioso->lluvioso  lluvioso->soleado)
     0.6 0.4]; % ( soleado->lluvioso   soleado->soleado)

% Probabilidades iniciales
PI = [0.6 0.4]; % (lluvioso, soleado) % llamado pi en el enunciado

% Matriz de observación
B = [0.1 0.6;  % (caminar@lluvioso  caminar@soleado)
     0.4 0.3;  % (comprar@lluvioso  comprar@soleado)
     0.5 0.1]; % (  museo@lluvioso    museo@soleado)

%%
% * a) Genere una secuencia de comportamientos suficientemente larga y 
% calcule la secuencia de climas más probable (para esa secuencia de 
% comportamientos). ¿Cuánto difiere la secuencia climática ``real'' 
% generada por el modelo de la estimada a partir de sus parámetros?

% genero secuencia larga
Nsec = 1000;

[observaciones, secEst] = generarMOMSec(A,B,PI,Nsec);

% Busqueda de la secuencia mas probable, con mis funciones y la hmmviterbi
% de matlab. Más abajo dejo el codigo de mis funciones.
[secMasProb, prob] = viterbi(observaciones,A,B,PI);
[secMasProb2, prob2] = logviterbi(observaciones,A,B,PI);
[secMasProb3, prob3] = hmmviterbi(observaciones,A,B');

errores = (secEst ~= secMasProb);
errores2 = (secEst ~= secMasProb2);
errores3 = (secEst ~= secMasProb3);

errorReconocimiento = 100 * sum(errores) / Nsec;
fprintf('La secuencia encontrada con viterbi difiere de la real en un %0.2f %%\n', ...
        errorReconocimiento)
    
errorReconocimiento2 = 100 * sum(errores2) / Nsec;
fprintf('La secuencia encontrada con log viterbi difiere de la real en un %0.2f %%\n', ...
        errorReconocimiento2)

errorReconocimiento3 = 100 * sum(errores3) / Nsec;
fprintf('La secuencia encontrada con hmmviterbi difiere de la real en un %0.2f %%\n', ...
        errorReconocimiento3)

% figure
% plot(secEst,'ok');
% hold on; 
% plot(secMasProb,'.r');
% plot(secMasProb2,'+g');
% plot(secMasProb3,'db');
% plot(find(errores),0.9,'dr');
% plot(find(errores2),0.85,'dg');
% plot(find(errores3),0.8,'*b');
% hold off;
% axis tight;
% ylim([0.8 2.2])
% set(gca,'YTick', [1, 2]) 
% set(gca,'YTickLabel', {'lluvioso','soleado'});
% 
% legend('real','estimada','errores','Location','East')

%% 
% Implementé viterbi y logviterbi manejando las probabilidades con 
% logaritmos
% Con logaritmos las secuencias largas obtienen mejores reconocimientos,
% porque no se acumulan los errores de las probabilidades muy chicas.
% También corroboré que el funcionamiento fuera similar al de las función
% propia de Matlab que implementa el mismo algoritmo.

%% viterbi.m
dbtype viterbi.m

%% logviterbi.m
dbtype logviterbi.m


%% 
% * b) Utilice el modelo para analizar el desempeño de los metodos de 
% entrenamiento:
% * Genere varias secuencias adicionales de comportamiento.
% * A partir de estos datos estime los parámetros del modelo mediante el 
% algoritmo de Viterbi y el de Baum-Welch.
% * Compare los resultados obtenidos en ambos casos con los valores
%  reales de los parámetros.

%%
% Los códigos de este ejercicio no han sido depurados, el entrenamiento con
% Baum-Welch aún contiene errores, numéricos seguramente y debería
% implementar la versión logarítmica. Si logro hacerla funcionar
% actualizaré el reporte. El entrenador con Viterbi si fue implementado
% pero no llega a las matrices del modelo original.

% Repito las matrices pero despues se pueden borrar
clear all; close all; clc
% Matriz de probabilidades de transición
A = [0.7 0.3;  % (lluvioso->lluvioso  lluvioso->soleado)
     0.6 0.4]; % ( soleado->lluvioso   soleado->soleado)

% Probabilidades iniciales
PI = [0.6 0.4]; % (lluvioso, soleado) % llamado pi en el enunciado

% Matriz de observación
B = [0.1 0.6;  % (caminar@lluvioso  caminar@soleado)
     0.4 0.3;  % (comprar@lluvioso  comprar@soleado)
     0.5 0.1]; % (  museo@lluvioso    museo@soleado)
 

nMuestras = 500;
nObservaciones = 100;
observaciones = zeros(nObservaciones,nMuestras);
estados = zeros(nObservaciones,nMuestras);

for s = 1:nObservaciones
    [observaciones(s,:), estados(s,:)] = generarMOMSec(A,B,PI,nMuestras);  
end

% [Aest1, Best1, PIest1] = estimarMOMconViterbiPrueba(observaciones,2,estados)

[Aest2, Best2, PIest2, Aini2, Bini2] = estimarMOMconViterbi(observaciones,2);
Aest2 = Aest2
Best2 = Best2

[Aest3, Best3] = hmmtrain(observaciones,Aini2,Bini2','Algorithm','Viterbi');
Aest3 = Aest3
Best3 = Best3'

% [Aest4, Best4, PIest4] = estimarMOMconViterbiDesacop(observaciones,2)
%
% No esta funcionando ninguno muy bien
% [Aest5, Best5, PIest5,Aini5,Bini5] = estimarMOMconBaumWelch(observaciones,2)
% 
% % no está normalizando bien A !!!!
% 
% [Aest6, Best6] = hmmtrain(observaciones,Aini5,Bini5');
% Aest6 = Aest6
% Best6 = Best6'


%% 
% * c) Si tuviera varios modelos que describieran distintos hábitos de 
% comportamiento para distintos tipos de turistas: ¿cómo implementaría un 
% método que le permita clasificar un turista recién llegado en función de
% su secuencia de actividades diaria durante la primer semana de estadía?

%%
% Buscaría el modelo que diera la mayor probabilidad para definir que tipo
% de persona es el nuevo turista y así utilizar ese modelo de ahí en más.
