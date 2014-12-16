% x = quadprog(H,f,A,b,Aeq,beq) resuelve el siguiente problema:
% 
%  min 1/2*x'*H*x + f'*x 
%  
%  sujeto a:   A*x ≤ b
%            Aeq*x = beq             

%% 9.1 Obtiene los alfas del problema linealmente separable

% Se define la funcion objetivo
H = [-1  0 -1;
      0  0  0;
     -1  0 -1];
H = (-1) .* H;      % (-1) para pasar de maximizacion a minimizacion
 
f = (-1).* [1 1 1]; % (-1) para pasar de maximizacion a minimizacion

% Se definen las restricciones
A = (-1) .* eye(3); 
b = [0; 0; 0];
Aeq = [1 -1 -1];
beq = 0;

% Se obtienen los alfas
alfa91 = quadprog(H,f,A,b,Aeq,beq)


%% 9.2 Obtiene los alfas del problema no linealmente separable

% Se define la funcion objetivo
H = [-4  1  0;
      1 -1  1;
      0  1 -4];
H = (-1) .* H;      % (-1) para pasar de maximizacion a minimizacion
 
f = (-1).* [1 1 1]; % (-1) para pasar de maximizacion a minimizacion

% Se definen las restricciones
C = 1000000;
A = [(-1).*eye(3); eye(3)]; 
b = [0; 0; 0; C ; C; C];
Aeq = [1 -1 1];
beq = 0;

% Se obtienen los alfas
alfa92 = quadprog(H,f,A,b,Aeq,beq)
