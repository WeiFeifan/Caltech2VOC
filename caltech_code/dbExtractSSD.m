function dbExtractSSD( tDir, flatten, skip )
% Extract database to directory of images and ground truth text files.
%
% Call 'dbInfo(name)' first to specify the dataset. The format of the
% ground truth text files is the format defined and used in bbGt.m.
%
% USAGE
%  dbExtract( tDir, flatten )
%
% INPUTS
%  tDir     - [] target dir for image data (defaults to dataset dir)
%  flatten  - [0] if true output all images to single directory
%  skip     - [] specify frames to extract (defaults to skip in dbInfo)
%
% OUTPUTS
%
% EXAMPLE
%  dbInfo('InriaTest'); dbExtract;
%
% See also dbInfo, bbGt, vbb
%
% Caltech Pedestrian Dataset     Version 3.2.1
% Copyright 2014 Piotr Dollar.  [pdollar-at-gmail.com]
% Licensed under the Simplified BSD License [see external/bsd.txt]

[pth,setIds,vidIds,~,~,dsname] = dbInfo;
if(nargin<1 || isempty(tDir)), tDir=pth; end
if(nargin<2 || isempty(flatten)), flatten=0; end
if(nargin<3 || isempty(skip)), [~,~,~,skip]=dbInfo; end
count = 0;
for s=1:length(setIds)
  display(['extracting set0',num2str(setIds(s))]);
  for v=1:length(vidIds{s})
    % load ground truth
    name=sprintf('set%02d/V%03d',setIds(s),vidIds{s}(v));
    A=vbb('vbbLoad',[pth '/annotations/' name]); n=A.nFrame;
    if(flatten), post=''; else post=[name '/']; end
    if(flatten), f=[name '_']; f(6)='_'; else f=''; end
    fs=cell(1,n); for i=1:n, fs{i}=[f 'I' int2str2(i-1,5)]; end
    % extract images
    td=[tDir '/images/' post]; if(~exist(td,'dir')), mkdir(td); end
    sr=seqIo([pth '/videos/' name '.seq'],'reader'); info=sr.getinfo();
    for i=skip-1:skip:n-1
      f=[td fs{i+1} '_' dsname '.' info.ext]; if(exist(f,'file')), continue; end
      sr.seek(i); I=sr.getframeb(); f=fopen(f,'w'); fwrite(f,I); fclose(f);
    end; sr.close();
    % extract ground truth
    td=[tDir '/annotations/' post];
    for i=1:n, fs{i}=[fs{i} '_' dsname '.txt']; end
    count = count + vbbToFiles(A,td,fs,skip,skip);
  end
end
disp(['There are ',num2str(count),' annotations of persons']);
end

function count = vbbToFiles( A, tarDir, fs, skip, f0, f1 )
% export single frame annotations to tarDir/*.txt
nFrm=A.nFrame; fName=@(f) ['I' int2str2(f-1,5) '.txt'];
if(nargin<3 || isempty(fs)), for f=1:nFrm, fs{f}=fName(f); end; end
if(nargin<4 || isempty(skip)), skip=1; end
if(nargin<5 || isempty(f0)), f0=1; end
if(nargin<6 || isempty(f1)), f1=nFrm; end
if(~exist(tarDir,'dir')), mkdir(tarDir); end

count = 0;
for f=f0:skip:f1
  nObj=length(A.objLists{f}); objs=bbGt('create',nObj);
  for j=1:nObj
    o=A.objLists{f}(j); objs(j).lbl=A.objLbl{o.id}; objs(j).occ=o.occl;
    objs(j).bb=round(o.pos); objs(j).bbv=round(o.posv);
  end
  count = count + bbGt('bbSaveSSD',objs,[tarDir '/' fs{f}],0);
end
end

