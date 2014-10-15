%% Ejercicio 1
%% Introducción y repaso de probabilidad y teoría de información.
% Escriba un programa para generar números aleatorios $\mathbf{x}$ con una
% función de densidad de probabilidad ($fdp$) gaussiana 
% $\mathcal{N}(\mathbf{\mu},\mathbf{\Sigma})) en $d$ dimensiones:
%
clc; close all; clear all;
%% 1. 
% Para cada uno de los siguientes casos: i) $fdp$ gaussiana 
% unidimensional; ii) $fdp$ gaussiana bidimensional no correlacionada y 
% iii) $fdp$ gaussiana bidimensional correlacionada,
%  
% * Genere un conjunto de números aleatorios con esa $fdp$.
% * Estime la $fdp$ experimental mediante un histrograma normalizado.
% * Compare graficamente la estimación obtenida con la fdp teórica.


%% 1.i) $fdp$ gaussiana unidimensional

N      = 5000;  %
media  = 3;     % definición de fdp
desvio = 2;     %

x = randgauss1D(media, desvio, N);  % conjunto de números aleatorios

[alturas, centros] = hist(x, 40);   % histograma sin normalizar
ancho = centros(2) - centros(1);    % ancho de las barras del histograma
area  = sum(ancho .* alturas);      % area de las barras del histograma
fdpexp = alturas/area;              % fdp experimental
bar(centros, fdpexp,'b');           % dibuja histograma normalizado
% std(x)
% mean(x)
t = -7:0.01:13;                     
fdpteorica = normpdf(t,media,desvio); % fdp teórica con igual media y desvio
hold on; plot(t,fdpteorica,'--k','LineWidth',2.5); hold off;
title({'fdp de una distribución gaussiana unidimensional';
       sprintf('mu = %0.1f, sigma = %0.1f', media, desvio)})
ylabel('p(x)'); xlabel('x');
legend('fdp experimental','fdp teorica')

%%
% Para normalizar el histograma se dividió por la suma de las áreas de 
% los rectángulos dado que la integral de una $fdp$ debe dar 1, aún en este
% caso donde es empírica la $fdp$. En la comparación gráfica con la teórica 
% se verifica su correspondencia.
% Debajo se muestra el código de las dos funciones propias utilizadas.

%% randgauss.m
dbtype randgauss.m

%% randgauss1D.m
dbtype randgauss1D.m



%%  1.ii y 1.iii) $fdp$ gaussiana bidimensional [no] correlacionada;

meds{1} = [50 100]; % 
covs{1} = [2 0;     % definición de fdp no correlacionada
           0 1];    %
titulos{1} = 'fdp de una distribución gaussiana bidimensional no correlacionada';
        
meds{2} = [50 100]; % 
covs{2} = [2 1;     % definición de fdp correlacionada
           1 1];    %
titulos{2} = 'fdp de una distribución gaussiana bidimensional correlacionada';
       
% Realizo la misma comparacion para los dos casos
for k = 1:2
media = meds{k};
covar = covs{k};
titulo = titulos{k};
figure
suptitle({titulo; sprintf(['mu = [%0.0f %0.0f], '...
                           'sigma = [%0.0f %0.0f; %0.0f %0.0f]'],...
                          media, covar)})

N = 10000;                         % cantidad de muestras
x = randgaussXD(media, covar, N);  % conjunto de números aleatorios

[alturas, centros] = hist3(x,[15 15]);          % histograma sin normalizar
ancho1 = centros{1}(2) - centros{1}(1);         % ancho de las barras en x1
ancho2 = centros{2}(2) - centros{2}(1);         % ancho de las barras en x2
volumen = sum(ancho1 * sum(ancho2 * alturas));  % volumen de las barras
fdpexp = alturas ./ volumen;                    % fdp experimental

subplot(1,2,1);                      % grafica de la malla y teorica en 3D
mesh(centros{1},centros{2},fdpexp'); % mesh necesita la matriz traspuesta

% Contour plot de la fdp experimental
% hold on; contour3(centros{1},centros{2},0.01+fdpexp','k-'); hold off

% comparacion con fdp teorica
NN = 100; 
t1 = linspace(44,56,NN); t2 = linspace(96,104,NN);
fdpteorica = zeros(NN);
for i = 1:NN
    for j = 1:NN
        fdpteorica(i,j) = mvnpdf([t1(i) t2(j)],media,covar);
    end
end
hold on; contour3(t1,t2,0.005+fdpteorica','r-'); hold off

% colormap copper;    % cambia los colores de la malla
axis tight;
daspect([max(daspect)*[1 1] 2]);% relacion de aspecto en x1 y x2
ylabel('x_2'); xlabel('x_1'); zlabel('p(x_1,x_2)');
legend('fdp experimental','fdp teorica', 'Location','West')
title('Superficies de nivel')

% curvas de nivel de la teorica y la experimental
subplot(1,2,2); 
% contour necesita la matriz traspuesta
contour(centros{1},centros{2},fdpexp',7,'k');            % fdp experimental
hold on; contour(t1,t2,0.01+fdpteorica',7,'r'); hold off % fdp teorica
axis equal; axis([44 56 96 104]);
% daspect([max(daspect)*[1 1] 1]);     % relacion de aspecto en x1 y x2
ylabel('x_2'); xlabel('x_1');
title('Curvas de nivel')
legend('fdp experimental','fdp teorica')

end

%%
% Para normalizar el histograma se dividió por la suma total de los volúmenes 
% de todos los prismas, análogo al caso unidimensional donde se 
% sumaron las áreas de los rectángulos.
% Para la comparación gráfica con la distribución teórica se utilizaron superficies
% y curvas de nivel. En ambos casos se comprobó el parecido entre ambas pdf.
%
% Debajo se muestra el código de las dos funciones propias utilizadas para generar 
% los conjuntos de números. |mvrandgauss.m| utiliza |randgauss.m| como punto de partida
% he incluye la demostración del funcionamiento dentro de su código.

%% mvrandgauss.m
dbtype mvrandgauss.m

%% randgaussXD.m
dbtype randgaussXD.m


%% 2. 
% Compruebe numéricamente el teorema del límite central mediante la suma
% de números aleatorios con distribución uniforme.

repeticiones = 10000;
N = 1:40;%[1 2 4 40];
figure
evolucion = zeros(length(N),4);
for n = 1:length(N)
    for r= 1:repeticiones
        % suma de N números aleatorios en [-1, +1]
        promedio(r) = (1/N(n)) * sum(rand(1,N(n)));
    end
    
%     qqplot(promedio)
%     pause
%     subplot(2,2,i)
%     hist(promedio,40)
%     title(['N=' num2str(N(i))])
    % Guardo valores estimados y los teoricos
    % meadia de distribucion uniforme 
    puntaje = kstest( (promedio-0.5) /  sqrt(1/(12*N(n))) );
    puntaje2 = jbtest(promedio, 0.01);
    evolucion(n,:) = [mean(promedio), std(promedio), puntaje, puntaje2];
end
 
plot(N,evolucion);



%% 3. 
% Estime numéricamente ...

N=100;

media = 0;
desvio = 1;
xgauss = media + desvio*randn(N,1);

HgaussTeorica  = 0.5 * (1 + log(2*pi*desvio.^2) )
HgaussEmpirica1 = shanentropy(xgauss)
HgaussEmpirica2 = histentropy(xgauss)
HgaussEmpirica3 = entropia(xgauss',[-3, 3, 30])



ini = -1;
fin =  3;
xunif = ini + (fin - ini) .* rand(N,1);

HunifTeorica  = log(fin - ini)
HunifEmpirica1 = shanentropy(xunif)
HunifEmpirica2 = histentropy(xunif)
HunifEmpirica3 = entropia(xunif',[-1, 3, 30])


media = 5;
beta  = 2;
xlap  = randlap(N,media,beta);

HlapTeorica  = 1 + log(2*beta)
HlapEmpirica1 = shanentropy(xlap)
HlapEmpirica2 = histentropy(xlap)
HlapEmpirica3 = entropia(xlap',[-10, 10, 30])