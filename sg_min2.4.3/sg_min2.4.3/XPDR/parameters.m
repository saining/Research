function parameters(X,P)
% PARAMETERS	initializes the parameters for an instance of a 
%		minimization problem.
%
%	PARAMETERS(A,B)
%	A is expected to be a square matrix
%	B is expected to be a square matrix
%
% role	sets up the global parameters used at all levels of computation.

	global FParameters;
	FParameters = [];
	FParameters.X = X;
	FParameters.P = P;
