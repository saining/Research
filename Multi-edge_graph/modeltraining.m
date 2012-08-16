function [ W ] = modeltraining(T, vnum, fea, testlabel)
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
for i = 1:vnum
    labels{i} = find(testlabel(:,i));
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
    variables w(fdimsum);
    expression infnorm(T);
    
    expression objv;
    expression consv(T);
    expression regvec(T);
    
    %Main part of objective, notice that different regression parameters concatenate to
    %a long vector w, and we break it down in the obj and constraints.
    pairs = [-1 -1];
    for i = 1 : vnum,
            for j = 1 : KNN,
             idxj = IDX(i, j);
             tempsep = 1;
%              if ~ismember([i idxj], pairs, 'rows') && ~ismember([idxj i], pairs, 'rows'),
%                  pairs = [pairs; [i idxj]];
%              else
%                  fprintf('pairs repeated!\n');
%                  continue;
%              end;
                
             for k = 1 : T,
                    %fprintf('the %d th edge\n',k);
                    regvec(k) = D(i,idxj)/length(labels{i})*...
                                w(tempsep:tempsep+fdim(k)-1)'*feavec(tempsep:tempsep+fdim(k)-1,i)+...
                                D(idxj,i)/length(labels{idxj})*...
                                w(tempsep:tempsep+fdim(k)-1)'*feavec(tempsep:tempsep+fdim(k)-1,idxj);
                    tempsep = tempsep+fdim(k);
                end;
                objv = objv + max(1/2*(abs(regvec)+regvec));
                %fprintf('the %d th j\n',j);
            end;
            fprintf('the %d th i\n',i);
        end;
    
    minimize objv;
    
    tempsep = 1;
    for i = 1 : T
        consv(i) = sum(w(tempsep:tempsep+fdim(i)-1));
        %consv(i) = ones(fdim(i),1)'*w(tempsep:tempsep+fdim(i)-1);
        tempsep = tempsep + fdim(i);
    end;
    
    subject to 
        for i = 1 : T,
            consv(i) == 1;
        end;
 %       consv == ones(T,1);
cvx_end

tempsep = 1;
for i = 1 : T
        W{i} = w(tempsep : tempsep+fdim(i)-1);
        tempsep = tempsep + fdim(i);
end;