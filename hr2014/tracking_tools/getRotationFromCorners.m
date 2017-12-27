function [ angle ] = getRotationFromCorners( corners )
cornersX=corners(1,:);
cornersY=corners(2,:);

middle = getMiddleFromCorners(corners);

angleTR = cart2pol(cornersX(2)-middle(1),cornersY(2)-middle(2));
angleBR = cart2pol(cornersX(3)-middle(1),cornersY(3)-middle(2));


angle = mean([angleTR, angleBR]);

end

