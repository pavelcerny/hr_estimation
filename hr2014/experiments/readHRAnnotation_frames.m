function [anotatedHR] = readHRAnnotation_frames( folder, video)
% Loads from the file "videoName.bpm" HR-annotanion to video and returns it
% as vector (hr annotation period is 1 sec)


[~, name] = fileparts(video);

fid = fopen([folder name '.txt']);

anotatedHR=[];
scan = fscanf(fid, '%d %d', 2);
while ~isempty(scan)
    anotatedHR=[anotatedHR; scan'];
    scan = fscanf(fid, '%d %d', 2);    
end
fclose(fid);

end