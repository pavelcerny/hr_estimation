function [ bb ] = bbFromCorners(corners)

xs=corners(1,:);
ys=corners(2,:);

if size(corners,2) ~= 4
    error('given parameter does not have 4 corners');
end

bb = [ min(xs), min(ys), max(xs), max(ys)];

end

