% EGSSC is aimed to achieve following objective:
% min C(p,q) = \sum_{i=1}^l KL(r_i||q_i) 
%               + mu*\sum_{i=1}^m \sum_{j \in N(i)} w_{ij}*KL(p_i||q_j)
%               - nu*\sum_{i=1}^m H(p_i)
% 
%
% @input: r: a (c)x(l) matrix, c is the number of classes, l is the number of
% labeled data. 
% W: the graph matrix, size (l+u)x(l+u). Here u is the number of unlabeled
% data. 
% alpha, mu, nu: parameters
%
% @output: predicted label distribution
%
function [p,q] = EGSSC(r,W,opt)

[alpha,mu,nu,maxIter,tol] = checkOpt(opt);

%%% initialization
[nclass,ntrain] = size(r);
nsample = size(W,1);
ntest = nsample - ntrain;

r = [r, zeros(nclass,ntest ) ];
p = ones(nclass,nsample)/nclass;
q = p;
W = W + alpha*eye(nsample);
iter = 0;

delta = double((1:nsample)'<=ntrain );

fval = zeros(maxIter,1);
fval0 = calObjVal(r,p,q,W,mu,nu,ntrain);

fprintf('iter \t\t obj value \t \n' );
fprintf('%d\t\t %f\t\n', 0, fval0 );

%%% main iteration
while iter < maxIter
    
    iter = iter + 1;
    %%% updata p
    gamma = nu + mu*sum(W,2);
    for i = 1:nsample        
        p(:,i) = exp(mu/gamma(i)*sum(repmat(W(i,:),nclass,1 ).*log(q+eps ),2));        
    end
    p = p./repmat(sum(p,1)+eps,nclass,1);
    
    %%% updata q
    for i = 1:nsample
        q(:,i) = r(:,i) + mu*sum(repmat(W(:,i)',nclass,1 ).*p,2 );
        q(:,i) = q(:,i)/(delta(i) + mu*sum(W(:,i)) );
    end
    
    %%% calculate the objective function value
    fval(iter) = calObjVal(r,p,q,W,mu,nu,ntrain);
    
    %%% output    
    fprintf('%d\t\t %f\t\n', iter, fval(iter) );
    
    %%% convergence
    if iter > 1
        if abs(fval(iter)-fval(iter-1)) < tol
            fval(iter+1:end) = [];
            break;
        end
    end
    
end

end

function d = KLdiv(p,q)
d = sum(p.*log(p./(q+eps) +eps), 1);
end

function fval = calObjVal(r,p,q,W,mu,nu,ntrain)
fval = 0;
nsample = length(r);

for i = 1:ntrain
    fval = fval + KLdiv(r(:,i),q(:,i) );
end

for i = 1:nsample
    p0 = repmat(p(:,i),1,nsample);
    fval = fval + mu*sum(W(i,:).*KLdiv(p0,q) );
    fval = fval - nu*entropy(p(:,i));
end

end


function [alpha,mu,nu,maxIter,tol] = checkOpt(opt)
%%% set options
if ~isfield(opt,'alpha')
    alpha = 1;
else
    alpha = opt.alpha;
end
if ~isfield(opt,'mu')
    mu = 0.01;
else
    mu = opt.mu;
end
if ~isfield(opt,'nu')
    nu = 0.01;
else
    nu = opt.nu;
end
if ~isfield(opt,'maxIter')
    maxIter = 1000;
else
    maxIter = opt.maxIter;
end
if ~isfield(opt,'tol')
    tol = 1e-4;
else
    tol = opt.tol;
end
end