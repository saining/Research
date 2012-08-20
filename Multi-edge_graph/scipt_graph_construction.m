clear all;
clc;
load('testlabel');
load('labellist');

%parameter:
%feature types:
T = 4; %CH/CORR/EDH/WT
%subsize = size(testlabel,2);
subsize = 100;
fea = cell(1,T);
t_fea = cell(1,T);

tmp = load('Test_EDH');
fea{1} = tmp.Test_EDH(:,1:subsize);
t_fea{1} = tmp.Test_EDH(:, 1:2*subsize);
fea{1}(size(fea{1},1),:)=[];
t_fea{1}(size(t_fea{1},1),:)=[];

tmp = load('Test_WT');
fea{2} = tmp.Test_WT(:, 1:subsize);
t_fea{2} = tmp.Test_WT(:, 1:2*subsize);
fea{2}(size(fea{2},1),:)=[];
t_fea{2}(size(t_fea{2},1),:)=[];

tmp = load('Test_CH');
fea{3} = tmp.Test_CH(:, 1:subsize);
t_fea{3} = tmp.Test_CH(:, 1:2*subsize);
fea{3}(size(fea{3},1),:)=[];
t_fea{3}(size(t_fea{3},1),:)=[];

tmp = load('Test_CORR');
fea{4} = tmp.Test_CORR(:, 1:subsize);
t_fea{4} = tmp.Test_CORR(:, 1:2*subsize);
fea{4}(size(fea{4},1),:)=[];
t_fea{4}(size(t_fea{4},1),:)=[];

%testlabel = #class by #vnum
[c_num, l_vnum] = size(testlabel(:, 1:subsize));
t_vnum = 2*l_vnum;

W = modeltraining(T, l_vnum, fea, testlabel);
RES = graphconstruction(W, T, l_vnum, t_vnum, t_fea, testlabel);

fus = zeros(t_vnum, t_vnum);
fus = max(max(max(RES{1}, RES{2}),RES{3}), RES{4});
