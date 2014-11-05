function y = recuperarHopfield( y0, W, iterMax, graficar)
% y = recuperarHopfield( y0, W, iterMax, graficar)
%   y0 es el patrón dado a la entrada, a partir del cuál se recupera y.
%      Debe ser un vector fila. 
%   W es la matriz de pesos de la red de Hopfield.
%   iterMax son las iteraciones máximas permitidas, por defecto son 100.
%   graficar es un valor lógico que grafica cada estado intermedio. 
%      Por defecto es falso.
if nargin < 3
    iterMax = 100; % iteraciones máximas
end
if nargin < 4
    graficar = 0;  % deshabilita la graficación paso por paso
end

N = length(y0); %
iter = 0;       % contador de iteraciones
y = y0;         % se inicializa el patrón recuperado igual al patrón dado
yant = -y;      % asegura entrar al while sin modificar el algoritmo

% Gráfica del patrón de entrada
if graficar
    invgray = flipud(colormap(gray));
    figure; colormap(invgray)
    imagesc(reshape(y,[5 5])'); axis equal; axis tight;
    pause
end

% El algoritmo itera hasta que el patrón recuperado cumple con y = y * W
while (iter < iterMax) && ~isequal(yant, y) 
    iter = iter + 1;        % contador de iteraciones
    yant = y;               % se guarda el patrón de la iteración anterior
    y = sign(yant * W);     % se obtiene el nuevo patrón
    yEnCero = find(y == 0); % posiciones dónde y se hace cero
    y(yEnCero) = yant(yEnCero); % si y es 0 se mantiene el anterior valor 
    
    % Gráfica del patrón recuperado hasta esta iteración
    if graficar
        imagesc(reshape(y,[5 5])'); axis equal; axis tight;
        pause
    end
end

end

