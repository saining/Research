clear all;
clc;

m = 160; n = 30;
A = rand(m, n);
b = rand(m,1);
cvx_begin
    variable x(n);
    minimize norm(x,inf);
    subject to
        A*x >= b
cvx_end

