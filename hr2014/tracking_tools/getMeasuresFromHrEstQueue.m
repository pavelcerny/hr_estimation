function [ measures ] = getMeasuresFromHrEstQueue( HrEstStruct )
if HrEstStruct.frameLength < HrEstStruct.maxFrameLength
    measures = HrEstStruct.cachedMeasures(:,1:HrEstStruct.frameLength);
else
    measures =  HrEstStruct.cachedMeasures(:,[HrEstStruct.index:end 1:HrEstStruct.index-1]);
end

end

