function f = F(Y)
% F	Computes the energy associated with the stiefel point Y.
% f = 1/2*||PX-PYY'X||^2
%
% f = F(Y)
% Y is expected to satisfy Y'*Y=I

	global FParameters;
	P = FParameters.P;
	X= FParameters.X;
    
	q = P*X-P*(Y*(Y'*X));
	f = sum(sum(real(conj(q).*(q))))/2;
