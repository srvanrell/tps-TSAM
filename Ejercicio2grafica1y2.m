%% Ejercicio 2
% Clasificación estadística de patrones.

%% Grafica del clasificador lineal
clc; close all; clear all;

x1 = [-3 -1.5 0.5 -1.5 -3 ];
y1 = [-3 -3   0  3    3 ];

x2 = [-1.5  3  3 0.5];
y2 = [-3   -3  0 0];

x3 = [-1.5 0.5 3 3 ];
y3 = [3 0 0 3 ];

hold on
fill(x1,y1,.9 *[1 1 1])
fill(x2,y2,.8 *[1 1 1])
fill(x3,y3,.7 *[1 1 1])

plot([2 2 -1 -1], [1 -1 1 -1], '*k')
text([2 2 -1 -1], [0.8 -1.2 0.8 -1.2],{'p_1','p_2','p_3','p_4'})
text([-2 1 1], [0 2 -2],{'C_1','C_2','C_3'})

hold off
axis square
xlabel('x_1')
ylabel('x_2')
% legend('C_1', 'C_2', 'C_3', 'Location','EastOutside')


%% Grafica del clasificador gaussiano
clc; close all; clear all;

xA = [-10 10 10];
yA = [-10 -10 10];

xB = [-10 10 -10];
yB = [-10 10 10];

% Genero la grilla
N = 100;
x1 = linspace(-10,10,N);
x2 = linspace(-10,10,N);
[X1, X2] = meshgrid(x1, x2);
g1 = (X1 - 3).^2 + X2.^2;
g2 = X1.^2 + (X2 -3).^2;

hold on
fill(xA,yA,.9 *[1 1 1])
fill(xB,yB,.8 *[1 1 1])
contour(X1,X2,max(g1,g2),'k')

text([3 0], [0 3],{'A','B'})

hold off
axis square
xlabel('x_1')
ylabel('x_2')
% legend('C_1', 'C_2', 'C_3', 'Location','EastOutside')
