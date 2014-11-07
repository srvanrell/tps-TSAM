function p = funcbr( X, mu )
% p(n,j)=fbr(X,mu)= exp(-0.5 * norm( xn-muj ).^2);
p = zeros(size(X,1),size(mu,1));

phi = @(xn,muj) exp(-0.5 * norm( xn-muj ).^2);
for n = 1:size(X,1)
    for j = 1:size(mu,1)
        p(n,j) = phi(X(n,:),mu(j,:));
    end
end

end