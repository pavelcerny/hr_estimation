% Demo: Age+gender prediction. 
%
% VF 2014
%

imageFile    = '../testimg/people-01.jpg';
%imageFile    = '../testimg/pussy_riot_gray.png';

ageModelFile    = '/home/xfrancv/Work/Faces/AgeEstimation/trunk2/results/pwmord/case10/split1_model_lambda0.001000.mat';
genderModelFile = '../data/genderModelCase85.dat';

% cannonical face
Setup.landmarks = [20.04  16.3453   24.6547   14.4494   26.5506    9.8357   31.1643;...
                   30.5   24.2554   24.2554   39.8669   39.8669   24.2554   24.2554];
Setup.numRows   = 60;
Setup.numCols   = 40;
Setup.pyramidHeight = 4;

%%

% load gender model
fid       = fopen( genderModelFile );
numParams = fread( fid, 1, 'uint32' );
Gender.W  = fread( fid, numParams-1, 'double' );
Gender.W0 = fread( fid, 1, 'double' );
fclose( fid );

% load age model
load( ageModelFile, 'Model' );


% face detector
[pModuleState,pFnc] = esInit();

% landmark detector
addpath('/home/xfrancv/Work/Faces/clandmark/clandmark_2014_01_24/mex/');
Flandmark = flandmark_class('/home/xfrancv/Work/Faces/clandmark/clandmark_2014_01_24/data/8Lfrontal_LFW_SPLIT_1.xml');


% load inoput image
I = imread( imageFile );
if ndims(I) == 3, I = rgb2gray( I ); end
imshow( I );
hold on;

% find faces
[Detections, pDetRes] = esRunDetector( I, pModuleState, pFnc);
[faceBoxes,~,angles]  = esGetFaceBoxes( Detections );
nFaceBoxes            = numel( Detections );

% process all detected faces
for i = 1 : nFaceBoxes 
    
    % face box
    fb = faceBoxes(:,i);
    
    % landmarks
    L  = Flandmark.detect( I, int32( fb ));
    
    % affine normalization
    face = lf_affinenormrect( I, L(:,1:end-1), Setup.landmarks, Setup.numRows, Setup.numCols );
%    figure(i+1); imshow(face);

    % features
    feat = lbppyr( face , Setup.pyramidHeight);

    % gender prediction
    genderScore = Gender.W'*double(feat) + Gender.W0;
    
    % age prediction
    proj     = Model.V'*double(feat);
    ageScore = Model.A'*proj + Model.W0;
    [maxScore, predAge] = max(ageScore);

    % show predictions
    figure(1);
    h0 = plotbox( fb );
    set(h0,'linewidth', 2);
    h1 = text( fb(1), fb(4)+5, sprintf('Yaw=%.1f', angles(3,i) ) );
    plot(L(1,:),L(2,:),'+r');
    h2 = text( fb(1), fb(4)+25, sprintf('gen=%.2f', genderScore ));
    h3 = text( fb(1), fb(4)+50, sprintf('age=%d', predAge-1 ));
    
    set( h0,  'color','m' );    
    set( [h1 h2 h3], 'color','m','fontsize',18);
    
end

