% x = quadprog(H,f) returns a vector x that minimizes 1/2*x'*H*x + f'*x. H  must be positive definite for the problem to have a finite minimum.
% 
% x = quadprog(H,f,A,b) minimizes 1/2*x'*H*x + f'*x subject to the restrictions A*x ≤ b. A is a matrix of doubles, and b is a vector of doubles.
% 
% x = quadprog(H,f,A,b,Aeq,beq) solves the preceding problem subject to the additional restrictions Aeq*x = beq. Aeq is a matrix of doubles, and beq is a vector of doubles. If no inequalities exist, set A = [] and b = [].
% 
% x = quadprog(H,f,A,b,Aeq,beq,lb,ub) solves the preceding problem subject to the additional restrictions lb ≤ x ≤ ub. lb and ub are vectors of doubles, and the restrictions hold for each x component. If no equalities exist, set Aeq = [] and beq = [].


H = [0.5 0 0.5;
     0 0 0;
     0.5 0 0.5];
H = (-1) .* H;
 
f = (-1).* [1 1 1];

A = (-1) .* eye(3);
b = [0; 0; 0];

Aeq = [1 -1 -1];
beq = 0;

alfa = quadprog(H,f,A,b,Aeq,beq)