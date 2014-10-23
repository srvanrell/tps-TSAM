%% Ejercicio 3
% Análisis estadístico de datos - PCA.
clc; close all; clear all;


%% 1
% Implemente el algoritmo de PCA.
%
% Debajo se copia el código fuente de la función implementada. La
% descripción de la misma se encuentra dentro del mismo código.

%% mipca.m
dbtype mipca.m

%% 2
% Escriba un programa que le permita generar datos aleatorios $\mathbf(x)$
% a partir del siguiente modelo generativo lineal: 
% $\mathbf(x) = \mathbf(A) \mathbf(s)$, donde $\mathbf(s)$ es el vector de
% fuentes (aleatorio) y $\mathbf(A)$ es la matriz de mezcla.

%% mezclar.m
dbtype mezclar.m

%% 3
% A partir de datos de dos mezclas, obtenidos mediante dos fuentes y una
% matriz de mezcla aleatoria, utilice PCA para lo siguiente:
% 
% # Pruebe con fuentes con distribución gaussiana y laplaciana, para
% matrices de mezcla con columnas ortogonales y no ortogonales.
% # Para cada caso de los anteriores y cada etapa (fuentes, mezclas,
% señales separadas) dibuje un gráfico de dispersión de las variables.
% # Luego de la separación obtenga la matriz $\mathbf{W}$ correspondiente.

N = 1000;

% Fuentes gaussianas y laplacianas 
s{1} = randgauss1D(1, 1, N)'; 
s{2} = randgauss1D(3, 3, N)';
s{3} = randlap(N, 2 ,2)';
s{4} = randlap(N, 5 ,0.9)';

% Se corroboran los signos para impedir que las mezclas sean iguales
signos = ones(2);
while isequal(signos(1,:),signos(2,:)) || isequal(signos(1,:), -signos(2,:))
    signos = sign(rand(2)-0.5);
end
% Generacacion de las matrices de mezcla
A{1} = repmat(2*rand(1,2)-1,2,1) .* signos;  % Mezcla ortogonal
A{2} = (2*rand(2)-1) .* signos;  % Mezcla no ortogonal
titort{1} = 'ortogonales';
titort{2} = 'no ortogonales';
suptit{1} = 'Fuentes gaussianas';
suptit{2} = 'Fuentes laplacianas';

for ss = 1:2
    figure
    for aa = 1:2
        X = mezclar(A{aa},s{2*ss-1},s{2*ss}); % Mezclas 
        
        W = mipca(X); % Obtengo la Matriz de Proyección de X sobre las
                      % componentes principales
        
        Y = W * X; % Proyecto los datos sobre las direcciones principales
        
        subplot(2,3,1+3*(aa-1))
        scatter(s{2*ss-1}, s{2*ss}); axis equal;
        title({'Fuentes';['columnas ' titort{aa}]} )
        xlabel('s_1'); ylabel('s_2');
        
        subplot(2,3,2+3*(aa-1))
        scatter(X(1,:), X(2,:)); axis equal;
        hold on; 
        x1m = mean(X(1,:));
        x2m = mean(X(2,:));
        plot(x1m + [0 5*W(1,1)],x2m + [0 5*W(1,2)], 'k','LineWidth',2)
        plot(x1m + [0 5*W(2,1)],x2m + [0 5*W(2,2)], 'k','LineWidth',2)
        hold off
        title({'Mezclas';['columnas ' titort{aa}]} )
        xlabel('x_1'); ylabel('x_2');
        
        subplot(2,3,3+3*(aa-1))
        scatter(Y(1,:), Y(2,:)); axis equal;
        title({'Señales separadas';['columnas ' titort{aa}]} )
        xlabel('y_1'); ylabel('y_2');
        
        A{aa}
        inv(A{aa})
        W
    end
    suptitle(suptit{ss})
end

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

for ss = 1:2
    figure
    for aa = 1:2
        X = mezclarconruido(A{aa},s{2*ss-1},s{2*ss}); % Mezclas 
        
        W = mipca(X); % Obtengo la Matriz de Proyección de X sobre las
                      % componentes principales
        
        Y = W * X; % Proyecto los datos sobre las direcciones principales
        
        subplot(2,3,1+3*(aa-1))
        scatter(s{2*ss-1}, s{2*ss}); axis equal;
        title({'Fuentes';['columnas ' titort{aa}]} )
        xlabel('s_1'); ylabel('s_2');
        
        subplot(2,3,2+3*(aa-1))
        scatter(X(1,:), X(2,:)); axis equal;
        hold on; 
        x1m = mean(X(1,:));
        x2m = mean(X(2,:));
        plot(x1m + [0 5*W(1,1)],x2m + [0 5*W(1,2)], 'k','LineWidth',2)
        plot(x1m + [0 5*W(2,1)],x2m + [0 5*W(2,2)], 'k','LineWidth',2)
        hold off
        title({'Mezclas';['columnas ' titort{aa}]} )
        xlabel('x_1'); ylabel('x_2');
        
        subplot(2,3,3+3*(aa-1))
        scatter(Y(1,:), Y(2,:)); axis equal;
        title({'Señales separadas';['columnas ' titort{aa}]} )
        xlabel('y_1'); ylabel('y_2');
        
        A{aa}
        inv(A{aa})
        W
    end
    suptitle(suptit{ss})
end
