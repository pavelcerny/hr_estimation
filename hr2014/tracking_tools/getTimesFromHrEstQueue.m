function [ timestamps ] = getTimesFromHrEstQueue( HrEstStruct )

if HrEstStruct.frameLength < HrEstStruct.maxFrameLength
    timestamps = HrEstStruct.cachedTimestamps(1:HrEstStruct.frameLength);
else
    timestamps =  HrEstStruct.cachedTimestamps([HrEstStruct.index:end 1:HrEstStruct.index-1]);
end

end
