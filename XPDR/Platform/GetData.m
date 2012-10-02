% clear ;
% close all;
currentpath = cd ;
AddedPath = genpath( currentpath ) ;
addpath( AddedPath ) ;
% fprintf('\n\n**************************************   %s   *************************************\n' , datestr(now) );
% fprintf( [ mfilename(currentpath) ' Begins.\n' ] ) ;
% fprintf( [ mfilename(currentpath) ' is going, please wait...\n' ] ) ;

%% ��������ѡ��
Data = 'Yale' ;                                 % Yale����,15�࣬ÿ��11����������165������
% Data = 'ORL' ;                                  % ORL���ݣ�40�࣬ÿ��10����������400������
% Data = 'UMIST' ;                                % UMIST���ݣ�20�࣬ÿ��Լ29����������575������
% Data = 'YaleB' ;                                % YaleB���ݣ�38�࣬ÿ��Լ64������
% Data = 'YaleB10' ;                              % YaleB10���ݣ���YaleB�г�ȡǰ10���������10�࣬ÿ��Լ64������
% Data = 'AR' ;                                   % AR���ݣ�100�࣬ÿ��14������

%% ��ά����ѡ��
% FeatureExtractionMethod = 'PCA' ;
% FeatureExtractionMethod = 'OP_SRC' ; % 'SRC_DP' ;   % 

% FeatureExtractionMethod = 'OP_LRC' ;
% FeatureExtractionMethod = 'XPDR';
% FeatureExtractionMethod = 'GaborPCA';
  FeatureExtractionMethod = 'LDA' ; 
% FeatureExtractionMethod = 'MMC' ;
% FeatureExtractionMethod = 'Random' ;
% FeatureExtractionMethod = 'OP_NFS' ;
% FeatureExtractionMethod = 'Identity' ;
% FeatureExtractionMethod = 'LPP' ;   % û��ͨ
% FeatureExtractionMethod = 'LRPP' ;
% FeatureExtractionMethod = 'SLRPP' ;
% FeatureExtractionMethod = 'SPP' ;
% FeatureExtractionMethod = 'MaxSubAngel' ;

%% Reconstruction Methods
%ReconstructionMethod = 'PCA';
ReconstructionMethod = 'XPDR';

%% Feature Filter
LinearFilterType = '2D-GaborFilter';

%% ������ѡ��
% Classifier = 'SRC_lu_SPAMS' ;
% Classifier = 'KLRC' ;
% Classifier = 'SingularFeature' ;
% Classifier = 'WSRC_SPAMS' ;
Classifier = 'kNN' ;
% Classifier = 'NFS' ;
% Classifier = 'NFS_gui' ;
% Classifier = 'SRC_lu' ;
% Classifier = 'SRC_QC1' ;
% Classifier = 'SRCe' ;
% Classifier = 'OrthonormalL2' ;
% Classifier = 'LRRC' ;
% Classifier = 'DiffSingular' ;
% Classifier = 'WLRC' ;


%% Random splits
splits = 10;                                    

%% ��ά����ά������
switch Data
    case 'Yale'
        % Yale data,15 classes, 11samples per class
        Train = 5 : 5 ;                         % ÿ����ѵ���������������ڲ�ͬ��Trainά��Ҫ�ı䣬���������ʱ���ʺ϶�Train�����ı䡣
         D = [10 30 50 60 70 74 ] ;
%        D = [ 1: 74 ] ;                % PCA��6Trainʱ���ά89
%         D = [ 5 10 15 20 25 30 40 50  60 70 80 85 89] ;                % PCA��6Trainʱ���ά89
%         D = 60 ;
%         D = [50 100 200 300 500 700 1000] ;
        if strcmp( FeatureExtractionMethod , 'LDA' )
            D = [ 3 5 7 9 11 13 14 ] ;                        % LDA�����ά14
%             D = 14 ;
        end
    case 'ORL'
        % ORL���ݣ�40�࣬ÿ��10������
        Train = 4 : 4 ;                         % ÿ����ѵ����������
        D = [ 10 30 50 80 120 150 180 195] ;              % PCA��5Trainʱ���ά199
%         D = 5 : 5 : 199
%         D = [ 120 140 160 180 199] ;              % PCA��5Trainʱ���ά199
        D = 1:159 ;
        if strcmp( FeatureExtractionMethod , 'LDA' )
            D = [ 5 10 20 25 30 35 39] ;                        % LDA�����ά39
        end
    case 'UMIST'
        % UMIST���ݣ�20�࣬ÿ��Լ29����������575������
        Train = 12 : 12 ;                         % ÿ����ѵ����������
        D = [ 30 60 80 100 110 ] ;              % PCA��6Trainʱ���ά119
%         D = [ 120 140 160 180 199] ;
%         D = 5 : 5 : 237 ;
        if strcmp( FeatureExtractionMethod , 'LDA' )
            D = [ 5:5:19] ;                        % LDA�����ά39
        end
        
    case 'YaleB'
        % YaleB���ݣ�38�࣬ÿ��Լ64������
        Train = 30 : 30 ;                       % ÿ����ѵ����������
        D = [ 30 56 120 504] ;%             
                             % PCA��30Trainʱ���ά1024
        D = [ 30 56 ] ; %���Դ�20��ʼ�ͺ�
        if strcmp( FeatureExtractionMethod , 'LDA' )
%             D = [ 5 10 15 30 35 37] ;
            D = [ 5:5:37 ] ;                        % LDA�����ά37
%             D = 1 : 37 ;
        end
    case 'YaleB10'
        % YaleB10���ݣ�YaleB���ݵ�ǰ10�࣬10�࣬ÿ��Լ64������
        Train = 30 : 30 ;                       % ÿ����ѵ����������
        D = [ 50 ] ;
%             
                             % PCA��30Trainʱ���ά1024
%         D = 20:5:120 ; %���Դ�20��ʼ�ͺ�
        if strcmp( FeatureExtractionMethod , 'LDA' )
            D = [ 7 8 9] ;
%             D = [ 5:5:37 ] ;                        % LDA�����ά37
        end
    case 'AR'
        % AR���ݣ�100�࣬ÿ��14������
        Train = 7 : 7 ;                         % ÿ����ѵ����������
        D = [ 30 54 130 540] ;                  % PCA��7Trainʱ���ά699
        D = [ 30 54  ] ;
        if strcmp( FeatureExtractionMethod , 'LDA' )
%             D = [ 30 56 99] ;                   % LDA�����ά99
            D = [ 10 20 30 40 50 60 70 80 90] ; 
        end
end
length_D = length(D) ;

%% ������
% ResultsTxt = [ '.\Results\' Data '\' num2str(Train) 'Train_' Classifier '_' FeatureExtractionMethod '_D=[' num2str(D) ']_s=' num2str(splits) '.txt' ] ;
% fid = fopen( ResultsTxt , 'wt' ) ;              % ���������ı��ļ�
fid = 1 ;                                       % ����������Ļ
fprintf( fid , '\n\n**************************************   %s   *************************************\n' , datestr(now) );
fprintf( fid , ['Function                   = ' mfilename(currentpath) '.m\n' ] ) ;
fprintf( fid ,  'Data                       = %s\n' , Data ) ;
fprintf( fid ,  'FeatureExtractionMethod    = %s\n' , FeatureExtractionMethod ) ;
fprintf( fid ,  'Classifier                 = %s\n' , Classifier ) ;
fprintf( fid ,  'splits                     = %d\n\n' , splits ) ;

%% ���ݵ��롢��һ��
path_data = ['.\Data\' Data '_lu\' ] ;
load( [path_data , Data] ) ;
for i = 1 : size(fea,2)
    fea(:,i) = fea(:,i) / norm( fea(:,i) ) ;
end


%% ��ά�����ࡢ������
for ii = 1: length( Train )    
    i = Train( ii ) ;                           % i��ÿ����ѵ����������
    fprintf( fid , 'Train_%d : \n' , i ) ;
    if strcmp( FeatureExtractionMethod , 'XPDR' )
        Accuracy = size(splits, 1);
    else
        Accuracy = size( splits , length_D ) ;
    end
    load( [path_data 'idxData' num2str(i)] ) ; 
    for s = 1 : splits                          % �Բ�ͬ�ķָ�
        % ��Ϊѵ�������Ͳ�������
        fea_Train = fea( : , idxTrain(s,:) ) ;
        gnd_Train = gnd( idxTrain(s,:) ) ;
        fea_Test = fea( : , idxTest(s,:) ) ;
        gnd_Test = gnd( idxTest(s,:) ) ;
        [fea_Train,gnd_Train,fea_Test,gnd_Test] = Arrange(fea_Train,gnd_Train,fea_Test,gnd_Test) ;        
        
        % Get the Reconstructed Image
        ReducedDim = 50;
        fprintf('Reddim: %d %d th split\n', ReducedDim, s);
        % 0 means use full-rank;
        [fea_Train] = Reconstruction(ReconstructionMethod, fea_Train, ReducedDim);
        
        ResultsMat = [ '.\Features\fea_Train' num2str(i) 'Train_' Data '_' ReconstructionMethod '_ReducedDim=' num2str(ReducedDim) '_s=' num2str(splits) ] ; % '_D=[' num2str(D) ']_s=' '
        disp(ResultsMat);
        save( ResultsMat , 'fea_Train','ReducedDim' ) ;
    end
end