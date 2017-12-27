function [ nextIdx ] = nextIdxInArray( idx, array )

nextIdx = mod(idx,size(array,2))+1;

end

