function [ lowPassedMeasurement, Data] = hiPassFilter( measurement, Data)
% Takes mesurement and substract from it the mean of measurement plus
% (Data.maxFrameLength-1) previous ones

if Data.frameLength < Data.maxFrameLength
    Data.frameLength = Data.frameLength + 1;
end

oldestMeasurement = Data.cachedMeasures(:,Data.index);

Data.cachedMeasures(:,Data.index) = measurement;

%Data.cachedMeasures is supposed to be zeros if not used before.
% Mean value is computed based on previous values only!
% for offline version would be better to use following measurements too.
mean = (Data.previousMean * Data.previousFrameLength + ( measurement-oldestMeasurement) )/ Data.frameLength;
lowPassedMeasurement = measurement - mean;

%prepare Data for next running
Data.index = mod(Data.index,Data.maxFrameLength)+1;
Data.previousMean = mean;
Data.previousFrameLength = Data.frameLength;
end

