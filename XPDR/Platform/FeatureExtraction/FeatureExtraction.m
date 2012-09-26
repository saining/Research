function [ fea_Train , fea_Test , redDim ] = FeatureExtraction( method , fea_Train , gnd_Train , fea_Test )

% method        ��ά���������ܵ�ȡֵ��{'PCA','LDA,'Random']�����и�����д���ӣ���LPP
% fea_Train     dim*num_Train ѵ������
% gnd_Train     1*num_Train(��num_Train*1)����fea_Train��Ӧ�������ı�ǩ
% parameter     ����Ĳ�����������Random�����е����ά��



% ��ά
switch method
    case 'PCA'
        [ eigvector , eigvalue ] = PCA( fea_Train ) ;
    case 'LDA'
        options.PCARatio = 1 ;
        [ eigvector , eigvalue ] = LDA( gnd_Train , options , fea_Train ) ;
    case 'MMC'
        [ eigvector , eigvalue ] = MMC( fea_Train , gnd_Train ) ;
    case 'LPP'
        [ eigvector , eigvalue ] = LPP_method( fea_Train , gnd_Train ) ;      
    case 'Random'
        dim = size( fea_Train , 1 ) ; 
        eigvector = randn( dim , dim ) ;
        eigvalue = zeros(dim,1) ;
    case 'OP_SRC' %'SRC_DP' %  
        [eigvector eigvalue] = OP_SRC( fea_Train , gnd_Train ) ;
    case 'OP_LRC' 
        [eigvector eigvalue] = OP_LRC( fea_Train , gnd_Train ) ;
    case 'OP_NFS'        
        [eigvector eigvalue] = OP_NFS( fea_Train , gnd_Train ) ;
    case 'LRPP'
        [ eigvector , eigvalue ] = LRPP( fea_Train ) ;
    case 'SLRPP'
        [ eigvector , eigvalue ] = SLRPP( fea_Train , gnd_Train ) ;
    case 'SPP'
        [ eigvector , eigvalue ] = SPP( fea_Train , gnd_Train ) ;
    case 'Identity'
        [ eigvector , eigvalue ] = Identity( fea_Train ) ;  
    case 'MaxSubAngel'
        [ eigvector , eigvalue ] = MaxSubAngel( fea_Train , gnd_Train ) ;
    case 'XPDR'
        reddim = 74;
        [ eigvector , eigvalue ] = XPDR( fea_Train,  reddim) ;
    case 'GaborPCA'
        [ eigvector , eigvalue ] = GaborPCA( fea_Train ) ;
end

fea_Train = eigvector' * fea_Train ;
fea_Test = eigvector' * fea_Test ;
redDim = length(eigvalue) ;
