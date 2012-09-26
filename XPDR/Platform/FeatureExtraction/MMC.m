function [eigvector eigvalue] = MMC( X , Y )

% ¬���彫������Ĵ���������֯��һ�£���Ҫ�ǽӿ��ϵ��޸� 2012/07/13


beta = 1 ;

% X(d*n) , Y(1*n) ��Ϊÿ��һ��������

% ����PCA��ά
eigvector_PCA = PCA( X ) ;
X = eigvector_PCA' * X ;

classLabel = unique( Y );
% ����������
nClass = length(classLabel);

% ���¼�������ÿ��һ������������ģ�����������ÿ��һ�������������
X = X' ;
Y = Y' ;
% ������ֵ
sampleMean = mean(X);
% nSmp ��Ӧ������
% nFea ��Ӧ����ά�����ǳ��߰�
[nSmp,nFea] = size(X);


% disp('Computing SB and SW ...');
% ����ļ����ٶ�ʵ���Ϸǳ���
% ����SW��SB
MMM = zeros(nFea, nFea);
% 
for i = 1:nClass,
    %
	index = find( Y == classLabel(i) ) ;
    % ÿһ�������
	classMean = mean(X(index, :));
    % ��Ҫ�ļ�������������
	MMM = MMM + length(index)*classMean'*classMean;
end
% X��������������
W = X'*X - MMM;
% 
B = MMM - nSmp*sampleMean'*sampleMean;

W = max(W, W');
B = max(B, B');
% �����beta�������е��������ӣ���ǰ��������ľ����������SW��SB
S = B - beta*W;

dimMatrix = size(S,2);

[eigvector, eigvalue] = eig(S);


% ȡ���Խ����ϵ�Ԫ��
eigvalue = diag(eigvalue);
% ����ֵ����
% When X is complex, the elements are sorted by ABS(X)
[junk, index] = sort(eigvalue,'descend');
% �������������������У�ÿһ�ж�Ӧһ�������������������ڵڶ�ά�Ͻ�������
eigvector = eigvector(:,index); 

for tmp = 1:size(eigvector,2)
    eigvector(:,tmp) = eigvector(:,tmp)./norm(eigvector(:,tmp));
end

% % ��ά����Ӧ����PCA����
eigvector = eigvector_PCA * eigvector ;

