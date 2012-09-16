function H = procrnt(Y,A,B)
%PROCRNT Newton Step on Stiefel Manifold for 1/2*norm(A*Y-B,'fro')^2.
% H = PROCRNT(Y,A,B) computes the Newton step on the Stiefel manifold
% for the function 1/2*norm(A*Y-B,'fro')^2, where Y'*Y = eye(size(Y,2)).
[n,p] = size(Y);
AA = A'*A; 
FY = AA*Y - A'*B; 
YFY = Y'*FY; 
G = FY - Y*YFY';
% Linear conjugate gradient to solve a Newton step

dimV = p*(p-1)/2 + p*(n-p); % == dim Stiefel manifold

% This linear CG code is modified directly from Golub and Van Loan [45]
H = zeros(size(Y)); 
R1 = -G; 
P = R1; 
P0 = zeros(size(Y));
for k=1:dimV
    normR1 = sqrt(stiefip(Y,R1,R1));
    if normR1 < prod(size(Y))*eps,
        break; 
    end
    
    if k == 1, beta = 0; 
    else,
        beta = (normR1/normR0)^2; 
    end
    P0 = P; 
    P = R1 + beta*P; 
    FYP = FY'*P; 
    YP = Y'*P;
    
    LP = AA*P - Y*(P'*AA*Y) ... % Linear operation on P
        - Y*((FYP-FYP')/2) - (P*YFY'-FY*YP')/2 - (P-Y*YP)*(YFY/2);
    alpha = normR1^2/stiefip(Y,P,LP); 
    
    H = H + alpha*P;
    
    R0 = R1; 
    normR0 = normR1; 
    R1 = R1 - alpha*LP;
end