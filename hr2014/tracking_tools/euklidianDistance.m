function [ distance ] = euklidianDistance( X, Y )
distance = sqrt(sum((X - Y).^2));
end

