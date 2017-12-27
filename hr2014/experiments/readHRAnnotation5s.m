function [anotatedHR] = readHRAnnotation5s( folder, video)
% Loads from the file "videoName.bpm" HR-annotanion to video and returns it
% as vector (hr annotation period is 1 sec)


[~, name] = fileparts(video);

fid = fopen([folder name '.bpm']);

anotatedHR=[];
scan = fscanf(fid, '%d', [1 5]);
while ~isempty(scan)
    anotatedHR=[anotatedHR scan];
    scan = fscanf(fid, '%d', [1 5]);    
end
fclose(fid);

end