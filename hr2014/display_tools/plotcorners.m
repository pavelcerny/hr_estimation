function handler = plotcorners( corners,color,width )
    handler = line(corners(1,[1:size(corners,2) 1]),corners(2,[1:size(corners,2) 1]));
    if nargin > 1 
    set(handler,'color',color);
    end
    if nargin > 2 
        set(handler,'LineWidth',width)
    end
    
    %line(corners(1,[1:4]),corners(2,[1:4]));
end

