function [rate predictlabel] = SRC_lu_SPAMS( trnX ,trnY ,tstX , tstY )

% Reference: J. Wright, et al., "Robust Face Recognition via Sparse Representation,"
% IEEE Transactions on Pattern Analysis and Machine Intelligence, vol. 31, pp. 210-227, Feb 2009.
% This code is written based on the Eq. (22) of the reference.
% ʹ��SPAMS���߰���SRC�㷨����ͬ���������Ծ�����ʽ�����������Ծ�����ʽ���
% ��Ӧ��ϡ���ʾϵ��

% Input:
% trnX [dim * num ] - each column is a training sample
% trnY [ 1  * num ] - training label 
% tstX
% tstY

% Output:
% rate             - Recognition rate of test sample
% predictlabel     - predict label of test sample

ntrn = size( trnX , 2 ) ;
ntst = size( tstX , 2 ) ;

% normalize
for i = 1 : ntrn
    trnX(:,i) = trnX(:,i) / norm( trnX(:,i) ) ;
end
for i = 1 : ntst
    tstX(:,i) = tstX(:,i) / norm( tstX(:,i) ) ;
end

% classify
param.lambda = 0.001 ; % not more than 20 non-zeros coefficients
%     param.numThreads=2; % number of processors/cores to use; the default choice is -1
% and uses all the cores of the machine
param.mode = 1 ;       % penalized formulation
param.verbose = false ;       % ��ֹ����м���

A = mexLasso( tstX , trnX , param ) ;

% �������ڲв���С�ľ��߹���SRCʹ�ã�
[rate predictlabel] = Decision_Residual( trnX ,trnY ,tstX , tstY , A ) ;

% ��������ϵ�������ľ��߹���
% rate2 = Decision_Coeff( trnX ,trnY ,tstX , tstY , A ) ;

% fprintf('%f %f\n',rate,rate2) ;
% A = abs( A ) ;
% rate3 = Decision_Residual( trnX ,trnY ,tstX , tstY , A ) 
% rate4 = Decision_Coeff( trnX ,trnY ,tstX , tstY , A ) 
