function [alignedCorners, middle, angle] = alignRectangle(corners)
% rotates the rectangle arround it's middle to be aligned to axis x and y
if size(corners,2)~=4
    error('given parameter does not have four corners')
end
cornersX=corners(1,:);
cornersY=corners(2,:);
middle = [mean(cornersX), mean(cornersY)];

polarCornersAngle = zeros(1,size(corners,2));
polarCornersDist = zeros(1,size(corners,2));
for i = 1:size(corners,2)
    [polarCornersAngle(i), polarCornersDist(i)] = cart2pol(cornersX(i)-middle(1),cornersY(i)-middle(2));
end

% angle = mean(polarCornersAngle(1:2));
angle = getRotationFromCorners(corners);

alignedCorners = zeros(2,size(corners,2));
for i = 1:size(corners,2)
    [x,y] = pol2cart(polarCornersAngle(i)-angle, polarCornersDist(i));
    alignedCorners(:,i)=[x+middle(1),y+middle(2)]';
end

end
