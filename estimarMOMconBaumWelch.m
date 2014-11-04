function [A, B, PI, Aini, Bini] = estimarMOMconBaumWelch( observaciones, nEstados, iterMax )
%[A, B, PI, Aini, Bini] = estimarMOMconBaumWelch( observaciones, nEstados, iterMax )
% Estimación de los parámetros del modelo oculto de markov dado un conjunto
% de observaciones
%
% Cada secuencia de observación debe estar en un renglón, y por el momento,
% deben ser todas del mismo largo
%
% En sucesivas iteraciones se estima la matriz de transición A, la matriz
% de observación B y el vector de probabilidades iniciales PI.
% Los tamaños de A, B e PI se establecen a traves del número de estados
% nEstados y de la cantidad de símbolos observables (presentes en las 
% observaciones).
if nargin < 3
    iterMax = 1000;
end

% La cantidad de símbolos observables se define a partir de las secuencias.
nSimbolos = length(unique(observaciones));

nObservaciones = size(observaciones,1);
nTiempos = size(observaciones,2);

% inicializacion aleatoria
A = rand(nEstados);
B = rand(nSimbolos,nEstados);
for i = 1:nEstados
    A(i,:) = A(i,:) / sum(A(i,:));
    B(:,i) = B(:,i) / sum(B(:,i));
end
PI = rand(1,nEstados);
PI = PI ./ sum(PI);

Aini = A;
Bini = B;

errorMax = 0.2;
error = 100;
iter = 0;

% while (error>errorMax) && (iter < iterMax)
%     iter = iter + 1;
%     Aant = A;
%     Bant = B;
%     PIant = PI;
    
    % Me guio del Hidden Markov Models for Speech Recognition (Huang, Ariki, Jack. 1990)
    
    %% TODO pasar a todas las observaciones
    obs = observaciones(1,:); % primera observacion
    
    %% Calculo hacia adelante
    %% Paso 1: en tiempo inicial
    t=1;
    for i = 1:nEstados
        alfa(t,i) = PI(i) * B(obs(t),i);
    end
    %% Paso 2: calculando alfa sobre todos los tiempos
    for t = 2:nTiempos % en cada instante de tiempo t
        for j = 1:nEstados % para todos los estados j
            % la sumatoria es para sobre todos los estados anteriores i
            alfa(t,j) = sum(alfa(t-1,:) .* A(:,j))*B(obs(t),j); % la suma es inutil pero la utilizo para chequear
         end
    end
    %% Paso 3: calculando la probabilidad final
    probFinalalfa = sum(alfa(nTiempos,:));
    
    
    
    %% Calculo hacia atrás
    %% Paso 1: en tiempo final
    t=nTiempos;
    for i = 1:nEstados
        beta(t,i) = 1 / nEstados; % Definicion arbitraria, revisar
    end
    %% Paso 2: calculando beta sobre todos los tiempos (en reversa)
    for t = nTiempos-1:-1:1 % en cada instante de tiempo t
        for j = 1:nEstados % para todos los estados j
            % la sumatoria es para sobre todos los estados anteriores i
            beta(t,j) = sum(A(:,j)' .* B(obs(t+1),:) .* beta(t+1,:)); % la suma es inutil pero la utilizo para chequear
         end
    end
    %% Paso 3: calculando la probabilidad final
    t = 1;
    probFinalbeta = sum(PI' .* B(obs(t),:) .* beta(t,:));
    
    
    
    
    %% Baum-Welch propiamente dicho
    
%     % Contadores para realizar las estimaciones de A
%     gammai = zeros(nEstados,1); % contador de visitas el estado i
%     gammaij = zeros(nEstados);  % contador de veces que se saltó del estado i al j
    
 
    for t = 1:nTiempos-1 % REVISAR -1
        for i = 1:nEstados % para todos los estados i
            for j = 1:nEstados % para todos los estados j
                gammatij(t,i,j) = alfa(t,i) * A(i,j) * B(obs(t+1),j) * beta(t+1,j) / ...
                                  sum(A(alfa(nTiempos,:)))
            end
        end
    end

%     
%     
%     
%     % Para cada secuencia se estima la secuencia de estado más probable dadas
%     % A, B y PI
%     secEstMasProb = zeros(size(observaciones));
%     nSecEstMasProb = nObservaciones;
%     
%     for obs = 1:nObservaciones
%         secEstMasProb(obs,:) = logviterbi(observaciones(obs),A,B,PI);
%     end
%     
%     
    
    % Contadores para realizar las estimaciones de A
    gammai = zeros(nEstados,1); % contador de visitas el estado i
    gammaij = zeros(nEstados);  % contador de veces que se saltó del estado i al j
    
    for sec = 1:nSecEstMasProb
        for t = 1:(nTiempos-1)
            i = secEstMasProb(sec,t);           % estado actual
            j = secEstMasProb(sec,t+1);         % estado siguiente
            gammai(i) = gammai(i) + 1;          % visitas al estado i
            gammaij(i,j) = gammaij(i,j) + 1;    % saltos de i a j
        end
    end
    % gammai no cuenta el último estado porque desde ese estado no se realiza
    % ningún salto y gammaij estaría contando una vez menos que gammai
    % es decir, se estaría sesgando la estimación de A
    
    
    gammaj = zeros(nEstados,1); % contador de visitas el estado j
    deltaj = zeros(nSimbolos,nEstados); % contador de veces que emitio el simbolo k en el estado j
    for sec = 1:nSecEstMasProb
        for t = 1:nTiempos
            j = secEstMasProb(sec,t);       % estado en tiempo t
            k = observaciones(sec,t);       % simbolo k observado en tiempo t, estando en el estado j
            gammaj(j) = gammai(j) + 1;      % cuenta visitas al estado j
            deltaj(k,j) = deltaj(k,j) + 1;  % cuenta observaciones de k estando en el estado j
        end
    end
    
    
    
    %% TODO está bastante confuso, ver si se puede hacer de otra manera, es una cuenta al fin de cuentas
    
    % replica la lista de estados iniciales, una al lado de la otra, tantas
    % veces como estados haya
    auxEstInicial = repmat(secEstMasProb(:,1), 1, nEstados);
    % cada columna sirve de comparacion para la matriz anterior, cada columna
    % repite un estado como tantas secuencias haya
    auxEstados = repmat([1:nEstados], nSecEstMasProb, 1);
    
    
    % Si gammai o gammaj tienen algún cero arranco otra vez
    if any(gammai == 0) || any(gammaj == 0)
        % inicializacion aleatoria
        A = rand(nEstados);
        B = rand(nSimbolos,nEstados);
        for i = 1:nEstados
            A(i,:) = A(i,:) / sum(A(i,:));
            B(:,i) = B(:,i) / sum(B(:,i));
        end
        PI = rand(1,nEstados);
        PI = PI ./ sum(PI);
    else
        % estimación del vector de estado inicial
        % numSecuenciasQueArrancanEnEstadoi / NumSecuecuencias
        PI = sum(auxEstInicial == auxEstados,1) ./ nSecEstMasProb;
        
        
        % estimación de A
        for i = 1:nEstados
            A(i,:) = gammaij(i,:) / gammai(i);
        end
        
        % estimación de B
        for j = 1:nEstados
            B(:,j) = deltaj(:,j) / gammaj(j);
        end
        % podria estimar A y B en el mismo for pero asi queda más claro
    end
    
%     errorA(iter) = norm(A-Aant);
%     errorB(iter) = norm(B-Bant);
%     errorPI(iter) = norm(PI-PIant);
% 
%     errorTot(iter) = errorA(iter) + errorB(iter) + errorPI(iter); 
%     
%     error = errorTot(iter);
%     
%     iter =iter;
%     A = A
%     B=B
%     C=B
% end
disp(iter)
plot(errorTot)
end
