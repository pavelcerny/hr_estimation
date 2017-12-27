function [anotatedHR] = readHRAnnotation1s( folder, video)
% Loads from the file "videoName.bpm" HR-annotanion to video and returns it
% as vector (hr annotation period is 1 sec)


[~, name] = fileparts(video);

fid = fopen([folder name '.1sbpm']);

anotatedHR=[];
scan = fscanf(fid, '%f', 5);
while ~isempty(scan)
    anotatedHR=[anotatedHR; scan];
    scan = fscanf(fid, '%f', 5);    
end
fclose(fid);

end