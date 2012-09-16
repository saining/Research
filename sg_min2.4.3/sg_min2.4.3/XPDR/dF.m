function df = dF(Y)
% dF	Computes the differential of F, that is,
% 	df satisfies real(trace(H'*df)) = d/dx (F(Y+x*H)).
%
%	df = DF(Y)
%	Y is expected to satisfy Y'*Y = I
%	df is the same size as Y
%
	global FParameters;
	P = FParameters.P;
	X = FParameters.X;
	PP = P'*P;
	XX = X*X';
    YY = Y*Y';
    df = XX*YY*PP*Y + PP*YY*XX*Y - (XX*PP + PP*XX)*Y;
