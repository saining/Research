function ip = stiefip(Y,A,B)
%STIEFIP Inner product (metric) for the Stiefel manifold.
% ip = STIEFIP(Y,A,B) returns trace(A'*(eye(n)-1/2*Y*Y')*B),
% where Y'*Y = eye(p), Y'*A & Y'*B = skew-hermitian, and Y, A,
% and B are n-by-p matrices.
ip = sum(sum(conj(A).*(B - Y*((Y'*B)/2)))); % Canonical metric from (2.39)