function [ Data ] = hrFitnessUpdate( measurement, timestamp, Data )
if Data.frameLength < Data.maxFrameLength
    Data.frameLength = Data.frameLength + 1;
end

Data.cachedMeasures(:,Data.index) = measurement;
Data.cachedTimestamps(Data.index) = timestamp;


%prepare Data for next running
Data.index = mod(Data.index,Data.maxFrameLength)+1;
end

