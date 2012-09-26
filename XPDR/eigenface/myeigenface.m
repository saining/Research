clear all, close all

totrate = 0;
for testnum = 1:50, %50 random groups of training and testing data

    load ORL_64x64;
    fea = fea';
    gnd = gnd';
    train_fname=['8Train/' int2str(testnum)];
    load(train_fname);
    testIdx = testIdx';
    trainIdx = trainIdx';

    w = uint8(fea);
    r = fea(:,testIdx);
    tempv = fea(:,trainIdx);
    v = uint8(tempv);
    clear tempv;

N = 50; %num of eigvectors to remain
%% Subtracting the mean from v
I=uint8(ones(1,size(v,2)));  
m=uint8(mean(v,2));                 % m :mean of all training samples.
r=uint8(r);
%subplot(121); 
%imshow(reshape(m,64,64));
A = v - uint8(single(m)*single(I));   % vzm is v with the mean removed. 

%% Calculating eignevectors
% Select N of the 400 eigenvectors as eigenfaces
L=single(A)'*single(A);
[V,D] = eig(L);
V=single(A)*V;
V=V(:,end:-1:end-(N-1));             


%% Calculating the projection
proj=zeros(size(v,2),N);
for i=1:size(v,2);
    proj(i,:)=single(A(:,i))'*V;   
end


%% Recognition 

correct = 0;
wrong = 0;
for testno = 1:80,
    subplot(121);
    imshow(reshape(r(:,testno),64,64));
    title(sprintf('Testing Index(%d)...',testIdx(1,testno)),'FontWeight','bold','Fontsize',13,'color','black');

    subplot(122);

p=r(:,testno)-m;                              % subtract the mean
s=single(p)'*V;                               % projecting

dist=[];
for i=1:size(v,2)
    dist=[dist,norm(proj(i,:)-s,2)];
    if(rem(i,5)==0)
        %imshow(reshape(v(:,i),64,64));        %for fun, you can % it.
    end;
    drawnow;
end

[a,i]=min(dist);
subplot(122);
imshow(reshape(v(:,i),64,64));
title(sprintf('The min-dst face (Index: %d)',trainIdx(1,i)) ,'FontWeight','bold','Fontsize',13,'color','black');

%{
judge=input('please input 1 for yes / 0 for no/ -1 for finish testing, then press Enter\n');
if judge == 1 
    correct= correct +1;
end

if judge == 0
    wrong = wrong +1;
end

if judge == -1
    break;
end
%}
if mod(testIdx(1,testno),10)==0
    testclass = floor((testIdx(1,testno))/10);
else
    testclass = floor((testIdx(1,testno))/10)+1;
end

if mod(i,10)==0
    trainclass = floor(trainIdx(1,i)/10);
else
    trainclass = floor(trainIdx(1,i)/10)+1;
end


if testclass == trainclass
    correct = correct + 1;
else
    wrong = wrong + 1;
end

rate = correct / (correct+wrong);

end

display(sprintf('The %d-th data passed, the recognition rate is:%f',testnum,rate));
totrate = totrate+rate;
end
totrate = totrate/50;
display(sprintf('All the datas passed, the total recognition rate is:%f',totrate));

