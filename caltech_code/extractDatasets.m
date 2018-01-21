% adding required files into path
addpath(genpath('piotr_toolbox'));
addpath(genpath('eth_data'));
% extracting usatrain images
dbInfo('usatrain');
disp('extracting usatrain dataset');
dbExtractSSD('../trainval',1);
%dbInfo('eth');
%disp('extracting eth dataset');
%dbExtractSSD('../trainval',1);
% extracting seperate eth pedestrian dataset
%extractEth('../trainval');
%disp('extracting tud-brussels dataset');
%dbInfo('tudbrussels');
%dbExtractSSD('../trainval',1);
% extracting test
disp('extracting usatest dataset');
dbInfo('usatest');
dbExtractSSD('../test',1);