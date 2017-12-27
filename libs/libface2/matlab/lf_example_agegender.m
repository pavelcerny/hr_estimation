

imageFile = '../testimg/pussy_riot_gray.png';
%ageModel = '../data/ageModelPwMordCase10_l01.dat';
ageModelFile = '/home/xfrancv/Work/Faces/AgeEstimation/trunk2/results/pwmord/case10/split1_model_lambda0.001000.mat';
genderModelFile = '../data/genderModelCase85.dat';
landmarkFile = '../testimg/pussy_riot.landmarks';

% cannonical face
Ini.landmarks = [20.04  16.3453   24.6547   14.4494   26.5506    9.8357   31.1643;...
               30.5   24.2554   24.2554   39.8669   39.8669   24.2554   24.2554];
Ini.numRows = 60;
Ini.numCols = 40;
Ini.pyramidHeight = 4;

%%
addpath ../../Benchmarks/common/;

% landmarks
landmarks = load( landmarkFile );

%
fid = fopen( genderModelFile );
numParams = fread( fid, 1, 'uint32');
Gender.W = fread( fid, numParams-1, 'double');
Gender.W0 = fread( fid, 1, 'double');
fclose(fid);

%
load( ageModelFile );

%
I = imread( imageFile );


%
face = lf_affinenormrect( I, landmarks, Ini.landmarks, Ini.numRows, Ini.numCols );
    
feat = lbppyr( face , Ini.pyramidHeight);

%I2 = imread('tmp.png');
%I3 = imread('tmp2.png');


genderScore = Gender.W'*double(feat) + Gender.W0
    
    
%    score = Model.W'*double(feat) + Model.W0;
proj = Model.V'*double(feat);
score = Model.A'*proj + Model.W0;
[maxScore, predAge] = max(score);
predAge-1
    
