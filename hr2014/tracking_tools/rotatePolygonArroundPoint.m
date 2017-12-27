function [ rotatedCorners ] = rotatePolygonArroundPoint( corners, point, angle )

cornersX=corners(1,:);
cornersY=corners(2,:);

polarCornersAngle = zeros(1,size(corners,2));
polarCornersDist = zeros(1,size(corners,2));
for i = 1:size(corners,2)
    [polarCornersAngle(i), polarCornersDist(i)] = cart2pol(cornersX(i)-point(1),cornersY(i)-point(2));
end


rotatedCorners = zeros(2,size(corners,2));
for i = 1:size(corners,2)
    [x,y] = pol2cart(polarCornersAngle(i)-angle, polarCornersDist(i));
    rotatedCorners(:,i)=[x+point(1),y+point(2)]';
end


end

