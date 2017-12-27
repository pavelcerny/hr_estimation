% create hr annotations from .txt files annotated for frames
% format:
% 0 56           ..frame hr
% 254 59         ..frame hr
% 389 62         ..frame hr
% 
FPS = 24;
FOLDER = ['../../video/2014-Plesek/' int2str(FPS) 'fps/'];

videos = dir(fullfile(FOLDER, ['*.txt']));

for i = 1: numel(videos)
    video = videos(i).name;
    annotatedHR = readHRAnnotation_frames(FOLDER, video);
    annotatedHR'
    
    annotatedHR(:,1) = annotatedHR(:,1)/FPS;
    
    from=1; 
    to = 2;
    one_s_annotation = zeros(1,floor(annotatedHR(end,1))+1);
    for i=1:floor(annotatedHR(end,1))+1
        
        currTime = i-1;
        if currTime > annotatedHR(to,1)
            to = to+1;
            from = from +1;
        end
        linearIdx = currTime/ (annotatedHR(to,1)-annotatedHR(from,1));
        weight = linearIdx-floor(linearIdx);
        
        interpolatedValue = annotatedHR(from,2)*(1-weight) + annotatedHR(to,2)*(weight);
        one_s_annotation(i) = interpolatedValue;
    end
    
    one_s_annotation = one_s_annotation(2:end);
    [~, name] = fileparts(video);
     fid = fopen([FOLDER name '.1sbpm'],'w');    
     fprintf(fid,'%.1f\n',one_s_annotation);
    fprintf('%.1f ',one_s_annotation);
     fclose(fid);
    
end