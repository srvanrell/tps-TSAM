%% Ejercicio 2
% Clasificación estadística de patrones.
%%
% 
% # Sea un clasificador geométrico lineal definido por:
% 
% * asdasd
% * asdas
% * asdasdfa
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

%%

% Genero la grilla
% N = 100
% x1 = linspace(-2,2,N);
% x2 = linspace(-2,2,N);
% for i = 1:N
%     for j = 1:N
%         g1(i,j) = - x1(i);
%         g2(i,j) =   x1(i) + x2(j) -1;
%         g3(i,j) =   x1(i) - x2(j) -1;
%     end
% end
% 
% hold on
% surf(x1,x2,g1)
% surf(x1,x2,g2)
% surf(x1,x2,g3)
% hold off

%%
% Cargo los datos (patrones con sus clases respectivas)
data = load('gaussDATA.txt', '-ascii');
x = data(:,1:2); % patrones
c = data(:,3);   % identificador de clase
N = length(c);   % cantidad de ejemplos

c1 = find(c== 1); % indices de clase 1
c2 = find(c== 2); % indices de clase 2
c3 = find(c== 3); % indices de clase 3
c4 = find(c== 4); % indices de clase 4


hold on
plot(x(c1,1), x(c1,2), 'ok')
plot(x(c2,1), x(c2,2), 'xk')
plot(x(c3,1), x(c3,2), 'dk')
plot(x(c4,1), x(c4,2), 'sk')
hold off

xlabel('x_1'); ylabel('x_2');
legend('clase 1','clase 2','clase 3','clase 4')
title('Distribucion de los patrones separados por clase')

%%
% Por la gráfica se deduce que deberán utilizarse gaussianas con media
% desconocida y covarianza no isotropica desconocida

% Estimación de los parámetros para cada clase
% medias
u1 = mean(x(c1,:));
u2 = mean(x(c2,:));
u3 = mean(x(c3,:));
u4 = mean(x(c4,:));
% matrices de covarianzas
sig1 = cov(x(c1,:));
sig2 = cov(x(c2,:));
sig3 = cov(x(c3,:));
sig4 = cov(x(c4,:));

cn = zeros(size(c));

for n = 1:N
    xn = x(n,:); % voy leyendo de a un dato
    
    % Calculo los valores de las funciones discriminantes para xn
    g1 = mvnpdf(xn, u1, sig1);
    g2 = mvnpdf(xn, u2, sig2);
    g3 = mvnpdf(xn, u3, sig3);
    g4 = mvnpdf(xn, u4, sig4);
    
    % Busco cual es la clase ganadora, asigno 0 si cae en la frontera
    if     g1 > max([g2 g3 g4])
        cn(n) = 1;
    elseif g2 > max([g1 g3 g4])
        cn(n) = 2;
    elseif g3 > max([g1 g2 g4])
        cn(n) = 3;
    elseif g4 > max([g1 g2 g3])
        cn(n) = 4;
    else 
        cn(n) = 0;
    end
end

% busco cuales patrones fueron confundidos al clasificar
cwrong = find(c-cn); % patrones mal identificados
cright = find((c-cn) == 0); % patrones identificados correctamente

fprintf('La tasa de aciertos es de %0.2f %%\n',100*nnz(cright)/N); 
% disp(['La tasa de aciertos es de ' num2str(100*nnz(cright)/N) '%'])

hold on
plot(x(cwrong,1), x(cwrong,2), '.r')
hold off


T = 100; % cantidad de patrones de testeo
xtest = zeros(T,2);
ctest = zeros(T,1);
cn = zeros(size(ctest));
for i=1:T
    ctest(i) = randi([1 4]);
    
    if     ctest(i) == 1
        xtest(i,:) = mvnrnd(u1,sig1);
    elseif ctest(i) == 2
        xtest(i,:) = mvnrnd(u2,sig2);
    elseif ctest(i) == 3
        xtest(i,:) = mvnrnd(u3,sig3);
    elseif ctest(i) == 4
        xtest(i,:) = mvnrnd(u4,sig4);
    end
    
    % Calculo los valores de las funciones discriminantes para xn
    g1 = mvnpdf(xtest(i,:), u1, sig1);
    g2 = mvnpdf(xtest(i,:), u2, sig2);
    g3 = mvnpdf(xtest(i,:), u3, sig3);
    g4 = mvnpdf(xtest(i,:), u4, sig4);
    
    % Busco cual es la clase ganadora, asigno 0 si cae en la frontera
    if     g1 > max([g2 g3 g4])
        cn(i) = 1;
    elseif g2 > max([g1 g3 g4])
        cn(i) = 2;
    elseif g3 > max([g1 g2 g4])
        cn(i) = 3;
    elseif g4 > max([g1 g2 g3])
        cn(i) = 4;
    else 
        cn(n) = 0;
    end
end


c1 = find(ctest== 1); % indices de clase 1
c2 = find(ctest== 2); % indices de clase 2
c3 = find(ctest== 3); % indices de clase 3
c4 = find(ctest== 4); % indices de clase 4


figure
hold on
plot(xtest(c1,1), xtest(c1,2), 'ok')
plot(xtest(c2,1), xtest(c2,2), 'xk')
plot(xtest(c3,1), xtest(c3,2), 'dk')
plot(xtest(c4,1), xtest(c4,2), 'sk')
hold off

xlabel('x_1'); ylabel('x_2');
legend('clase 1','clase 2','clase 3','clase 4')
title('Distribucion de los patrones de testeo separados por clase')


% busco cuales patrones fueron confundidos al clasificar
cwrong = find(ctest-cn); % patrones mal identificados
cright = find((ctest-cn) == 0); % patrones identificados correctamente

fprintf('En testeo, la tasa de aciertos es de %0.2f %%\n',100*nnz(cright)/T); 
% disp(['La tasa de aciertos es de ' num2str(100*nnz(cright)/N) '%'])

hold on
plot(xtest(cwrong,1), xtest(cwrong,2), '.r')
hold off


x1 = linspace(-2,10);
x2 = linspace(-4,8);
[X1,X2] = meshgrid(x1,x2);
for i = 1:100
    for j = 1:100
        xn = [x1(i) x2(j)];
        gtest1(i,j) = mvnpdf(xn, u1, sig1);
        gtest2(i,j) = mvnpdf(xn, u2, sig2);
        gtest3(i,j) = mvnpdf(xn, u3, sig3);
        gtest4(i,j) = mvnpdf(xn, u4, sig4);
    end
end

maxgtest = cat(3, gtest1, gtest2, gtest3, gtest4);


contour(X2,X1,max(maxgtest,[],3))
% Z = mvnpdf([xtest(i,:), u1, sig1);
%     g2 = mvnpdf(xtest(i,:), u2, sig2);
%     g3 = mvnpdf(xtest(i,:), u3, sig3);
%     g4 = mvnpdf(xtest(i,:), u4, sig4);sin(X)+cos(Y);
% % 
% figure
% contour(X,Y,Z)

