%% Ejercicio 4
% Análisis estadístico de datos - ICA.
clc; close all; clear all;


%% 1
% Implemente el algoritmo de FastICA con aprendizaje deflacionario.
%
% Debajo se copia el código fuente de la función implementada. La
% descripción de la misma se encuentra dentro del código.

%% mipca.m
% dbtype ica.m

%% 2
% A partir de datos de dos mezclas, obtenidos mediante dos fuentes 
% laplacianas y una matriz de mezcla aleatoria, utilice FastICA para lo 
% siguiente:
% 
% 
% REVISAR
% # Pruebe con fuentes con distribución gaussiana y laplaciana, para
% matrices de mezcla con columnas ortogonales y no ortogonales.
% # Para cada caso de los anteriores y cada etapa (fuentes, mezclas,
% señales separadas) dibuje un gráfico de dispersión de las variables.
% # Luego de la separación obtenga la matriz $\mathbf{W}$ correspondiente.

N = 1000;

% Fuentes gaussianas y laplacianas 
% s{1} = randgauss1D(1, 1, N)'; 
% s{2} = randgauss1D(3, 3, N)';
s{1} = randlap(N, 2 , 2)';
s{2} = randlap(N, -5,0.4)';

% Se corroboran los signos para impedir que las mezclas sean iguales
% signos = ones(2);
% while isequal(signos(1,:),signos(2,:)) || isequal(signos(1,:), -signos(2,:))
%     signos = sign(rand(2)-0.5);
% end
% Generacacion de las matrices de mezcla
% A{1} = repmat(2*rand(1,2)-1,2,1) .* signos;  % Mezcla ortogonal

% titort{1} = 'ortogonales';
% titort{2} = 'no ortogonales';
% suptit{1} = 'Fuentes gaussianas';
% suptit{1} = 'Fuentes laplacianas';

A{1} = (2*rand(2)-1);  % Mezcla no ortogonal
A{1} = [0.6 0.8; 0.5 -0.2];

ss = 1;
aa = 1;

% for ss = 1
%     figure
%     for aa = 2
%% Mezclas de las dos fuentes
X = mezclar(A{aa},s{2*ss-1},s{2*ss}); % Mezclas de las dos fuentes

%% Blanqueo de las mezclas mediante PCA
[E, lambdas] = mipca(X);
% E: matriz cuyas columnas son los versores de las direcciones
%    principales.
% lambdas: es un vector con los autovalores

Dmenos1medio = diag( sqrt(lambdas.^(-1)) );%matriz con las inversas
%de los lambdas en la
%diagonal principal

Xmean = repmat( mean(X,2), 1, size(X,2) ); %media de las señales

Z = Dmenos1medio * E'  * (X - Xmean);       %señales blanqueadas


%% Separación con FastICA
W = fastica(Z); % me devuelve la matriz de separación
% Z = Z  + W' * Xmean;
Y = W' * Z; % Proyecto los datos sobre las direcciones principales

%% Estimando P y D

% Xmean(:,1)

s1y1 = dot(s{2*ss-1}-mean(s{2*ss-1},2),Y(1,:)) ./ size(Y,2)
s1y2 = dot(s{2*ss-1}-mean(s{2*ss},2),Y(2,:)) ./ size(Y,2)
s2y1 = dot(s{2*ss}-mean(s{2*ss-1},2),Y(1,:)) ./ size(Y,2)
s2y2 = dot(s{2*ss}-mean(s{2*ss},2),Y(2,:)) ./ size(Y,2)

auxs1 = [s1y1, s1y2]
auxs2 = [s2y1, s2y2]
[~, s1max] = max(abs(auxs1))
[~, s2max] = max(abs(auxs2))

P = zeros(2) ;
P(1,s1max) = 1;
P(2,s2max) = 1;
P

D = zeros(2);
D(1,1) = auxs1(s1max);
D(2,2) = auxs2(s2max);
D

% Y = Y + W' *  Xmean;

Srecup = D * P * Y;


% TODO invertir la forma de calcular P y D, en vez de de ver cómo llevar de
% las señales recuperadas a las fuentes tengo que ver como llevo las
% fuentes a las señales recuperadas!!!!

%% Graficando


subplot(2,2,1)
scatter(s{2*ss-1}, s{2*ss}); axis equal;
title({'Fuentes'})
xlabel('s_1'); ylabel('s_2');






% subplot(8,2,5)
% plot(X(1,1:100)); ylim([-10, 10]);
% ylabel('x_1');
% 
% subplot(8,2,7)
% plot(X(2,1:100)); ylim([-10, 10]);
% ylabel('x_2');

subplot(2,2,2)
scatter(X(1,:), X(2,:)); axis equal;
title({'Mezclas'})
xlabel('x_1'); ylabel('x_2');





% subplot(8,2,9)
% plot(Z(1,1:100)); ylim([-10, 10]);
% ylabel('z_1');
% 
% subplot(8,2,11)
% plot(Z(2,1:100)); ylim([-10, 10]);
% ylabel('z_2');

subplot(2,2,3)
scatter(Z(1,:), Z(2,:)); axis equal;
title({'Señales blanqueadas'})
xlabel('z_1'); ylabel('z_2');



subplot(2,2,4)
scatter(Y(1,:), Y(2,:)); axis equal;
title({'Señales separadas'})
xlabel('y_1'); ylabel('y_2');





figure
subplot(3,2,1)
plot(s{2*ss-1}(1:60)); ylim([-10, 10]);
ylabel('s_1')

subplot(3,2,2)
plot(s{2*ss}(1:60)); ylim([-10, 10]);
ylabel('s_2');

% subplot(2,2,1)
% plot(X(1,1:60)); ylim([-10, 10]);
% ylabel('x_1');
% 
% subplot(2,2,2)
% plot(X(2,1:60)); ylim([-10, 10]);
% ylabel('x_2');

subplot(3,2,3)
plot(Y(1,1:60)); ylim([-10, 10]);
ylabel('y_1');

subplot(3,2,4)
plot(Y(2,1:60)); ylim([-10, 10]);
ylabel('y_2');


subplot(3,2,5)
plot(Srecup(1,1:60)); ylim([-10, 10]);
ylabel('s.recup_1');

subplot(3,2,6)
plot(Srecup(2,1:60)); ylim([-10, 10]);
ylabel('s.recup_2');





%         A{aa}
%         inv(A{aa})
%         W
%     end
% %     suptitle(suptit{ss})
% end

%%
% En las gráficas se muestra cada una de las etapas requeridas. En las
% gráficas de las mezclas 

%%
% # ¿La matriz de separación $\mathbf{W}$ es la inversa de la matriz de 
% mezcla $\mathbf{A}$ utilizada?
%
% Para responder a la pregunta desarrollo la siguiente expresión:
%
% $\mathbf{y} = \mathbf{W} \mathbf{x} = \mathbf{W} \mathbf{A} \mathbf{s}$
%
% Si la matriz de separación $\mathbf{W}$ fuera la inversa de la matriz de
% mezcla $\mathbf{A}$ entonces utilizando PCA se podría recuperar las 
% fuentes. 
% Sin embargo, en las pruebas anteriores no se corrobora que \mathbf{W} sea
% la inversa de \mathbf{A}. En algunos casos las distribuciones de las 
% señales recuperadas se asemejan pero no conservan las mismas escalas, 
% las orientaciones y las medias originales.
% También es esperable que no pueda ser la inversa porque las señales 
% obtenidas por PCA pueden estar en distinto orden a las fuentes

%%
% # ¿Cómo se afecta este resultado si agrega una componente de ruido 
% gaussiano al modelo generativo?
% 
% for ss = 1:2
%     figure
%     for aa = 1:2
%         X = mezclarconruido(A{aa},s{2*ss-1},s{2*ss}); % Mezclas 
%         
%         W = mipca(X); % Obtengo la Matriz de Proyección de X sobre las
%                       % componentes principales
%         
%         Y = W * X; % Proyecto los datos sobre las direcciones principales
%         
%         subplot(2,3,1+3*(aa-1))
%         scatter(s{2*ss-1}, s{2*ss}); axis equal;
%         title({'Fuentes';['columnas ' titort{aa}]} )
%         xlabel('s_1'); ylabel('s_2');
%         
%         subplot(2,3,2+3*(aa-1))
%         scatter(X(1,:), X(2,:)); axis equal;
%         hold on; 
%         x1m = mean(X(1,:));
%         x2m = mean(X(2,:));
%         plot(x1m + [0 5*W(1,1)],x2m + [0 5*W(1,2)], 'k','LineWidth',2)
%         plot(x1m + [0 5*W(2,1)],x2m + [0 5*W(2,2)], 'k','LineWidth',2)
%         hold off
%         title({'Mezclas';['columnas ' titort{aa}]} )
%         xlabel('x_1'); ylabel('x_2');
%         
%         subplot(2,3,3+3*(aa-1))
%         scatter(Y(1,:), Y(2,:)); axis equal;
%         title({'Señales separadas';['columnas ' titort{aa}]} )
%         xlabel('y_1'); ylabel('y_2');
%         
%         A{aa}
%         inv(A{aa})
%         W
%     end
%     suptitle(suptit{ss})
% end
