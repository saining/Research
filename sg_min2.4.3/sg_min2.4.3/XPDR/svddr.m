clear all;
clc;

i1 = imread('./gt/i1.jpg');
o1 = imread('./gt/o1.jpg');
o1 = rgb2gray(o1);

o1 = mat2gray(o1);
%imshow(o1);
%pause;

i1 = mat2gray(i1);
%imshow(i1);

%pause;

c1 = o1.*i1;
%imshow(c1);

ii1 = imresize(i1, 0.07);
oo1 = imresize(o1, 0.07);
%imshow(ii1);
%pause;
%imshow(oo1);
%pause;
imshow(ii1.*oo1);
%pause; 

tot = length(ii1(:));
pmat = spdiags(ii1(:),0,tot,tot);
%pmat = diag(ii1(:));
xvec = oo1(:);

dimX = size(xvec);
dimP = size(pmat);
factor = 0.6;
dimY = ceil(dimX(1)*factor);

randn('state',0);
X = xvec;
P = sparse(pmat);
%[X,P] = randprob(dimX, dimP);
parameters(X, P);
Y0 = guess(dimY);

disp('************************Begin sigmin**************\n');
tic
[fn, Yn] = sg_min(Y0,'prcg','euclidean',0.1, 0.1);
toc

disp('************************Finish sigmin**************\n');
resim = P*Yn*Yn'*X;
resim = reshape(resim,size(oo1,1),size(oo1,2));
imshow(resim);

