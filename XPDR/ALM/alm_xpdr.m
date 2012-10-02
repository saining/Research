function [W] = alm_xpdr(X, P, lambda)

tol = 1e-8;
maxIter = 1e6;
[d n] = size(X);
[m n] = size(P);
rho = 1.1;
max_mu = 1e10;
mu = 1e-6;
XX = X*X';
PP = P'*P;
PXX = P*XX;
invPP = inv(PP);

W = zeros(n,n);
Z = zeros(n,n);
Zt = zeros(m,n);

Y1 = zeros(n,n);
Y2 = zeros(m,n);
%% Main

iter = 0;

disp(['initial,rank=' num2str(rank(W)]);
while iter<maxIter,
	iter = iter + 1;
	%update W
	temp = Z + Y1/mu;
	[U,sigma,V] = svd(temp,'econ');
	sigma = diag(sigma);

	%Soft thresholding
	svp = length(find(sigma>1/mu));
    if svp>=1
        sigma = sigma(1:svp)-1/mu;
    else
        svp = 1;
        sigma = 0;
    end

    W = U(:, 1:svp)*diag(sigma)*V(:,1:svp)';

    %update Z
    Z = invPP*(P'*Zt + 0.5*P'*Y2 - 0.5*Y1);

    %update Zt
    Zt = (2*PXX + mu*P*Z - Y2)*inv(2*XX + mu*eye(n,n));



    leq1 = Z-W;
    leq2 = Zt-P*Z;
    stopC = max(max(max(abs(leq1))),max(max(abs(leq2))));

    if iter==1 || mod(iter,50)==0 || stopC<tol
        disp(['iter ' num2str(iter) ',mu=' num2str(mu,'%2.1e') ...
            ',rank=' num2str(rank(Z,1e-3*norm(Z,2))) ',stopALM=' num2str(stopC,'%2.3e')]);
    end
    
    if stopC<tol 
        disp('LRR done.');
        break;
    else
        Y1 = Y1 + mu*leq1;
        Y2 = Y2 + mu*leq2;
        mu = min(max_mu,mu*rho);
    end
end;