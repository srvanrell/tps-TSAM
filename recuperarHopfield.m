function y = recuperarHopfield( x, W, iterMax)
% x es un vecotor fila, W es la matriz de pesos de una red Hopfield
if nargin < 3
    iterMax = 500;
end

N = length(x);

y = x;
yant = -y; % asegura entrar al while sin modificar el algoritmo

iter = 0

invgray = flipud(colormap(gray));
figure; colormap(invgray)
yresh = reshape(y,[5 5]);
imagesc(yresh'); axis equal; axis tight;
pause
error = 10000;
errorMax = 0.1;
E = -1000

while (iter < iterMax) && error > errorMax  %~isequal(yant, y) 
    iter = iter + 1
    yant = y;
    Eant = E;
    
    j = randi(N, 1);
    y(j) = sign( y * W(:,j) );
    
    yresh = reshape(y,[5 5]);
    imagesc(yresh'); axis equal; axis tight;
    
    E = - 0.5 * yant * W * y';
    error = abs((E - Eant)/Eant)
    pause
end


while (iter < iterMax)   %~isequal(yant, y) 
    iter = iter + 1
    yant = y;
    Eant = E;
    
    j = randi(N, 1);
    y(j) = sign( y * W(:,j) );
    
    yresh = reshape(y,[5 5]);
    imagesc(yresh'); axis equal; axis tight;
    
    E = - 0.5 * yant * W * y';
    error = abs((E - Eant)/Eant)
    pause
end

end

