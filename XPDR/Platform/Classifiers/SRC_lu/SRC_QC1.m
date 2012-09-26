% Reference1: J. Wright, et al., "Robust Face Recognition via Sparse Representation,"
% IEEE Transactions on Pattern Analysis and Machine Intelligence, vol. 31, pp. 210-227, Feb 2009.
% Reference 2: L. S. Qiao, et al., "Sparsity preserving projections with
% applications to face recognition," Pattern Recognition, vol. 43, pp.
% 331-341, Jan 2010.
% ����Reference1 P 214��Algorithm1�Ĳ���ʽԼ��,
function rate = SRC_QC1( TrainData,TrainGnd,TestData,TestGnd )
% SRC Sparse Representation Classifier 
% with quadratic constraints
% using l1qc_logbarrier
%
% Input:
% TrainData
% TrainGnd
% TestData
% TestGnd
%
% Output:
% rate

TrainData = TrainData' ;
TestData = TestData' ;
% NΪѵ��������
[N dim] = size(TrainData);
% MΪ����������
[M dim] = size(TestData);
%
classLabel = unique(TrainGnd);
% ����������
nClass = length(classLabel);
% ʶ����
Result = zeros(1,M);

% ѵ��������Ϊ�ֵ�
G = TrainData'; 
% l2������һ��
for i = 1:N
    G(:,i) = G(:,i)/norm(G(:,i));
end
%

% ������������
% l2������һ��
for i = 1:M
    TestData(i,:) = TestData(i,:)/norm(TestData(i,:));
end

G=[G;ones(1,N)];

Coeff_Test = zeros(N,M) ;
% ѭ����ÿһ������������������ж�
for i = 1:M
    %
    i;
    % ȡ���ô�������ת�ó�������
    y = TestData(i,:)';
%     y = [y; 1];
    %
    epsilon = 0.05;
    %
%     x0 = G'*y;
    x0 = G'\y ;
    % ����l1������С������
    xp = l1qc_logbarrier(x0, G, [], y, epsilon, 1e-3);
    Coeff_Test(:,i) = xp ;
    %  
    % ����в�
    % ��������в�
    R = zeros(nClass,1);
    %
    for ii = 1:nClass
        %
        delta = find(TrainGnd ~= ii);
        %
        xdelta = xp;
        %
        xdelta(delta) = 0;
        %
        R(ii) = norm(y - G*xdelta);      
    end
    
    % ȷ����С�в�
    [Rmin index] = min(R); 
    % �޸Ľ��
    Result(i) = index;    
end

rate = length(find(Result==TestGnd))/M;% Recognition rate


save Data_SRCQ1 Coeff_Test

