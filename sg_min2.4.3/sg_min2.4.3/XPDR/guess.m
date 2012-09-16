function Y = guess(dimY)
% GUESS	provides the initial starting guess Y for energy minimization.
%	In this case it makes a somewhat random guess.
%
%	Y = GUESS
%	Y will satisfy Y'*Y = I
%
% role	objective function, produces an initial guess at a minimizer 
%	of F.
	global FParameters;
	inP = FParameters.P;
	inX = FParameters.X;
    
	[m,n] = size(inP);
	[n,r] = size(inX);
    
    p = dimY;
 	%Y = pinv(inP)*inP*inX*pinv(inX)*rand(n,p);
    %load res;
    %Y = Yn+ rand(n,p);
  	%[Y,r1] = qr(Y,0);

    
     Y = pinv(inP)*inP*inX*pinv(inX);
     %Y = zeros(n,p);
     %Y = qr(Y);
     [Up,Sp,~] = svds(Y,p);
      Y = Up * Sp';
      temp = Y'*Y;
    
    
