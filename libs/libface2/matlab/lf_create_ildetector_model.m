%% This script collects independent landmark detector models
% and puts them to a single array which is saved to a file.
%

landmarkTags = {'nose','leftEyeLeftCanthus','leftEyeRightCanthus',...
                'rightEyeRightCanthus', 'rightEyeLeftCanthus', ...
                'leftMouthCorner','rightMouthCorner'};

outputFolder = '../../vlandmark/results/local_sosvm/case1/';
bestLambda = [0.01 0.01 0.01 0.01 0.01 0.01 0.01];
split = 1;

detectorFile = '../data/ilDetector.mat';

%%
M = numel( landmarkTags );

ilDetector = [];
for l = 1 : M
    lambda    = bestLambda( l );
    modelFile = sprintf('%strn+val_model_%s_lambda%f_split%d.mat', ...
                        outputFolder, landmarkTags{l}, lambda, split);
    
    Tmp = load( modelFile );
    if l == 1, ilDetector = Tmp; else ilDetector(l) = Tmp; end
end

save(detectorFile,'ilDetector');

% EOF