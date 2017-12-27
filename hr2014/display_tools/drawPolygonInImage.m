function [ Image ] = drawPolygonInImage( Image, corners, color )

if nargin <3
    color = [0 0 255];
end

corners = corners (:, [1:size(corners,2) 1]);

for i=1:size(corners,2)-1
    delta = abs(corners(:,i)-corners(:,i+1));
    x1 = corners(1,i);
    x2 = corners(1,i+1);
    y1 = corners(2,i);
    y2 = corners(2,i+1);
    
    if delta(1) > delta(2)        
        step = sign(x2-x1);
        for x=round(x1):step:round(x2)
            y= round((x-x2)*(y1-y2)/(x1-x2)+y2);
            Image(y,x,:)=color;
        end
    else
        step = sign(y2-y1);
        for y=round(y1):step:round(y2)
            x= round((x1-x2)*(y-y2)/(y1-y2)+x2);
            Image(y,x,:)=color;
        end
    end
    
end


end

