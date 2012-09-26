function [fea_Train] = Reconstuction(ReconstructionMethod,	fea_Train, ReducedDim)

options.ReducedDim = ReducedDim;	
 		nSmp = size(fea_Train, 2);
		mean_fea_Train = repmat(mean(fea_Train, 2), 1, nSmp);

switch ReconstructionMethod
 	case PCA
 		[eigvector, eigvalue] = PCA(fea_Train, options);

 	case XPDR
		[eigvector, eigvalue] = XPDR(fea_Train, ReducedDim);
 end
 		%reconstructed fea:
 		fea_Train = mean_fea_Train + eigvector*eigvector'*(fea_Train - mean_fea_Train);	
end;