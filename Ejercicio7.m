%% Ejercicio 7
% Modelos de Markov.
clc; close all; clear all;

%% 1
% Autómata observable

% Matriz de probabilidades de transición
A = [0.7 0.3;
     0.6 0.4];

% Probabilidades iniciales
PI = [0.6 0.4];

nMuestras = 10;
nObservaciones = 100;
observaciones = zeros(nObservaciones,nMuestras);

%% a) y b)

for s = 1:nObservaciones
    observaciones(s,:) = generarSec(A,PI,nMuestras);  
end

figure
plot(observaciones','d-'); axis tight;
ylim([0.8 2.2])
set(gca,'YTick', [1, 2]) 
set(gca,'YTickLabel', {'lluvioso','soleado'});



%% c) 
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
PIest = [sum(observaciones(:,1)==1) sum(observaciones(:,1)==2)] ./ nObservaciones

Aest = zeros(size(A));
Aest(1,:) = gammaij(1,:) / gammai(1);
Aest(2,:) = gammaij(2,:) / gammai(2);
Aest

%%
% Los valores de Aest y piiniest son estimados con un error menor al 2%
% 
% El largo de las secuencias no influye sobre la estimación de pi0 dado que
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

errorAest = abs(Aest - A)
errorPIest = abs(PIest - PI)


%% c) continuación
% Este modelo no sería para todas las estaciones del año ya que sería de
% esperar que en cada estación la relación entre días lluviosos y soleados
% cambien. Por ejemplo sería esperable que llueva más en primavera o verano
% antes que en invierno.



%% d)
%  podria pensar en que las variables observables sean lluvia (1) o sol (2)
% Entonces la matriz de observación quedaría como:
B = [0.75 0.4;
     0.25 0.6];
%%
% donde cuando llueve hay un 75% de probabilidad de que el clima sea
% lluvioso y 25% de que el dia esté soleado
% en cambio, cuando hay sol hay 60% de que el dia se mantenga soleado y 40%
% de que llueva
% la secuencia de estados se ve alterada en algunos casos, donde días que
% se observó sol en realidad era un día lluvioso y días donde hubo lluvia
% era un día soleado.


[observaciones, est] = generarMOMSec(A,B,PI,nMuestras)



%% 2
%
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

% a)
% genero secuencia larga

Nsec = 1000;

[observaciones, secEst] = generarMOMSec(A,B,PI,Nsec);

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

figure
plot(secEst,'ok');
hold on; 
plot(secMasProb,'.r');
plot(secMasProb2,'+g');
plot(secMasProb3,'db');
plot(find(errores),0.9,'dr');
plot(find(errores2),0.85,'dg');
plot(find(errores3),0.8,'*b');
hold off;
axis tight;
ylim([0.8 2.2])
set(gca,'YTick', [1, 2]) 
set(gca,'YTickLabel', {'lluvioso','soleado'});

legend('real','estimada','errores','Location','East')


%% 
% implemente viterbi y viterbi manejando las probabilidades con logaritmos
% Con logaritmos las secuencias largas obtienen mejores reconocimientos,
% porque no se acumulan los errores de las probabilidades muy chicas.

%% b)
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
    [observaciones(s,:) estados(s,:)] = generarMOMSec(A,B,PI,nMuestras);  
end

[Aest1, Best1, PIest1] = estimarMOMconViterbiPrueba(observaciones,2,estados)

[Aest2, Best2, PIest2, Aini2, Bini2] = estimarMOMconViterbi(observaciones,2);
Aest2 = Aest2
Best2 = Best2

[Aest3, Best3] = hmmtrain(observaciones,Aini2,Bini2','Algorithm','Viterbi');
Aest3 = Aest3
Best3 = Best3'

[Aest4, Best4, PIest4] = estimarMOMconViterbiDesacop(observaciones,2)
%% 
% No esta funcionando ninguno muy bien
