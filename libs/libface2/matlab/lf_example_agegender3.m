% Demo: Age+gender prediction. 
%
% VF 2014
%


% loas test images with face boxes
load( '../testimg/test_faces.mat','Faces' );

ageModelFile    = '/home/xfrancv/Work/Faces/AgeEstimation/trunk2/results/pwmord/case10/split1_model_lambda0.001000.mat';
genderModelFile = '../data/genderModelCase85.dat';
flandmarkFile   = '../../clandmark/clandmark_2014_01_24/data/8Lfrontal_LFW_SPLIT_1.xml';

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


% landmark detector
addpath('../../clandmark_2014_01_24/mex/');
Flandmark = flandmark_class( flandmarkFile );


% process all detected faces
for i = 1 : numel( Faces ) 
    
    % 
    I  = Faces(i).img;

    % face box
    fb = Faces(i).faceBoxFD;
    
    % landmarks
    L  = Flandmark.detect( I, int32( fb ));
    
    % affine normalization
    face = lf_affinenormrect( I, L(:,1:end-1), Setup.landmarks, Setup.numRows, Setup.numCols );

    % features
    feat = lbppyr( face , Setup.pyramidHeight);

    % gender prediction
    genderScore = Gender.W'*double(feat) + Gender.W0;
    
    % age prediction
    proj     = Model.V'*double(feat);
    ageScore = Model.A'*proj + Model.W0;
    [maxScore, predAge] = max(ageScore);

    % show predictions
    figure;
    imshow( I,[] ); 
    hold on;
    h0 = plotbox( fb );
    set(h0,'linewidth', 2);
    plot(L(1,:),L(2,:),'+r');
    h1 = text( fb(1), fb(4), sprintf('gen=%.2f', genderScore ));
    h2 = text( fb(1), fb(4)+25, sprintf('age=%d', predAge-1 ));
    
    set( h0,  'color','g' );    
    set( [h1 h2], 'color','g','fontsize',18);
    
    pause;
    close all;
end

