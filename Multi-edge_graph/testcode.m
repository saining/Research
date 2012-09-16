clear all;
clc;

m = 100; n = 80;
A = randn(m,n);
B = randn(m,n);

cvx_begin
    expression temp;
    expression obj(m);
    variable X(n,n);
    temp = A*X;
    for i = 1:m,
       obj(i) = norm(temp(i,:), 1);
    end;
    
    minimize max(max(0,obj));
    
    subject to
        sum(sum(X)) == 1;
    
cvx_end

res = A*X;
imagesc(abs(res));