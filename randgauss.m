function x = randgauss()
%RANDGAUSS() genera un número pseudo aleatorio de una distribución 
% gaussiana estándar. 
%  El número x es generado por el método polar de Box-Muller a partir de 
%  dos números pseudo aleatorios independentes y uniformemente 
%  distribuidos en un intervalo cerrado [−1, +1]
%  Referencias: 
%  - Box, G. E. P. and Muller, M. E. "A Note on the Generation of Random 
%    Normal Deviates." Ann. Math. Stat. 29, 610-611, 1958.
%  - Bell, J.,  "Algorithm 334: Normal random deviates", Communications 
%    of the ACM, vol. 11, No. 7. 1968

s=1; % condición para ingresar al while
while (s >= 1) || (s == 0)
    % u1 y u2 independientes y distribuidos uniformemente en [-1, +1]
    u1 = 2.0 * rand() - 1.0;
    u2 = 2.0 * rand() - 1.0;
	
    s = u1 .* u1 + u2 .* u2; % variable a evaluar
end
% a la salida s está uniformemente distribuido en (0, +1)

% número aleatorio de una distribución normal estándar
x = u1 .* sqrt( (-2.0 .* log( s ) ) ./ s ); 

end

