function [EyeScanModuleDir,LandmarkModel] = initPaths( libPath )

%set eyescan module dir
EyeScanModuleDir = [libPath 'Release-EyeScan-20130806-Ubuntu-11.04-x86_64/eyescansdk/'];

%load flandmark model
load([libPath 'uricamic-flandmark-5c55724/data/model.mat']);
LandmarkModel = model;
LandmarkModel.landmarkUpdateCoef = 0.8;
clear model;

%common libs
addpath('./display_tools/');
addpath('./tracking_tools/');
addpath('./developing_tools/');
addpath([libPath 'movie/']);



addpath([libPath 'uricamic-flandmark-5c55724/bin/cpp/mex']);
addpath([libPath 'uricamic-flandmark-5c55724/learning/flandmark_data/Functions/']);
addpath([libPath 'Release-EyeScan-20130806-Ubuntu-11.04-x86_64/mex/']);

%IVT
addpath([libPath 'ivt/']);

%3Dlandmark
addpath([libPath 'libface2/matlab/']);
addpath([libPath '3dlandmark']);
addpath([libPath 'mexopencv/']);
% addpath('/home/noxx/stprtool/stprtool/trunk/');
% stprpath('/home/noxx/stprtool/stprtool/trunk');


%
%This is neeeded only for benchmarking and runing experiments
%This is not needed for realtime estimation from webcam/videofile
addpath('./experiments/')
