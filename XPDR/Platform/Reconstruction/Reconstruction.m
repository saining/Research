function [fea_Train] = Reconstruction(ReconstructionMethod,	fea_Train, ReducedDim)

        options.ReducedDim = ReducedDim;	
 		nSmp = size(fea_Train, 2);
		mean_fea_Train = repmat(mean(fea_Train, 2), 1, nSmp);

switch ReconstructionMethod
 	case 'PCA'
 		[eigvector, eigvalue] = PCA(fea_Train, options);

 	case 'XPDR'
		[eigvector, eigvalue] = XPDR(fea_Train, ReducedDim);
    case 'ALM_XPDR'
        filterType = '2D-GaborFilter'; %arguments in fucntion ConstructFilterMatrix
        [filterMatrix, ~] = ConstructFilterMatrix(filterType, fea_Train);
        lambda = 20;
        
        %filterMatrix = eye(size(filterMatrix));
        tic
        [W] = ladmap_xpdr(fea_Train, real(filterMatrix), lambda);
        toc
end
        if(ReconstructionMethod == 'ALM_XPDR')  
            fea_Train = W*fea_Train;
        else
 		%reconstructed fea:
 		fea_Train = mean_fea_Train + eigvector*eigvector'*(fea_Train - mean_fea_Train);	
        %fea_Train = eigvector*eigvector'*(fea_Train - mean_fea_Train);	
        %fea_Train = eigvector*eigvector'*(fea_Train);	
        end;
end