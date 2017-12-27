function [ videos ] = getVideoFilesInfos( FOLDER, formats )
i =1;
videos = dir(fullfile(FOLDER, ['*.' formats{i}]));
while numel(videos) <1 && i < numel(formats)
    i=i+1;
    videos = dir(fullfile(FOLDER, ['*.' formats{i}])); 
    
end

end

