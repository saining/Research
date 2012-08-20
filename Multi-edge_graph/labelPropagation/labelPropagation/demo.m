clear
clc

%%% paramter setting
nclass = 30;
ntrain = 100;
ntest = 1000;
maxNumLabel = 5;
knn = 100;
%%% generate data
nsample = ntrain + ntest;
W = rand(nsample);
for i = 1:nsample
    perm = randperm(nsample);
    W(i,perm(knn+1:end)) = 0;
end

r = zeros(nclass,ntrain);
for i = 1:ntrain
    perm = randperm(maxNumLabel);
    numLabel = perm(1);
    perm = randperm(nclass);
    r(perm(1:numLabel),i) = 1;
end

%%% optimization
isEGSSC = 0;
isRanWalk = 1;
%% EGSSC
if isEGSSC
    %%% set options
    opt = [];
    opt.alpha = 1;
    opt.mu = 0.1;
    opt.nu = 0.01;
    opt.maxIter = 1000;
    opt.tol = 1e-4;

    %%% main
    [p,q] = EGSSC(r,W,opt);
end
%% Random Walk
if isRanWalk
    maxIter = 100;
    tol = 1e-4;
    Y = ranWalk(r,W, maxIter, tol );
end