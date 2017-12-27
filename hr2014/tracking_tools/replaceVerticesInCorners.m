function [ result ] = replaceVerticesInCorners( corners, from, to, replacement)

if from <= to
    result = replaceElementsInCorners(corners, from, to, replacement);
else    
    result = replaceElementsInCorners(corners, 1, to, replacement);
    newFrom =  size(result,2) - size(corners,2) + from;
    result = replaceElementsInCorners(result,newFrom, size(result,2),zeros(2,0));
end

end

