function [ p ] = getPFromCorners( corners )
% returns p param for IVT tracking
% corners must be corners of square in order
% topleft,topright,botright,botleft

corners = corners(:,1:4);
TL=corners(:,1);
TR=corners(:,2);
BL=corners(:,4);
w = sqrt((TL(1)-TR(1))^2 + (TL(2)-TR(2))^2);
h = sqrt((TL(1)-BL(1))^2 + (TL(2)-BL(2))^2);

rot = acos(sum([TR(1)-TL(1); TR(1)-TL(1)] .* [ 1; 0])/w);

p = [mean(corners(1,:)) mean(corners(2,:)) w h rot];

end

