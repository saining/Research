function [idx,D]=myknnsearch(varargin)
% KNNSEARCH   Linear k-nearest neighbor (KNN) search
% IDX = knnsearch(Q,R,K) searches the reference data set R (n x d array
% representing n points in a d-dimensional space) to find the k-nearest
% neighbors of each query point represented by eahc row of Q (m x d array).
% The results are stored in the (m x K) index array, IDX.
%
% IDX = knnsearch(Q,R) takes the default value K=1.
%
% IDX = knnsearch(Q) or IDX = knnsearch(Q,[],K) does the search for R = Q.
%
% Rationality
% Linear KNN search is the simplest appraoch of KNN. The search is based on
% calculation of all distances. Therefore, it is normally believed only
% suitable for small data sets. However, other advanced approaches, such as
% kd-tree and delaunary become inefficient when d is large comparing to the
% number of data points. On the other hand, the linear search in MATLAB is
% relatively insensitive to d due to the vectorization. In  this code, the
% efficiency of linear search is further improved by using the JIT
% aceeleration of MATLAB. Numerical example shows that its performance is
% comparable with kd-tree algorithm in mex.
%
% See also, kdtree, nnsearch, delaunary, dsearch
 
% By Yi Cao at Cranfield University on 25 March 2008
% Modified By Piji Li for Multi-Core Computing at Shandong University
% on 18 July 2011
 
 
% Check inputs
[Q,R,K,fident,numCore] = parseinputs(varargin{:});
 
 
[N,M] = size(Q);
L=size(R,1);
idx = zeros(N,K);
D = idx;
if  numCore==0
tic
if K==1
% Loop for each query point
for k=1:N
d=zeros(L,1);
for t=1:M
d=d+(R(:,t)-Q(k,t)).^2;
end
if fident
d(k)=inf;
end
[D(k),idx(k)]=min(d);
end
else
for k=1:N
d=zeros(L,1);
for t=1:M
d=d+(R(:,t)-Q(k,t)).^2;
end
if fident
d(k)=inf;
end
[s,t]=sort(d);
idx(k,:)=t(1:K);
D(k,:)=s(1:K);
end
end
if nargout>1
D=sqrt(D);
end
toc
else
if matlabpool('size')<=0
matlabpool('open','local',numCore);
else
disp('Already initialized'); %说明并行环境已经启动�?
end
tic
if K==1
% Loop for each query point
parfor k=1:N
d=zeros(L,1);
for t=1:M
d=d+(R(:,t)-Q(k,t)).^2;
end
if fident
d(k)=inf;
end
[D(k),idx(k)]=min(d);
end
else
parfor k=1:N
d=zeros(L,1);
for t=1:M
d=d+(R(:,t)-Q(k,t)).^2;
end
if fident
d(k)=inf;
end
[s,t]=sort(d);
idx(k,:)=t(1:K);
D(k,:)=s(1:K);
end
end
if nargout>1
D=sqrt(D);
end
toc
matlabpool close
end
 
function [Q,R,K,fident,numCore] = parseinputs(varargin)
% Check input and output
error(nargchk(1,4,nargin));
 
Q=varargin{1};
 
if nargin<2
R=Q;
fident = true;
else
fident = false;
R=varargin{2};
end
 
if isempty(R)
fident = true;
R=Q;
end
 
if ~fident
fident = isequal(Q,R);
end
 
if nargin<3
K=1;
else
K=varargin{3};
end
 
if nargin<4
numCore=0;
else
numCore=varargin{4};
end

