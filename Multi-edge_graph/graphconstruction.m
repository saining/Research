function[respmat, labeldiff] = graphconstruction(W, T, l_vnum, t_vnum, t_fea, testlabel)
    
    
    
    %Graph construction, we will have T tvnum by tvnum matrix
    
    fdim = zeros(1, T);
    for i = 1:T,
        fdim(i) = size(t_fea{i},1);
    end
    fdimsum = sum(fdim);
        
    t_feavec = zeros(fdimsum, t_vnum);
    for i = 1:t_vnum
        tmp = [t_fea{1}(:,i);t_fea{2}(:,i);t_fea{3}(:,i);t_fea{4}(:,i)];
        t_feavec(:,i) = tmp;   %lazy, special for the current 4 type tasks.    
    end;
    
    %Find the K-nearest neighbor of each vertex
    KNN = 5;
    IDX = myknnsearch(t_feavec',t_feavec', KNN);
    %IDX is t_vnum by K
    
    
    
    %
    respmat = cell(1, T);
    for i = 1: T,
        respmat{i} = zeros(t_vnum, t_vnum);
    end;
    labeldiff = zeros(t_vnum, t_vnum);
    %Calculate the label deviation
    %===============================================
    D = zeros(t_vnum, t_vnum);
    L = zeros(t_vnum, t_vnum);
    D = (testlabel(:,1:t_vnum))'*testlabel(:,1:t_vnum);
    L = diag(diag(D));

    
    
    
    for i = 1: t_vnum,
        for j = i+1: t_vnum,
     
            tempsep = 1;
            for k = 1: T,
                respmat{k}(i, j) = +...
                1/2*(max(W{k}'*t_feavec(tempsep:tempsep+fdim(k)-1,i),0) +...
                max(W{k}'*t_feavec(tempsep:tempsep+fdim(k)-1,j),0));
                tempsep = tempsep + fdim(k);
                labeldiff(i, j) = (1 - D(i, j)/(L(i, i)+L(j, j)-D(i,j)));
            end;
        end;
    end;
    
    