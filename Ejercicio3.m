%% Ejercicio 3
% Análisis estadístico de datos - PCA.
clc; close all; clear all;


%% Ejercicio 3.1
% Implemente el algoritmo de PCA.
%
% Debajo se copia el código fuente de la función implementada. La
% descripción de la misma se encuentra dentro del código.

%% mipca.m
dbtype mipca.m

%% Ejercicio 3.2
% Escriba un programa que le permita generar datos aleatorios $\mathbf(x)$
% a partir del siguiente modelo generativo lineal: 
% $\mathbf(x) = \mathbf(A) \mathbf(s)$, donde $\mathbf(s)$ es el vector de
% fuentes (aleatorio) y $\mathbf(A)$ es la matriz de mezcla.
%
% Debajo se copia el código fuente de la función implementada. La
% descripción de la misma se encuentra dentro del código.

%% mezclar.m
dbtype mezclar.m

%% Ejercicio 3.3
% A partir de datos de dos mezclas, obtenidos mediante dos fuentes y una
% matriz de mezcla aleatoria, utilice PCA para lo siguiente:
% 
% # Pruebe con fuentes con distribución gaussiana y laplaciana, para
% matrices de mezcla con columnas ortogonales y no ortogonales.
% # Para cada caso de los anteriores y cada etapa (fuentes, mezclas,
% señales separadas) dibuje un gráfico de dispersión de las variables.
% # Luego de la separación obtenga la matriz $\mathbf{W}$ correspondiente.

N = 300;

% Fuentes gaussianas y laplacianas 
s{1} = randgauss1D(1, 1, N)'; 
s{2} = randgauss1D(3, 3, N)';
s{3} = randlap(N, 2 ,2)';
s{4} = randlap(N, 5 ,0.9)';
s{5} = randgauss1D(1, 1, N)'; 
s{6} = randlap(N, 2 ,2)';

% Se corroboran los signos para impedir que ambas mezclas sean
% proporcionales
signos = ones(2);
while isequal(signos(1,:),signos(2,:)) || isequal(signos(1,:), -signos(2,:))
    signos = sign(rand(2)-0.5);
end

% Generacion aleatoria de las matrices de mezcla
A{1} = repmat(2*rand(1,2)-1,2,1) .* signos;% Mezcla con columnas ortogonales
A{2} = (2*rand(2)-1) .* signos;            % Mezcla no ortogonal
titort{1} = 'ortogonales';
titort{2} = 'no ortogonales';
suptit{1} = 'Fuentes gaussianas';
suptit{2} = 'Fuentes laplacianas';
suptit{3} = 'Fuente gaussiana y laplaciana';

for ss = 1:3
    figure
    for aa = 1:2
        X = mezclar(A{aa},s{2*ss-1},s{2*ss}); % Mezcla las señales
        x1m = mean(X(1,:)); % media de la primera dimension
        x2m = mean(X(2,:)); % media de la segunda dimension
        
        W = mipca(X); % Obtengo la Matriz de Proyección de X sobre las
                      % direcciones principales, versores por columnas
        
        Y = W' * X; % Proyecto los datos sobre las direcciones principales
        % y_1  = w_11 * x_1 + w_21 * x_2
        % y_2  = w_12 * x_2 + w_22 * x_2
        
        subplot(2,3,1+3*(aa-1))
        scatter(s{2*ss-1}, s{2*ss}); axis equal;
        title({'Fuentes';['columnas ' titort{aa}]} )
        xlabel('s_1'); ylabel('s_2');
        
        subplot(2,3,2+3*(aa-1))
        scatter(X(1,:), X(2,:)); axis equal;
        hold on; 
        plot(x1m + [0 5*W(1,1)],x2m + [0 5*W(2,1)], 'k','LineWidth',2)
        plot(x1m + [0 5*W(1,2)],x2m + [0 5*W(2,2)], 'k','LineWidth',2)
        hold off
        title({'Mezclas';['columnas ' titort{aa}]} )
        xlabel('x_1'); ylabel('x_2');
        
        subplot(2,3,3+3*(aa-1))
        scatter(Y(1,:), Y(2,:)); axis equal;
        title({'Señales separadas';['columnas ' titort{aa}]} )
        xlabel('y_1'); ylabel('y_2');
        
        Ainv  = inv(A{aa});
        disp([suptit{ss} ', columnas ' titort{aa}])
        fprintf(['A = [%0.2f %0.2f],\t Ainv = [%0.2f %0.2f],\t W = [%0.2f %0.2f]\n'...
                 '    [%0.2f %0.2f],\t        [%0.2f %0.2f],\t     [%0.2f %0.2f]\n\n'],...
                 A{aa}(1,:), Ainv(1,:), W(1,:), A{aa}(2,:), Ainv(2,:), W(2,:) );
    end
    suptitle(suptit{ss})
end

%%
% En las figuras \ref{....} se muestra cada una de las etapas requeridas. 
% En las gráficas de las mezclas se dibujan las direcciones principales
% identificadas mediante PCA.

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
% Sin embargo, en las pruebas anteriores no se corrobora que $\mathbf{W}$ 
% sea la inversa de \mathbf{A}. 
% Al proyectar sobre las direcciones principales se provoca una 
% rotación de la distribución de mezclas y esto no asegura que se
% recuperen las fuentes.
% El único caso en el que podría ser posible recuperar las fuentes es si la
% mezcla misma era una rotación de la distribución de las fuentes, en cuyo
% caso, si las direcciones principales coinciden con las direcciones de las
% fuentes se podría llegar a recuperar las mismas.
%
% La matriz de covarianza de las señales proyectadas no se ven afectadas
% por las medias de las mezclas. Sin embargo, las medias de las señales
% proyectadas si cambian de acuerdo al valor de las medias de las mezclas.
% Esto no afecta la forma de la distribución sólo la desplaza a otro punto
% del espacio. Quizá sería una buena practica quitarle la media a las
% señales recuperadas.


%%
% # ¿Cómo se afecta este resultado si agrega una componente de ruido 
% gaussiano al modelo generativo?
%
% La situación antes descripta no cambia porque el modelo contenga o no 
% ruido.
% PCA no necesita realizar ninguna hipótesis respecto al modelo que generó
% los datos, sólo permite observar los datos dados desde otra perspectiva.
% 

% for ss = 1:2
%     figure
%     for aa = 1:2
%         X = mezclarconruido(A{aa},s{2*ss-1},s{2*ss}); % Mezclas 
%         
%         W = mipca(X); % Obtengo la Matriz de Proyección de X sobre las
%                       % componentes principales
%         
%         Y = W' * X; % Proyecto los datos sobre las direcciones principales
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
%         plot(x1m + [0 5*W(1,1)],x2m + [0 5*W(2,1)], 'k','LineWidth',2)
%         plot(x1m + [0 5*W(1,2)],x2m + [0 5*W(2,2)], 'k','LineWidth',2)
%         hold off
%         title({'Mezclas';['columnas ' titort{aa}]} )
%         xlabel('x_1'); ylabel('x_2');
%         
%         subplot(2,3,3+3*(aa-1))
%         scatter(Y(1,:), Y(2,:)); axis equal;
%         title({'Señales separadas';['columnas ' titort{aa}]} )
%         xlabel('y_1'); ylabel('y_2');
%         
%         Ainv  = inv(A{aa});
%         disp([suptit{ss} ', columnas ' titort{aa}])
%         fprintf(['A = [%0.2f %0.2f],\t Ainv = [%0.2f %0.2f],\t W = [%0.2f %0.2f]\n'...
%                  '    [%0.2f %0.2f],\t Ainv = [%0.2f %0.2f],\t     [%0.2f %0.2f]\n\n'],...
%                  A{aa}(1,:), Ainv(2,:), W(1,:), A{aa}(2,:), Ainv(2,:), W(2,:) );
%     end
%     suptitle(suptit{ss})
% end
