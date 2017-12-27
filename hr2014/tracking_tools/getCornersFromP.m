function [ corners ] = getCornersFromP( p )
%bb in form [topleftX topleftY botRightX botRightY]

middleX = p(1);
middleY = p(2);
w = p(3);
h = p(4);
rot = p(5);

cornersX = [ middleX-w/2 middleX+w/2 middleX+w/2 middleX-w/2];
cornersY = [ middleY-h/2 middleY-h/2 middleY+h/2 middleY+h/2];

corners = zeros(2,4);
for i = 1:4
    [angle, dist] = cart2pol(cornersX(i)-middleX,cornersY(i)-middleY);
    [x,y] = pol2cart(angle+rot,dist);
    corners(:,i) = [x+middleX,y+middleY]';
end

return

