% Create model file for LandmarkRS from model file of FLANDMARK lib.
%

clc, clear, close all

outputModelFile = 'm8_flandmark_model_rs.dat';
inputModelFile  = '../../dependencies/LandmarkRS/data/model.mat';

%%

load(inputModelFile,'model');

% edges directed to root
Edges = [2 3 4 5 6 7 8;       % from node 1-based
         1 1 1 1 2 3 1];      % to node 1-based

nEdges     = 7;
nLandmarks = 8;

fid = fopen(outputModelFile, 'w');    

%image size
fwrite(fid, 40, 'integer*4');     % image with
fwrite(fid, 40, 'integer*4');     % image height

% node classifiers
fwrite(fid, nLandmarks, 'integer*4');     % write number of nodes
for i = 1 : nLandmarks
    fwrite(fid, numel(model.W(model.data.mapTable(i, 1):model.data.mapTable(i, 2))), 'integer*4');
    fwrite(fid, model.data.mapTable(i, 1) - 1, 'integer*4'); % from in W 0-based
    fwrite(fid, model.data.mapTable(i, 2) - 1, 'integer*4'); % to in W 0-based
    fwrite(fid, model.W(model.data.mapTable(i, 1):model.data.mapTable(i, 2)), 'real*8');
    fwrite(fid, model.data.options.S(:,i)-1, 'integer*4'); % from 1-based Matlab to 0-based C
    fwrite(fid, model.data.options.components(1, i), 'integer*4'); % comp width
    fwrite(fid, model.data.options.components(2, i), 'integer*4'); % comp height
    fwrite(fid, 4, 'integer*4'); % height of lbp pyramid
end

% write deformable parts model - must be in form of coeeficients [dx dy dx^2 dy^2]
fwrite(fid, nEdges, 'integer*4');         % write number of edges
fwrite(fid, Edges(:)-1, 'integer*4');       % write edges // 0-based labelling
% WARNING: Its not clear why the map table starts at i+1...
for i = 1 : nEdges
    fwrite(fid, numel(model.W(model.data.mapTable(i+1, 3):model.data.mapTable(i+1, 4))), 'integer*4');
    fwrite(fid, model.data.mapTable(i+1, 3) - 1, 'integer*4'); % from in W 0-based 
    fwrite(fid, model.data.mapTable(i+1, 4) - 1, 'integer*4'); % to in W 0-based
    fwrite(fid, model.W(model.data.mapTable(i+1, 3):model.data.mapTable(i+1, 4)), 'real*8');

end

fclose(fid);
