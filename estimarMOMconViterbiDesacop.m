function [A, B, PI, Aini, Bini] = estimarMOMconViterbi( observaciones, nEstados, iterMax )
%[A, B, ini] = estimarMOMConViterbi( secuencias )
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

while (error>errorMax) && (iter < iterMax)
    iter = iter + 1;
    Aant = A;
    Bant = B;
    PIant = PI;
    
    % Para cada secuencia se estima la secuencia de estado más probable dadas
    % A, B y PI
    secEstMasProb = zeros(size(observaciones));
    nSecEstMasProb = nObservaciones;
    
    for obs = 1:nObservaciones
        secEstMasProb(obs,:) = logviterbi(observaciones(obs),A,B,PI);
    end
    
    
    
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
    
    % Si gammai o gammaj tienen algún cero arranco otra vez
    if any(gammai == 0) 
        % inicializacion aleatoria
        A = rand(nEstados);
        for i = 1:nEstados
            A(i,:) = A(i,:) / sum(A(i,:));
        end
        PI = rand(1,nEstados);
        PI = PI ./ sum(PI);
    else
        % replica la lista de estados iniciales, una al lado de la otra, tantas
        % veces como estados haya
        auxEstInicial = repmat(secEstMasProb(:,1), 1, nEstados);
        % cada columna sirve de comparacion para la matriz anterior, cada columna
        % repite un estado como tantas secuencias haya
        auxEstados = repmat([1:nEstados], nSecEstMasProb, 1);
    
        % estimación del vector de estado inicial
        % numSecuenciasQueArrancanEnEstadoi / NumSecuecuencias
        PI = sum(auxEstInicial == auxEstados,1) ./ nSecEstMasProb;
        
        
        % estimación de A
        for i = 1:nEstados
            A(i,:) = gammaij(i,:) / gammai(i);
        end
    end
    
    
    for obs = 1:nObservaciones
        secEstMasProb(obs,:) = logviterbi(observaciones(obs),A,B,PI);
    end
    
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
    
    
    
    % Si gammai o gammaj tienen algún cero arranco otra vez
    if any(gammaj == 0)
        % inicializacion aleatoria
        B = rand(nSimbolos,nEstados);
        for i = 1:nEstados
            B(:,i) = B(:,i) / sum(B(:,i));
        end
    else
        % estimación de B
        for j = 1:nEstados
            B(:,j) = deltaj(:,j) / gammaj(j);
        end
        % podria estimar A y B en el mismo for pero asi queda más claro
    end
    
    errorA(iter) = norm(A-Aant);
    errorB(iter) = norm(B-Bant);
    errorPI(iter) = norm(PI-PIant);

    errorTot(iter) = errorA(iter) + errorB(iter) + errorPI(iter); 
    
    error = errorTot(iter);
    
    iter =iter;
%     A = A
%     B=B
%     C=B
end
disp(iter)
plot(errorTot)
end
