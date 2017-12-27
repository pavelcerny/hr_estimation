function [ h ] = displayEstimations( hrfitness,hrestimated,hrfiltered,videoHeight,h, HrEstStruct)
X_SCALE = 10;

zerooffset_y = videoHeight-size(hrfitness,1);
hrline_y = hrestimated-HrEstStruct.hrLowerBound+zerooffset_y;
hrline_x = [1:numel(hrestimated)]*X_SCALE;
filterline_y = hrfiltered-HrEstStruct.hrLowerBound+zerooffset_y;

% fitness colorful graph
if isempty(h.fitness)
    h.fitness = imagesc(1:size(hrfitness,2)*X_SCALE,...
        zerooffset_y:videoHeight,...
        hrfitness,[0.1 0.5]);
    colormap jet;
else
    set(h.fitness,'CData',hrfitness);
end

% show estimations
if ~isempty(h.estimations)
    delete(h.estimations);
end
h.estimations = line(hrline_x, hrline_y);
%set distinctive for estimations
set(h.estimations,'color','w');
set(h.estimations,'LineWidth',2);

if ~isempty(h.filter)
    delete(h.filter);
end
    h.filter = line(hrline_x,filterline_y);
%set distinctive for estimations
set(h.filter,'color',[0 0 0]);
set(h.filter,'LineWidth',2);


if ~isempty(h.hrLowerText)
    delete(h.hrLowerText);
end
h.hrLowerText = text(numel(hrestimated)*X_SCALE+10,zerooffset_y+5,[int2str(HrEstStruct.hrLowerBound) ' bpm']);
%set distinctive for estimations
set(h.hrLowerText,'color','y');

if ~isempty(h.hrUpperText)
    delete(h.hrUpperText);
end
h.hrUpperText = text(numel(hrestimated)*X_SCALE+10,videoHeight-5,[int2str(HrEstStruct.hrUpperBound) ' bpm']);
%set distinctive for estimations
set(h.hrUpperText,'color','y');



end

