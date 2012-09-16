clear all;
clc;


dimX = [100, 80];
dimP = [200, 100];
dimY = 80;

randn('state',0);
[X,P] = randprob(dimX, dimP);
parameters(X,P);
Y0 = guess(dimY);
%Y0 = randn(100,30);
%Y0 = randn(100,30);

[fn, Yn] = sg_min(Y0,'dogleg','euclidean',0.1);