%% Ejercicio 4 - Análisis estadístico de datos - ICA
clc; close all; clear all;

%% 1
% Implemente el algoritmo de FastICA con aprendizaje deflacionario.
%
% Debajo se copia el código fuente de la función implementada. La
% descripción de la misma se encuentra dentro del código.

%% fastica.m
dbtype fastica.m

%% 2
% A partir de datos de dos mezclas, obtenidos mediante dos fuentes 
% laplacianas y una matriz de mezcla aleatoria, utilice FastICA para lo 
% siguiente:
% 
% # Para cada etapa (fuentes, mezclas, señales blanqueadas, señales 
%   separadas) dibuje un gráfico de dispersión de las variables.
% # Luego de la separación, estime las matrices $\mathbf{P}$ y $\mathbf{D}$

N = 1000; % Cantidad de muestras

% Fuentes laplacianas 
s{1} = randlap(N, 2 , 2)';
s{2} = randlap(N, -5,0.4)';

% Se corroboran los signos para impedir que las mezclas sean iguales
signos = ones(2);
while isequal(signos(1,:),signos(2,:)) || isequal(signos(1,:), -signos(2,:))
    signos = sign(rand(2)-0.5);
end
% Generacacion de la matriz de mezcla
A = (2*rand(2)-1) .* signos;  % Mezcla no ortogonal
% A = [0.6 0.8; 0.5 -0.2];

% suptit{1} = 'Fuentes laplacianas';


%% Mezclas de las dos fuentes
X = mezclar(A,s{1},s{2});

%% Blanqueo de las mezclas mediante PCA
[E, lambdas] = mipca(X);
% E: matriz cuyas columnas son los versores de las direcciones
%    principales.
% lambdas: es un vector con los autovalores

Dmenos1medio = diag(sqrt(lambdas.^(-1)));% matriz con las inversas de los 
                                         % lambdas en la diagonal principal

Xmean = repmat(mean(X,2), 1, size(X,2)); % media de las mezclas

Z = Dmenos1medio * E'  * (X - Xmean);    % señales blanqueadas

%% Separación con FastICA
W = fastica(Z); % me devuelve la matriz de separación

Y = W' * Z; % Separación de las fuentes mediante la matriz dada por fastica

%% Estimando P y D
%
% Como se cumple que 
% $\mathbf{y} = \mathbf{W}^T\mathbf{x} = \mathbf{W}^T\mathbf{A}\mathbf{s}$, 
% es posible fijarse cual de las dos fuentes aporta mas a cada señal
% recuperada y asi poder determinar si están permutadas las señales 
% recuperadas con las fuentes.
%
% Así, en primer lugar busco la matriz $\mathbf{P}$ que cumpla
% $\mathbf{P} \mathbf{D} = \mathbf{W}^T\mathbf{A}$. Hay solo dos
% posibilidades para esta matriz, la identidad, o un matriz con sólo unos
% en la diagonal secundaria.
% Para esto me fijo en cada renglon de la matriz $\mathbf{W}^T\mathbf{A}$ y
% defino una matriz $\mathbf{P}$ a partir de los máximos componentes por
% renglón.

WA = W' * A;
[~, maxwa] = max(abs(WA),[],2);

P = zeros(2);
P(1,maxwa(1)) = 1;
P(2,maxwa(2)) = 1;

%%
% La anterior forma de encontrar $\mathbf{P}$ no está funcionando como 
% se esperaba por lo que para decidir la permutación realizo una 
% comparación entre las señales recuperadas y las fuentes.

s1y1 = dot(s{1}-mean(s{1},2),Y(1,:)) ./ size(Y,2); % fuente 1 vs recup 1
s1y2 = dot(s{1}-mean(s{2},2),Y(2,:)) ./ size(Y,2); % fuente 1 vs recup 2
s2y1 = dot(s{2}-mean(s{1},2),Y(1,:)) ./ size(Y,2); % fuente 2 vs recup 1
s2y2 = dot(s{2}-mean(s{2},2),Y(2,:)) ./ size(Y,2); % fuente 2 vs recup 2

auxs1 = [s1y1, s1y2]; % el maximo me dice cual corresponde a fuente 1
auxs2 = [s2y1, s2y2]; % el maximo me dice cual corresponde a fuente 2
[~, s1max] = max(abs(auxs1));
[~, s2max] = max(abs(auxs2));

P = zeros(2) ;  
P(1,s1max) = 1; % asigno los 1 de acuerdo a lo encontrado
P(2,s2max) = 1; % asigno los 1 de acuerdo a lo encontrado

% como P y su inversa son iguales calculo D = Pinv * W' * A

D = P * WA;

fprintf(['P = [%0.2f %0.2f],\t D = [%0.2f %0.2f]\n'...
         '    [%0.2f %0.2f],\t     [%0.2f %0.2f]\n\n'],...
          P(1,:), WA(1,:), P(2,:), WA(2,:) );


% Graficando cada etapa
subplot(2,2,1)
scatter(s{1}, s{2}); axis equal;
title({'Fuentes'})
xlabel('s_1'); ylabel('s_2');

subplot(2,2,2)
scatter(X(1,:), X(2,:)); axis equal;
title({'Mezclas'})
xlabel('x_1'); ylabel('x_2');

subplot(2,2,3)
scatter(Z(1,:), Z(2,:)); axis equal;
title({'Señales blanqueadas'})
xlabel('z_1'); ylabel('z_2');

subplot(2,2,4)
scatter(Y(1,:), Y(2,:)); axis equal;
title({'Señales separadas'})
xlabel('y_1'); ylabel('y_2');

%%
% En las gráficas se muestra cada una de las etapas requeridas.

% Comparación entre señales separadas y fuentes
figure
subplot(2,2,1)
plot(s{1}(1:60)); ylim([-10, 10]);
ylabel('s_1')

subplot(2,2,2)
plot(s{2}(1:60)); ylim([-10, 10]);
ylabel('s_2');

subplot(2,2,3)
plot(Y(1,1:60)); ylim([-10, 10]);
ylabel('y_1');

subplot(2,2,4)
plot(Y(2,1:60)); ylim([-10, 10]);
ylabel('y_2');


%%
% # ¿La matriz de separación $\mathbf{W}$ es la inversa de la matriz de 
% mezcla $\mathbf{A}$ utilizada?
%
% No lo es, en el caso ideal lo sería. En la práctica se espera obtener
% $\mathbf{P} \mathbf{D} = \mathbf{W}^T\mathbf{A}$, donde $\mathbf{P}$ es
% una matriz de permutación y \mathbf{D} es una matriz de escalado (también
% involucra el signo para invertir la señal de ser necesario).
%

%%
% # ¿Cómo se afecta este resultado si agrega una componente de ruido 
% gaussiano al modelo generativo?
% 
% La base del funcionamiento de ICA está en maximizar la lejanía de las
% distribuciones de cada señal recuperada de la distribución gaussiana. Si
% el ruido gaussiano tiene una potencia importante en relación a las 
% fuentes es de esperar que no se logren recuperar. Si el ruido no
% enmasacara por demás las fuentes es posible recuperar las fuentes.
%
%
%
% # ¿Qué ocurre si una de las fuentes es gaussiana? ¿Y si ambas lo son?
%
% Si una de las fuentes es gaussiana todavía es posible encontrar las
% fuentes, si las dos lo son no es posible.






% % % % % for ss = 1:2
% % % % %     figure
% % % % %     for aa = 1:2
% % % % %         X = mezclarconruido(A{aa},s{2*ss-1},s{2*ss}); % Mezclas 
% % % % %         
% % % % %         W = mipca(X); % Obtengo la Matriz de Proyección de X sobre las
% % % % %                       % componentes principales
% % % % %         
% % % % %         Y = W * X; % Proyecto los datos sobre las direcciones principales
% % % % %         
% % % % %         subplot(2,3,1+3*(aa-1))
% % % % %         scatter(s{2*ss-1}, s{2*ss}); axis equal;
% % % % %         title({'Fuentes';['columnas ' titort{aa}]} )
% % % % %         xlabel('s_1'); ylabel('s_2');
% % % % %         
% % % % %         subplot(2,3,2+3*(aa-1))
% % % % %         scatter(X(1,:), X(2,:)); axis equal;
% % % % %         hold on; 
% % % % %         x1m = mean(X(1,:));
% % % % %         x2m = mean(X(2,:));
% % % % %         plot(x1m + [0 5*W(1,1)],x2m + [0 5*W(1,2)], 'k','LineWidth',2)
% % % % %         plot(x1m + [0 5*W(2,1)],x2m + [0 5*W(2,2)], 'k','LineWidth',2)
% % % % %         hold off
% % % % %         title({'Mezclas';['columnas ' titort{aa}]} )
% % % % %         xlabel('x_1'); ylabel('x_2');
% % % % %         
% % % % %         subplot(2,3,3+3*(aa-1))
% % % % %         scatter(Y(1,:), Y(2,:)); axis equal;
% % % % %         title({'Señales separadas';['columnas ' titort{aa}]} )
% % % % %         xlabel('y_1'); ylabel('y_2');
% % % % %         
% % % % %         A{aa}
% % % % %         inv(A{aa})
% % % % %         W
% % % % %     end
% % % % %     suptitle(suptit{ss})
% % % % % end

% % % % % % % % % % Xmean(:,1)
% % % % % % % % % 
% % % % % % % % % 
% % % % % % % % % D = zeros(2);
% % % % % % % % % D(1,1) = auxs1(s1max);
% % % % % % % % % D(2,2) = auxs2(s2max);
% % % % % % % % % D;
% % % % % % % % 
% % % % % % % % % Y = Y + W' *  Xmean;
% % % % % 
% % % % % Srecup = inv(P * D) * Y;
% % % % % 
% % % % % 
% % % % % subplot(3,2,5)
% % % % % plot(Srecup(1,1:60)); ylim([-10, 10]);
% % % % % ylabel('s.recup_1');
% % % % % 
% % % % % subplot(3,2,6)
% % % % % plot(Srecup(2,1:60)); ylim([-10, 10]);
% % % % % ylabel('s.recup_2');