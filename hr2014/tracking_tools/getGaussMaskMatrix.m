function [M, MM] = getGaussMaskMatrix( numCols, numRows, sigma, center  )
% Create matrix with gaussly organized numbers

if nargin <4
    center = [(numCols+1)/2 (numRows+1)/2];
end

if size(sigma,2)<2
    sigmaW = sigma;
    sigmaH = sigmaW;
else
    sigmaW = sigma(1);
    sigmaH = sigma(2);
end

M = min(exp(-((repmat([1:numCols],numRows,1)-center(1)).^2/(sigmaW)^2+ ...
    (repmat([1:numRows]',1,numCols)-center(2)).^2/(sigmaH)^2))*3,1);


% MM=zeros(numRows,numCols);
% for x = 1:numCols
%     for y = 1:numRows
%         MM(x,y) = min(1, 3* exp( -( (x-center(1))^2/(sigmaW)^2 + (y-center(2))^2/(sigmaH)^2    )  )  );
%     end
% end

end

