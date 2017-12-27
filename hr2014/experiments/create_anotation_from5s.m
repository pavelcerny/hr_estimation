% create hr annotations from .bpm files annotated every 5th second
% format:
% 56         ..hr t=5;
% 59         ..hr t=10;
% 62         ..hr t=15;
%

FOLDER = '../../video/2012-08-09-CMP-cam2/';
FPS = 15;
folder = ['../../video/2012-08-09-CMP-cam2/' int2str(FPS) 'fps/'];


videos = dir(fullfile(folder, ['*.bpm']));
ANNOTATION_INTERVAL = 5;

for i = 1: numel(videos)
    video = videos(i).name;
    annotatedHR = readHRAnnotation5s(folder, video);
    annotatedHR = [annotatedHR(1) annotatedHR]
    
    
    intervalsEst = 1 ;
    interpolatedAnnotatedHR = zeros(1,30);
    for j = 1:size(interpolatedAnnotatedHR, 2)
        
        currTime = ANNOTATION_INTERVAL+j;        
        linearIdx = currTime / ANNOTATION_INTERVAL;        
        weight = linearIdx-floor(linearIdx);        
        interpolatedAnnotatedHR(j)=annotatedHR(floor(linearIdx))*(1-weight) + annotatedHR(ceil(linearIdx))*weight;
    end
    
    [~, name] = fileparts(video);
    fid = fopen([folder name '.1sbpm'],'w');    
    fprintf(fid,'%.1f\n',interpolatedAnnotatedHR);
    fprintf('%.1f ',interpolatedAnnotatedHR);
    fclose(fid);
    
end


