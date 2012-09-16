function [Yt,Ht] = stiefgeod(Y,H,t)
%STIEFGEOD  Geodesic on the  Stiefel  manifold.
%                      STIEFGEOD(Y,H)  is the  geodesic  on the  Stiefel  manifold
%                      emanating from  Y  in  direction  H,  where Y'*Y  = eye(p), Y'*H  =
%                      skew-hermitian, and Y  and H  are  n-by-p  matrices.
%
%                      STIEFGEOD(Y,H,t) produces  the  geodesic  step  in direction H  scaled
%                      by t.  [Yt,Ht] = STIEFGEOD(Y,H,t) produces  the  geodesic  step  and the
%                      geodesic  direction. 
[n,p] = size(Y);

if nargin   < 3, 
    t = 1;  
end
A  = Y'*H;    
A  = (A - A')/2; %   Ensure skew-symmetry
[Q,R]  = qr(H  - Y*A,0);
MN  = expm(t*[A,-R';R,zeros(p)]);   
MN  = MN(:,1:p);

Yt  = Y*MN(1:p,:) + Q*MN(p+1:2*p,:);   %   Geodesic from  (2.45)
if nargout  > 1,  
    Ht  = H*MN(1:p,:) - Y*(R'*MN(p+1:2*p,:)); 
end
%   Geodesic direction from  (3.3)
