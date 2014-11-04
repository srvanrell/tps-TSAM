%% Ejercicio 7
% Modelos de Markov.
clc; close all; clear all;

%% 1
% Autómata observable

% Matriz de probabilidades de transición
A = [0.7 0.3;
     0.6 0.4];

% Probabilidades iniciales
pi0 = [0.6 0.4];

Nmuestras = 10;
Nsecuencias = 100;
sec = zeros(Nsecuencias,Nmuestras);

%% a) y b)

for s = 1:Nsecuencias
    sec(s,:) = generarSec(A,pi0,Nmuestras);  
end

figure
plot(sec','d-'); axis tight;
ylim([0.8 2.2])
set(gca,'YTick', [1, 2]) 
set(gca,'YTickLabel', {'lluvioso','soleado'});



%% c) 
% Contadores de saltos para realizar las estimaciones
gammai = zeros(2,1); % contador de visitas el estado i
gammaij = zeros(2);  % contador de veces que se saltó del estado i al j


for s = 1:Nsecuencias
    for n = 1:Nmuestras-1
        i = sec(s,n);   % estado actual
        j = sec(s,n+1); % estado siguiente
        gammai(i) = gammai(i) + 1; % visitas al estado i
        gammaij(i,j) = gammaij(i,j) + 1; % saltos de i a j
    end
end

% estimación de comenzar en un estado u otro
% numSecuenciasQueArrancanEnEstadoi / NumSecuecuencias
pi0est = [sum(sec(:,1)==1) sum(sec(:,1)==2)] ./ Nsecuencias

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
errorpiiniest = abs(pi0est - pi0)


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


[sec, est] = generarMOMSec(A,B,pi0,Nmuestras)



%% 2
%
clear all; close all; clc

% Matriz de probabilidades de transición
A = [0.7 0.3;  % (lluvioso->lluvioso  lluvioso->soleado)
     0.6 0.4]; % ( soleado->lluvioso   soleado->soleado)

% Probabilidades iniciales
pi0 = [0.6 0.4]; % (lluvioso, soleado)

% Matriz de observación
B = [0.1 0.6;  % (caminar@lluvioso  caminar@soleado)
     0.4 0.3;  % (comprar@lluvioso  comprar@soleado)
     0.5 0.1]; % (  museo@lluvioso    museo@soleado)

%% a)
% genero secuencia larga

Nsec = 10;

[sec, est] = generarMOMSec(A,B,pi0,Nsec)

%%
[secMasProb, prob] = viterbi(sec,A,B,pi0)