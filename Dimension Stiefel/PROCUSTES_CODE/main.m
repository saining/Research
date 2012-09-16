n = 100; p = 100;
A = randn(n);
B = A*eye(n,p);
Y0 = eye(n,p); % Known solution Y0

H = 0.1*randn(n,p); 
H = H - Y0*(H'*Y0); % small tangent vector H at Y0

Y = stiefgeod(Y0,H); % Initial guess Y (close to know solution Y0)
% Newton iteration (demonstrate quadratic convergence)

d = norm(Y-Y0,'fro')

while d > sqrt(eps)
    Y = stiefgeod(Y,procrnt(Y,A,B));
    d = norm(Y-Y0,'fro')
end

% 
% n = 5; p = 3;
% A = randn(n);
% B = A*eye(n,p);
% Y0 = eye(n,p); % Known solution Y0
% 
% H = 0.1*randn(n,p); 
% H = H - Y0*(H'*Y0); % small tangent vector H at Y0
% 
% Y = stiefgeod(Y0,H); % Initial guess Y (close to know solution Y0)
% % Newton iteration (demonstrate quadratic convergence)
% 
% d = norm(Y-Y0,'fro')
% 
% while d > sqrt(eps)
%     Y = stiefgeod(Y,procrnt(Y,A,B));
%     d = norm(Y-Y0,'fro')
% end