function ddf = ddF(Y,H)
% ddF	Computes the second derivative of F, that is,
% 	ddf = d/dx dF(Y+x*H).
%	
%	ddf = DDF(Y,H)
%	Y is expected to satisfy Y'*Y = I
% 	H is expected to be the same size as Y
%	ddf will be the same size as Y
%

	global FParameters;
	P = FParameters.P;
	X = FParameters.X;
	PP = P'*P;
	XX = X*X';
    YY = Y*Y';
    
    
    ddf = XX*YY*PP*H + XX*Y*H'*PP*Y + XX*H*Y'*PP*Y + ...
          PP*YY*XX*H + PP*Y*H'*XX*Y + PP*H*Y'*XX*Y - ...
          (XX*PP+PP*XX)*H;
