function [ estForSeconds ] = getEstForSecFromFrame( estForFrames, FPS )
length = floor(numel(estForFrames)/FPS);

estForSeconds = zeros(1,length);

for i=1:length
    from = max(round((i-1)*FPS),1);
    to = min(round(from+FPS-1),numel(estForFrames));
    
   estForSeconds(i) = mean(estForFrames(from:to)); 
    
end
end

