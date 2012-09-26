function [eigvector eigvalue] = LRPP( X )

% LRPP - Low-Rank Preserving Projections
% �����ȱ�ʾ���ֵ���ά�ռ�
% ��SPP���������õ��ȱ�ʾ����ϡ���ʾ

% min |X|_*+lambda*|E|_2,1
% s.t., X = XZ+E
% reg -- the norm chosen for characterizing E, 
% reg = 0 ;   % reg=0 (default),                  use the l21-norm %% ����������ö�
% reg = 1 ;   % reg=1 (or ther values except 0),  use the l1-norm
% lambda = 0.5 ;
% Z = solve_lrr( X , X , lambda , reg ) ;

% Z = analytical_lrr( X , X ) ; % ����ǽ����⣬�ȵ�һʽ��200������


% ����PCA��ά
P = PCA( X ) ;
X = P' * X ;
                


% Z = analytical_LRR( X ) ;               % ��죬min_Z |Z|_*  s.t. X = X * Z
% Z = analytical_LRR1( X , X ) ;          % �Ͽ죬min_Z |Z|_*  s.t. X = A * Z
tau = 300 ;
Z = analytical_LRR2( X , tau ) ;        % ������min_Z |Z|_* + (tau/2)*(|X-X*Z|_F)^2




ZL = X * (Z + Z' - Z' * Z) * X' ;
ZR = X * X' ;

ZL = max(ZL,ZL') ;
ZR = max(ZR,ZR') ;

% [eigvector,eigvalue] = eig(ZL,ZR) ;
% [junk, index] = sort(-eigvalue);


ZL2 = X * X' -  X * ( Z + Z' - Z' * Z) * X' ;
ZL2 = max(ZL2,ZL2') ; % ����Գƻ����÷ǳ�����
[eigvector,eigvalue] = eig( ZL2 ) ;
[junk, index] = sort(eigvalue);



eigvalue = diag(eigvalue);
eigvalue = eigvalue(index);
% eigvalue
eigvector = eigvector(:,index);

%
% for tmp = 1:size(eigvector,2)
%     eigvector(:,tmp) = eigvector(:,tmp)./norm(eigvector(:,tmp));
% end


eigvector = P * eigvector ;


save LRPPdata


