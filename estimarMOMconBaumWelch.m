function [A, B, PI, Aini, Bini] = estimarMOMconBaumWelch( observaciones, nEstados, iterMax )
%[A, B, PI, Aini, Bini] = estimarMOMconBaumWelch( observaciones, nEstados, iterMax )
% Estimaci√≥n de los par√°metros del modelo oculto de markov dado un conjunto
% de observaciones
%
% Cada secuencia de observaci√≥n debe estar en un rengl√≥n, y por el momento,
% deben ser todas del mismo largo
%
% En sucesivas iteraciones se estima la matriz de transici√≥n A, la matriz
% de observaci√≥n B y el vector de probabilidades iniciales PI.
% Los tama√±os de A, B e PI se establecen a traves del n√∫mero de estados
% nEstados y de la cantidad de s√≠mbolos observables (presentes en las 
% observaciones).
if nargin < 3
    iterMax = 100;
end

% La cantidad de s√≠mbolos observables se define a partir de las secuencias.
nSimbolos = length(unique(observaciones));

nObservaciones = size(observaciones,1);
nTiempos = size(observaciones,2);


A = 0; B = 0; PI = 0;% inicializaciÛn temporal ara entrar al while
% inicializacion aleatoria
while ~isempty(find([A; B; PI] == 0, 1)) % me fijo que no haya ceros
    A = rand(nEstados);
    B = rand(nSimbolos,nEstados);
    for i = 1:nEstados
        A(i,:) = A(i,:) / sum(A(i,:));
        B(:,i) = B(:,i) / sum(B(:,i));
    end
    PI = rand(1,nEstados);
    PI = PI ./ sum(PI);
end

Aini = A;
Bini = B;

% errorMax = 0.2;
% error = 100;
% iter = 0;

% while (error>errorMax) && (iter < iterMax)
%     iter = iter + 1;
%     Aant = A;
%     Bant = B;
%     PIant = PI;
    
    % Me guio del Hidden Markov Models for Speech Recognition (Huang, Ariki, Jack. 1990)
    
%% Para cada secuencia observada calculo gammatij y gammati
for n = 1:nObservaciones
    obs = observaciones(n,:); % primera observacion
    
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
            alfa(t,j) = sum( alfa(t-1,:)' .* A(:,j) ) * B(obs(t),j); 
        end
    end
    %% Paso 3: calculando la probabilidad final
%     probFinalalfa = sum(alfa(nTiempos,:));
    
    
    
    %% Calculo hacia atr√°s
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
%     t = 1;
%     probFinalbeta = sum(PI' .* B(obs(t),:) .* beta(t,:));
    


    %% Baum-Welch propiamente dicho
    
%     % Contadores para realizar las estimaciones de A
%     gammai = zeros(nEstados,1); % contador de visitas el estado i
%     gammaij = zeros(nEstados);  % contador de veces que se salt√≥ del estado i al j
    
 
    for t = 1:nTiempos-1 % REVISAR -1
        for i = 1:nEstados % para todos los estados i
            for j = 1:nEstados % para todos los estados j
                gammatij(t,i,j,n) = alfa(t,i) * A(i,j) * B(obs(t+1),j) * ...
                    beta(t+1,j) / sum(alfa(nTiempos,:));
                % suma sobre los k estados en el ultimo instante de tiempo nTiempos
            end
        end
    end
    
    for t = 1:nTiempos % REVISAR
        for i = 1:nEstados % para todos los estados i
                 gammati(t,i,n) = alfa(t,i) * beta(t,i) / ...
                                  sum(alfa(nTiempos,:));
                              % suma sobre los k estados en el ultimo
                              % instante de tiempo nTiempos
        end
    end
    % Forma alternativa de calcular gammati dada en pagina 154 de Huang1990
    gammatiAlternativa(nTiempos,:,n) = gammati(nTiempos,:,n);
    gammatiAlternativa(1:nTiempos-1,:,n) = sum(gammatij(:,:,:,n),3); % la tercera dimension es j 
    
    
    
        % las siguientes deberÌan ser iguales
    probAposterioriAlfa = sum(alfa(nTiempos,:));
    probAposterioriBeta = sum(PI .* B(obs(1),:) .* beta(1,:));
    tarb = 5; % t arbitrario
    probAposterioriAlfaBeta = sum(alfa(tarb,:) .* beta(tarb,:));
    
    [probAposterioriAlfa, probAposterioriBeta, probAposterioriAlfaBeta]
end
    %% hasta antes de aca deberÌa contemplar todas las observaciones
    
    %% reestimaciÛn de A (aij)
    for i = 1:nEstados % para todos los estados i
        for j = 1:nEstados % para todos los estados j
            A(i,j) = sum(sum(gammatij(:,i,j,:),1)) / sum(sum(gammati(1:nTiempos-1,i,:),1));
            % La expresiÛn anterior corresponde a la ecuacion 5.3.17 de
            % Huang1990, en pagina 158
            % la suma interna suma sobre t y la suma externa sobre n 
        end
    end
    
    
    %% reestimaciÛn de B (bij)
    for k = 1:nSimbolos % para todos los simbolos posibles
        for j = 1:nEstados % para todos los estados j
            B(k,j) = 0;
            for n = 1:nObservaciones
                obs = observaciones(n,:);
                B(k,j) = B(k,j) + sum(gammati(obs == k,j,n));
            end
            B(k,j) = B(k,j) / sum(sum(gammati(1:nTiempos,j,:),1));
            % La expresiÛn anterior corresponde a la ecuacion 5.3.18 de
            % Huang1990, en pagina 158
            % en el numerador la suma sobre n est· hecha explÌcita con el for
            % en el denominador la suma interna suma sobre t y la suma externa sobre n
        end
    end
    
    %% reestimaciÛn de PI (pii)
    PI = sum(gammati(1,:,:), 3) / sum(sum(gammati(1,:,:), 3)); 
         % la suma sobre la segunda dimension 
                                 % corresponde a n, la cantidad de 
                                 % observaciones




   
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
% disp(iter)
% plot(errorTot)
end
