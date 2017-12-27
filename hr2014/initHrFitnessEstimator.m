function [ DataStruct ] = initHrFitnessEstimator(maxFrameLength )
HR_LOWER_BOUND = 45;
HR_UPPER_BOUND = 220;

DataStruct = struct('maxFrameLength', maxFrameLength,...
                    'cachedMeasures' , zeros(3,maxFrameLength),...
                    'cachedTimestamps', zeros(1,maxFrameLength),...
                    'frameLength', 0,...
                    'index', 1,...
                    'hrLowerBound', HR_LOWER_BOUND,...
                    'hrUpperBound', HR_UPPER_BOUND,...
                    'hrNoPossibleFQ', HR_UPPER_BOUND-HR_LOWER_BOUND+1,...
                    'hrFitness',zeros(1,HR_UPPER_BOUND-HR_LOWER_BOUND+1));


end