function [ prevIdx ] = prevIdxInArray( idx, array)

prevIdx = mod(idx-2,size(array,2))+1;

end

