%This code will try the l1-infty norm to optimize per class per feature
%parameters and predict the labels.

function [ RES ] = PdPf(T, vnum, fea, testlabel)
%MODELTRAINING training regression model parameter for each type of edge
%labels is a cell.


%Calculate feature dimension for each edge
%==============================================
fdimsum = 0;
fdim = zeros(1, T);
for i = 1:T,
    fdim(i) = size(fea{i},1);
end
fdimsum = sum(fdim);

%Calculate feature dimension for each edge
%==============================================
labels = cell(1, vnum);
feavec = zeros(fdimsum, vnum);
for i = 1:vnum
    labels{i} = find(testlabel(:,i));
    tmp = [fea{1}(:,i);fea{2}(:,i);fea{3}(:,i);fea{4}(:,i)];
    feavec(:,i) = tmp;   %lazy, special for the current 4 type tasks. 
end;


C = size(testlabel, 1);
RES = cell(T, C);
KNN = 5; 

%this means for every vertex i, consider KNN edges.

%Begin to optimize with CVX
%===============================================
cvx_begin
    variables W(fdimsum, C);
    
    expression objv;
    expression consv(T, C);
    expression regvec(T);
    
    %Main part of objective, notice that different regression parameters concatenate to
    %a long vector w, and we break it down in the obj and constraints.
    
    labeli = zeros(C,1);
    labelj = zeros(C,1);
    diff_class = [];
    for i = 1 : vnum,
        tic
            for j = 1 : KNN,
                RIDX = randperm(vnum);
                idxj = RIDX(j);
             
             tempsep = 1;
             labeli = testlabel(:,i);
             labelj = testlabel(:,j);
             diff_class = find(labeli == labelj);      
             diffnum = length(diff_class);
             
             if diffnum == 0,
                 continue;
             end;
             
             for m = 1: diffnum,
                 tempsep = 1;
                 for k = 1 : T,
                     %fprintf('the %d th edge\n',k);
                     regvec(k) = (W(tempsep:tempsep+fdim(k)-1, diff_class(m))'*feavec(tempsep:tempsep+fdim(k)-1, i)+...
                         W(tempsep:tempsep+fdim(k)-1, diff_class(m))'*feavec(tempsep:tempsep+fdim(k)-1,idxj));
                     tempsep = tempsep+fdim(k);
                 end;
                 objv = objv + max(1/2*(abs(regvec)+regvec));
             end;                
              
             %penalty on two norm, so that the scale won't increase too much.
             %===============================================================
             %tempsep = 1;
             %for k  = 1:T,
             %    objv = objv + norm(w(tempsep:tempsep+fdim(k)-1),2);
             %       tempsep = tempsep+fdim(k);
             %end;
                %fprintf('the %d th j\n',j);
            end;
            fprintf('the %d th i\n',i);
            toc
    end;
    
    minimize objv;
    
    for j = 1: C,        
        tempsep = 1;
        for i = 1 : T
            consv(i, j) = sum(W(tempsep:tempsep+fdim(i)-1, j));
            %consv(i) = ones(fdim(i),1)'*w(tempsep:tempsep+fdim(i)-1);
            tempsep = tempsep + fdim(i);
        end;
    end;
    subject to 
        for i = 1 : T,
            for j = 1: C,
            consv(i) == 1;
            end;
        end;
 %       consv == ones(T,1);
cvx_end

for j = 1: C,
    tempsep = 1;
    for i = 1 : T,
        RES{i,j} =W(tempsep:tempsep+fdim(i)-1, j);
        tempsep = tempsep + fdim(i);
    end;
end;