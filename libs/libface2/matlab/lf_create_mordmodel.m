%

inputMatModel = '/home/xfrancv/Work/Faces/AgeEstimation/trunk2/results/pwmord/case10/split1_model_lambda0.001000.mat';
outputBinModel = '../data/ageModelPwMordCase10_l0001new.dat';

%%
if exist( outputBinModel, 'file' )
    error(sprintf('Output model %s already exists.', outputBinModel));
end

%%
load( inputMatModel );

[numParams,numLatentVars] = size(Model.V);
numClasses = length( Model.W0 );

%%
fid = fopen(outputBinModel, 'w+');

fwrite( fid, numParams,'uint32');
fwrite( fid, numClasses, 'uint32');
fwrite( fid, numLatentVars, 'uint32');

% save V
for i=1:numLatentVars
    for j=1:numParams
        fwrite( fid, Model.V(j,i), 'double');
    end
end

% save W0
for i=1:numClasses
    fwrite( fid, Model.W0(i), 'double');
end

% save A
for i=1:numClasses
    for j=1:numLatentVars
        fwrite( fid, Model.A(j,i),'double');
    end
end

fclose(fid);

fprintf('MAT model %s\n', inputMatModel);
fprintf('saved to binary format %s\n', outputBinModel );

%