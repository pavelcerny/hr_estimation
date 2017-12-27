function [ middle ] = getMiddleFromCorners( corners )

xs=corners(1,:);
ys=corners(2,:);

middle = [ mean(xs), mean(ys) ];


end

