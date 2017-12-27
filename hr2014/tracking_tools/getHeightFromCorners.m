function [ height ] = getHeightFromCorners( corners )
if size(corners,1) ~= 2 || size(corners,2) ~= 4
    error('dimmension missmatch, Corners must be 2x4 matrix');
end

height = euklidianDistance(corners(:,2)',corners(:,3)');

end

