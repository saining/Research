function [ W ] = modeltraining2(T, vnum, fea, testlabel)
%MODELTRAINING training regression model parameter for each type of edge
%labels is a cell.

%T = 4;
%toy example
%vnum = 3; 
%labels = cell(1, 3);
%labels{1} = [1,2];
%labels{2} = [2,3];
%labels{3} = [1,3];
%feacell = cell(1,T);
%feacell{1} = normrnd(zeros(30,1),ones(30,1)*0.5)';
%feacell{2} = normrnd(zeros(20,1),ones(20,1)*0.7)';
%feacell{3} = normrnd(zeros(10,1),ones(10,1)*0.9)';
%feacell{4} = normrnd(zeros(5,1),ones(5,1)*1.0)';
%feavec = [feacell{1}, feacell{2}, feacell{3}, feacell{4}]';
%toy example

%Calculate feature dimension for each edge
%==============================================
W = cell(1,T);
fdimsum = 0;
fdim = zeros(1, T);
for i = 1:T,
    fdim(i) = size(fea{i},1);
end
fdimsum = sum(fdim);

labels = cell(1, vnum);
feavec = zeros(fdimsum, vnum);
feavec1 = zeros(fdim(1), vnum);
feavec2 = zeros(fdim(2), vnum);
feavec3 = zeros(fdim(3), vnum);
feavec4 = zeros(fdim(4), vnum);
for i = 1:vnum
    labels{i} = find(testlabel(:,i));
    feavec1(:,i) = fea{1}(:,i);
    feavec2(:,i) = fea{2}(:,i);
    feavec3(:,i) = fea{3}(:,i);
    feavec4(:,i) = fea{4}(:,i);
    tmp = [fea{1}(:,i);fea{2}(:,i);fea{3}(:,i);fea{4}(:,i)];
    feavec(:,i) = tmp;   %lazy, special for the current 4 type tasks.    
end;

%Calculate the label deviation
%===============================================
D = zeros(vnum, vnum);
L = zeros(vnum, vnum);
D = (testlabel(:,1:vnum))'*testlabel(:,1:vnum);
L = repmat(diag(D),1,vnum);
D = L - D;


%Find the K-nearest neighbor of each vertex
KNN = 5;
IDX = knnsearch(feavec',feavec', KNN);
%IDX is vnum by K

%Begin to optimize with CVX
%===============================================
cvx_begin
    variables w1(fdim(1)) w2(fdim(2)) w3(fdim(3)) w4(fdim(4));
    expression infnorm(T);
    
    expression objv;
    expression consv(T);
    expression regvec(T);
    
    %Main part of objective, notice that different regression parameters concatenate to
    %a long vector w, and we break it down in the obj and constraints.
    for i = 1 : vnum,
             for j = 1 : KNN,
             idxj = IDX(i, j);
%                 for k = 1 : T,
                    %fprintf('the %d th edge\n',k);
%                     regvec(k) = D(i,idxj)/length(labels{i})*...
%                                 w(tempsep:tempsep+fdim(k)-1)'*feavec(tempsep:tempsep+fdim(k)-1,i)+...
%                                 D(idxj,i)/length(labels{idxj})*...
%                                 w(tempsep:tempsep+fdim(k)-1)'*feavec(tempsep:tempsep+fdim(k)-1,idxj);
%                     tempsep = tempsep+fdim(k);
                      tmp = D(i,idxj)/length(labels{i})*...
                                  w1'*feavec1(:,i)+...
                                  D(idxj,i)/length(labels{idxj})*...
                                  w1'*feavec1(:,idxj);
                      regvec(1) = tmp;
                              
                      regvec(2) = D(i,idxj)/length(labels{i})*...
                                  w2'*feavec2(:,i)+...
                                  D(idxj,i)/length(labels{idxj})*...
                                  w2'*feavec2(:,idxj);
                      regvec(3) = D(i,idxj)/length(labels{i})*...
                                  w3'*feavec3(:,i)+...
                                  D(idxj,i)/length(labels{idxj})*...
                                  w3'*feavec3(:,idxj);
                      regvec(4) = D(i,idxj)/length(labels{i})*...
                                  w4'*feavec4(:,i)+...
                                  D(idxj,i)/length(labels{idxj})*...
                                  w4'*feavec4(:,idxj);

                objv = objv + max(max(0,regvec));
                %fprintf('the %d th j\n',j);
            end;
            fprintf('the %d th i\n',i);
        end;
    
    minimize objv;
    
    subject to 
        sum(w1) == 1;
        sum(w2) == 1;
        sum(w3) == 1;
        sum(w4) == 1;
      
cvx_end


W{1} = w1;
W{2} = w2;
W{3} = w3;
W{4} = w4;
