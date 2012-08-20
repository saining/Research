function Y = ranWalk(r,W, maxIter, tol )
[nclass,ntrain] = size(r);
nsample = size(W,1);

r = r./repmat(sum(r,1)+eps,nclass,1);
Y = zeros(nsample,nclass);
Y(1:ntrain,:) = r';
Y(ntrain+1:end,:) = 1;

Y = Y./repmat(sum(Y,2)+eps,1,nclass);
T = W./repmat(sum(W,1)+eps,nsample,1);

%%% main
iter = 0;
Yold = Y;
while iter < maxIter
    iter = iter + 1;
    Y = T*Y;
    Y = Y./repmat(sum(Y,2)+eps,1,nclass);
    Y(1:ntrain,:) = r';
    
    if norm(Yold-Y,'fro') < tol
        break;
    else
        Yold = Y;
    end    
    
    fprintf('iter %d\n',iter);
end

end