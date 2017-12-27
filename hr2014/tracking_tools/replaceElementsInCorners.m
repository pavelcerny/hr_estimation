function [ newCorners] = replaceElementsInCorners( corners, fromPos, toPos, replacement )
if fromPos == 1
    if toPos == size(corners,2)
        newCorners = replacement;
    else
        newCorners = [replacement'; corners(:,toPos+1:end)' ]';
    end
else
    if toPos == size(corners,2)
        newCorners = [corners(:,1:fromPos-1)'; replacement' ]';
    else
        newCorners = [corners(:,1:fromPos-1)'; replacement'; corners(:,toPos+1:end)' ]';
    end
end


end

