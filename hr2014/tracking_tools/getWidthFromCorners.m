function [ width ] = getWidthFromCorners( corners )
if size(corners,1) ~= 2 || size(corners,2) ~= 4
    error('dimmension missmatch, Corners must be 2x4 matrix');
end

width = euklidianDistance(corners(:,1)',corners(:,2)');


end

