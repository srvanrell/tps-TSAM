%% Ejercicio 1 - Introducci贸n y repaso de probabilidad y teor铆a de informaci贸n
% 
% Escriba un programa para generar n煤meros aleatorios $\mathbf{x}$ con una
% funci贸n de densidad de probabilidad ($fdp$) gaussiana 
% $\mathcal{N}(\mathbf{\mu},\mathbf{\Sigma})) en $d$ dimensiones.
%

clc; close all; clear all;

%% Ejercicio 1.1
% Para cada uno de los siguientes casos: i) $fdp$ gaussiana 
% unidimensional, ii) $fdp$ gaussiana bidimensional no correlacionada y 
% iii) $fdp$ gaussiana bidimensional correlacionada,
%  
% * Genere un conjunto de n煤meros aleatorios con esa $fdp$.
% * Estime la $fdp$ experimental mediante un histrograma normalizado.
% * Compare gr谩ficamente la estimaci贸n obtenida con la fdp te贸rica.


%% 1.i) $fdp$ gaussiana unidimensional

N      = 5000;  %
media  = 3;     % definici贸n de la fdp
desvio = 2;     %

x = randgauss1D(media, desvio, N);  % conjunto de n煤meros aleatorios

[alturas, centros] = hist(x, 40);   % histograma sin normalizar
ancho = centros(2) - centros(1);    % ancho de las barras del histograma
area  = sum(ancho .* alturas);      % area de las barras del histograma
fdpexp = alturas/area;              % fdp experimental
bar(centros, fdpexp,'w');           % dibuja histograma normalizado

% Comparaci贸n con la fdp te贸rica
t = -7:0.01:13;                     
fdpteor = normpdf(t,media,desvio); % fdp te贸rica con igual media y desvio
hold on; plot(t,fdpteor,'-k','LineWidth',2); hold off;

title({'fdp de una distribucion gaussiana unidimensional';
       sprintf('mu = %0.1f, sigma = %0.1f', media, desvio)})
ylabel('p(x)'); xlabel('x');
legend('fdp experimental','fdp teorica')

%%
% Para normalizar el histograma se dividi贸 por la suma de las 谩reas de 
% los rect谩ngulos dado que la integral de una $fdp$ debe dar 1, a煤n en este
% caso donde la $fdp$ es emp铆rica. En la comparaci贸n gr谩fica se verifica la
% correspondencia con la $fdp$ te贸rica.
% 
% Debajo se muestra el c贸digo de las dos funciones utilizadas para generar
% n煤meros aleatorios de una distribuci贸n normal unidimensional.

%% randgauss.m
dbtype randgauss.m

%% randgauss1D.m
dbtype randgauss1D.m



%%  1.ii y 1.iii) $fdp$ gaussiana bidimensional [no] correlacionada;

meds{1} = [50 100]; % 
covs{1} = [2 0;     % definici贸n de fdp no correlacionada
           0 1];    %
titulos{1} = ['fdp de una distribucion gaussiana bidimensional no ' ... 
              'correlacionada'];
        
meds{2} = [50 100]; % 
covs{2} = [2 1;     % definici贸n de fdp correlacionada
           1 1];    %
titulos{2} = ['fdp de una distribucion gaussiana bidimensional ' ...
              'correlacionada'];
       
% Realizo la misma comparacion para los casos ii) y iii)
for k = 1:2
media = meds{k};
covar = covs{k};
titulo = titulos{k};
figure('units','normalized','outerposition',[0 0 1 1]);
suptitle({titulo; sprintf(['mu = [%0.0f %0.0f], '...
                           'sigma = [%0.0f %0.0f; %0.0f %0.0f]'],...
                          media, covar)})

N = 10000;                         % cantidad de muestras
x = randgaussXD(media, covar, N);  % conjunto de n煤meros aleatorios

[alturas, centros] = hist3(x,[15 15]);          % histograma sin normalizar
ancho1 = centros{1}(2) - centros{1}(1);         % ancho de las barras en x1
ancho2 = centros{2}(2) - centros{2}(1);         % ancho de las barras en x2
volumen = sum(ancho1 * sum(ancho2 * alturas));  % volumen de las barras
fdpexp = alturas ./ volumen;                    % fdp experimental

subplot(1,2,1);                      % grafica de la malla y teorica en 3D
mesh(centros{1},centros{2},fdpexp'); % mesh necesita la matriz traspuesta

% Contour plot de la fdp experimental
% hold on; contour3(centros{1},centros{2},0.01+fdpexp','k-'); hold off

% comparacion con la fdp teorica
NN = 100; 
t1 = linspace(44,56,NN); t2 = linspace(96,104,NN);
fdpteor = zeros(NN);
for i = 1:NN
    for j = 1:NN
        fdpteor(i,j) = mvnpdf([t1(i) t2(j)],media,covar);
    end
end
hold on; contour3(t1,t2,0.005+fdpteor','k-'); hold off
axis tight;
daspect([max(daspect)*[1 1] 2]);% relacion de aspecto en x1 y x2

ylabel('x_2'); xlabel('x_1'); zlabel('p(x_1,x_2)');
legend('fdp experimental','fdp teorica', 'Location','West')
title('Superficie de nivel')

% curvas de nivel de la teorica y la experimental
subplot(1,2,2); 
% contour necesita la matriz traspuesta
contour(centros{1},centros{2},fdpexp',5,'k');          % fdp experimental
hold on; contour(t1,t2,0.01+fdpteor',5,'b:'); hold off % fdp teorica
axis equal; axis([46 54 97 103]);

ylabel('x_2'); xlabel('x_1');
title('Curvas de nivel')
legend('fdp experimental','fdp teorica')

end

%%
% Para normalizar el histograma se dividi贸 por la suma total de los 
% vol煤menes de todos los prismas, an谩logo al caso unidimensional donde se 
% sumaron las 谩reas de las barras.
%
% Para la comparaci贸n gr谩fica con la distribuci贸n te贸rica se utilizaron 
% superficies y curvas de nivel. En ambos casos se comprob贸 el parecido 
% entre la $pdf$ te贸rica y experimental.
%
% Debajo se muestra el c贸digo de las dos funciones utilizadas para generar 
% los conjuntos de n煤meros de una distribuci贸n normal bidimensional. 
% |mvrandgauss.m| utiliza |randgauss.m| como punto de partida e incluye la 
% demostraci贸n del funcionamiento dentro de su c贸digo.

%% mvrandgauss.m
dbtype mvrandgauss.m

%% randgaussXD.m
dbtype randgaussXD.m


%% Ejercicio 1.2 
% Compruebe num茅ricamente el teorema del l铆mite central mediante la suma
% de n煤meros aleatorios con distribuci贸n uniforme.

repeticiones = 10000; % veces a repetir el calculo del promedio
N = [1 2 4 40];       % numeros a promedior
promedio = zeros(1,repeticiones);
figure
for n = 1:length(N)
    for r = 1:repeticiones
        % suma de N n煤meros aleatorios en [-1, +1]
        promedio(r) = (1/N(n)) * sum(2*rand(1,N(n))-1);
    end
    subplot(2,2,n)
    hist(promedio,40)
    title(['Promedio entre ' num2str(N(n)) ' numeros'])
end


%% Ejercicio 1.3
% Estime num茅ricamente y compare con el valor teorico, la entropia de una
% variable aleatoria con distribucion: i) laplaciana; ii) gaussiana y iii)
% uniforme.

N=1000;

% mantengo media y desvio para las 3 distribuciones
media = 3;
desvio = 2;

% numeros provenientes de una distribuci髇 gaussiana
xgauss = media + desvio*randn(N,1);

% numeros provenientes de una distribuci髇 uniforme
ini = media - sqrt(3) * desvio;
fin = media + sqrt(3) * desvio;
xunif = ini + (fin - ini) .* rand(N,1);

% numeros provenientes de una distribuci髇 laplaciana
media = 5;
beta  = desvio/sqrt(2);
xlap  = randlap(N,media,beta);

% Calculo de entropias teoricas y emp韗icas
HgaussTeorica  = 0.5 * (1 + log(2*pi*desvio.^2) )
HgaussEmpirica = entropia(xgauss)

HunifTeorica  = log(fin - ini)
HunifEmpirica = entropia(xunif)

HlapTeorica  = 1 + log(2*beta)
HlapEmpirica = entropia(xlap)

%%
% La entropia teorica de cada distribuci髇 esta calculada para la versi髇
% cont韓ua de la funci髇 de densidad de probabilidad (fdp). En cambio, la
% entrop韆 empirica es calculada por media de una aproximaci髇 de la fdp.
% Esto ocasiona las diferencias observadas en los valores anteriores.
% Adem醩 es sabido que la entrop韆 discreta no es equivalente a la entrop韆
% te髍ica