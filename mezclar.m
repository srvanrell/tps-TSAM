function X = mezclar( A, s1, s2 )
%MEZCLAR X = ( A, s1, s2 ) dada la matriz de mecla A y las fuentes s1 y s2 
% (vectores) se generan dos mezclas x1 y x2 (cada una en un renglón de X).

if size(s1,1) ~= 1
    s1 = s1'; % convierte s1 en un vector horizontal si no lo es
end
if size(s2,1) ~= 1
    s2 = s2'; % convierte s2 en un vector horizontal si no lo es
end

S = vertcat(s1,s2);
X = A * S;
end

