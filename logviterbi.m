function [secMasProb, prob] = viterbi( obs, A, B, PI)
%Estimación con viterbi de la secuencia de estado m�s probable secEst, a 
%partir de las observaciones obs, dada la matriz de transici�n A, la matriz
%de observaci�n B, y la matriz inicial PI
%Las probabilidades se manejan como logaritmos

A = log(A);
B = log(B);
PI = log(PI);

nEstados = size(A,1);
nObs = length(obs);
% En el tiempo inicial calculo las lambdas que se utilizar�n m�s adelante
t = 1;
for prox = 1:nEstados
    lambda(t,prox) = PI(prox) + B(obs(t),prox); % * -> +
    caminos{prox} = prox;
end
    
%lambda es un registro auxiliar que recuerda las probabilidades de los 
%camino contiene el camino seguido 

for t = 2:nObs %1:length(obs)
    %En cada instante de la secuencia busco los mejores siguientes pasos
    antCaminos = caminos;
    
    %Para cada estado siguiente
    for prox = 1:nEstados 
        %Viniendo de cada estado anterior
        for ant = 1:nEstados
            %probabilidad de haber llegado hasta ant *
            %probabilidad de saltar entre ant y prox *
            %probabilidad de haber observado obs(t) en prox
            lambdaaux(ant) = lambda(t-1,ant) + A(ant,prox) + B(obs(t),prox); % * -> +
        end
%         TODO cambiar lambdaaux por lambdaaux2
%         lambdaaux = lambdaaux
%         lambdaaux2 = lambda(t-1,:) .* A(:,prox)' * B(obs(t),prox)
        %Para cada estado siguiente me quedo sólo con el mejor camino que 
        %llega hasta él
        [lambdamax, antmax] = max(lambdaaux);
        lambda(t,prox) = lambdamax;
        caminos{prox} = [antCaminos{antmax} prox];
    end
end

[lambdamax, ultmax] = max(lambda(nObs,:));

prob = exp(lambdamax);
secMasProb= caminos{ultmax};

end

