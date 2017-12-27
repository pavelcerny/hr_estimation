function [hr,idx] = findHrFromFitness(HrEstStruct,fitness)

[~,idx] = min(fitness);
hr = idx+ HrEstStruct.hrLowerBound-1;

end