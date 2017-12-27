function [ overlap ] = getBBwithSquareOverlap( bb, squareXs,squareYs,debug )
% finds area of intersection of two rectangles given by clockwise-ordered
% vertices and computes their intersection/unification ratio

if nargin<4
    debug = 0;
end

x1 = bb(1);
x2 = bb(3);
y1 = bb(2);
y2 = bb(4);

baseRectangle = bb;
corners = [squareXs; squareYs];
intersectCorners = corners;

if debug
    subplot(1,5,1);
    plotbox(baseRectangle,'r');
    plotcorners(intersectCorners);
end
%% < x
cornersOutFlags = zeros(1,size(intersectCorners,2));% 1if out, 0 otherwise
cornersOutIdxs = zeros(1,size(intersectCorners,2)); % indexs of out-corners
outCounter=0;                                       % number of corners out
first=1;                                            % prevents situations ..
last = size(intersectCorners,2);                    % ..as (12)34 or 123(45)
for i=1:size(intersectCorners,2)
    currentX = intersectCorners(1,i);
    currentY = intersectCorners(2,i);
    if currentX < x1                                %is corner out?
        outCounter=outCounter+1;
        cornersOutIdxs(outCounter)=i;
        cornersOutFlags(i)=1;
        currentOut = 1;
    else
        currentOut = 0;
    end
                                        % find transition between in and out
    if i==1
        prevOut=currentOut;
    end
    if prevOut>currentOut
        % stepIn
        last = i-1;
    elseif prevOut<currentOut
        % stepOut
        first=i;
    end
    prevOut=currentOut;
end

if outCounter == 1                          % check if only one corner is out
    last = cornersOutIdxs(1);
    first=cornersOutIdxs(1);
end

nextIdx = nextIdxInArray(last, intersectCorners);
prevIdx = prevIdxInArray(first, intersectCorners);

switch outCounter
    case 0
        
    case size(intersectCorners,2)
        overlap = 0;
        return
    otherwise        
        u1=[intersectCorners(1,last) intersectCorners(2,last)]-[intersectCorners(1,nextIdx) intersectCorners(2,nextIdx)];
        n1=[-u1(2) u1(1)];
        c1= -[intersectCorners(1,last) intersectCorners(2,last)]*n1';
        p1=[n1 c1];
        P1 = [x1 (-p1(3) -p1(1)*x1)/p1(2)];
        
        u2=[intersectCorners(1,first) intersectCorners(2,first)]-[intersectCorners(1,prevIdx) intersectCorners(2,prevIdx)];
        n2=[-u2(2) u2(1)];
        c2= -[intersectCorners(1,first) intersectCorners(2,first)]*n2';
        p2=[n2 c2];
        P2 = [x1 (-p2(3) -p2(1)*x1)/p2(2)];
        
        intersectCorners = replaceVerticesInCorners(intersectCorners,first,last,[P2;P1]');
end

if debug
    subplot(1,5,2);
    plotbox(baseRectangle,'r');
    plotcorners(intersectCorners);
end
%% > x
cornersOutFlags = zeros(1,size(intersectCorners,2));
cornersOutIdxs = zeros(1,size(intersectCorners,2));
outCounter=0;
first=1;
last = size(intersectCorners,2);
for i=1:size(intersectCorners,2)
    currentX = intersectCorners(1,i);
    currentY = intersectCorners(2,i);
    if currentX > x2
        outCounter=outCounter+1;
        cornersOutIdxs(outCounter)=i;
        cornersOutFlags(i)=1;
        currentOut = 1;
    else
        currentOut = 0;
    end
    if i==1
        prevOut=currentOut;
    end
    if prevOut>currentOut
        % stepIn
        last = i-1;
    elseif prevOut<currentOut
        % stepOut
        first=i;
    end
    prevOut=currentOut;
end

if outCounter == 1
    last = cornersOutIdxs(1);
    first=cornersOutIdxs(1);
end

nextIdx = nextIdxInArray(last, intersectCorners);
prevIdx = prevIdxInArray(first, intersectCorners);
switch outCounter
    case 0
        
    case size(intersectCorners,2)
        overlap = 0;
        return
    otherwise        
        u1=[intersectCorners(1,last) intersectCorners(2,last)]-[intersectCorners(1,nextIdx) intersectCorners(2,nextIdx)];
        n1=[-u1(2) u1(1)];
        c1= -[intersectCorners(1,last) intersectCorners(2,last)]*n1';
        p1=[n1 c1];
        P1 = [x2 (-p1(3) -p1(1)*x2)/p1(2)];
        
        u2=[intersectCorners(1,first) intersectCorners(2,first)]-[intersectCorners(1,prevIdx) intersectCorners(2,prevIdx)];
        n2=[-u2(2) u2(1)];
        c2= -[intersectCorners(1,first) intersectCorners(2,first)]*n2';
        p2=[n2 c2];
        P2 = [x2 (-p2(3) -p2(1)*x2)/p2(2)];
        
        intersectCorners = replaceVerticesInCorners(intersectCorners,first,last,[P2;P1]');
end

if debug
    subplot(1,5,3);
    plotbox(baseRectangle,'r');
    plotcorners(intersectCorners);
end
%% < y
cornersOutFlags = zeros(1,size(intersectCorners,2));
cornersOutIdxs = zeros(1,size(intersectCorners,2));
outCounter=0;
currentOut=0;
prevOut=0;
first=1;
last = size(intersectCorners,2);
for i=1:size(intersectCorners,2)
    currentX = intersectCorners(1,i);
    currentY = intersectCorners(2,i);
    
    if currentY < y1
        outCounter=outCounter+1;
        cornersOutIdxs(outCounter)=i;
        cornersOutFlags(i)=1;
        currentOut = 1;
    else
        currentOut = 0;
    end
    if i==1
        prevOut=currentOut;
    end
    if prevOut>currentOut
        % stepIn
        last = i-1;
    elseif prevOut<currentOut
        % stepOut
        first=i;
    end
    prevOut=currentOut;
end

if outCounter == 1
    last = cornersOutIdxs(1);
    first=cornersOutIdxs(1);
end

nextIdx = nextIdxInArray(last, intersectCorners);
prevIdx = prevIdxInArray(first, intersectCorners);
switch outCounter
    case 0
        
    case size(intersectCorners,2)
        overlap = 0;
        return
    otherwise        
        u1=[intersectCorners(1,last) intersectCorners(2,last)]-[intersectCorners(1,nextIdx) intersectCorners(2,nextIdx)];
        n1=[-u1(2) u1(1)];
        c1= -[intersectCorners(1,last) intersectCorners(2,last)]*n1';
        p1=[n1 c1];
        P1 = [(-p1(3) -p1(2)*y1)/p1(1) y1];
        
        u2=[intersectCorners(1,first) intersectCorners(2,first)]-[intersectCorners(1,prevIdx) intersectCorners(2,prevIdx)];
        n2=[-u2(2) u2(1)];
        c2= -[intersectCorners(1,first) intersectCorners(2,first)]*n2';
        p2=[n2 c2];
        P2 = [ (-p2(3) -p2(2)*y1)/p2(1) y1];
        
        intersectCorners = replaceVerticesInCorners(intersectCorners,first,last,[P2;P1]');
end

if debug
    subplot(1,5,4);
    plotbox(baseRectangle,'r');
    plotcorners(intersectCorners);
end
%% > y
cornersOutFlags = zeros(1,size(intersectCorners,2));
cornersOutIdxs = zeros(1,size(intersectCorners,2));
outCounter=0;
first=1;
last = size(intersectCorners,2);
for i=1:size(intersectCorners,2)
    currentX = intersectCorners(1,i);
    currentY = intersectCorners(2,i);
    if currentY > y2
        outCounter=outCounter+1;
        cornersOutIdxs(outCounter)=i;
        cornersOutFlags(i)=1;
        currentOut = 1;
    else
        currentOut = 0;
    end
    if i==1
        prevOut=currentOut;
    end
    if prevOut>currentOut
        % stepIn
        last = i-1;
    elseif prevOut<currentOut
        % stepOut
        first=i;
    end
    prevOut=currentOut;
end

if outCounter == 1
    last = cornersOutIdxs(1);
    first=cornersOutIdxs(1);
end

nextIdx = nextIdxInArray(last, intersectCorners);
prevIdx = prevIdxInArray(first, intersectCorners);
switch outCounter
    case 0
        
    case size(intersectCorners,2)
        overlap = 0;
        return
    otherwise        
        u1=[intersectCorners(1,last) intersectCorners(2,last)]-[intersectCorners(1,nextIdx) intersectCorners(2,nextIdx)];
        n1=[-u1(2) u1(1)];
        c1= -[intersectCorners(1,last) intersectCorners(2,last)]*n1';
        p1=[n1 c1];
        P1 = [(-p1(3) -p1(2)*y2)/p1(1) y2];
        
        u2=[intersectCorners(1,first) intersectCorners(2,first)]-[intersectCorners(1,prevIdx) intersectCorners(2,prevIdx)];
        n2=[-u2(2) u2(1)];
        c2= -[intersectCorners(1,first) intersectCorners(2,first)]*n2';
        p2=[n2 c2];
        P2 = [ (-p2(3) -p2(2)*y2)/p2(1) y2];
        
        intersectCorners = replaceVerticesInCorners(intersectCorners,first,last,[P2;P1]');
end
if debug
    subplot(1,5,5);
    plotbox(baseRectangle,'r');
    plotcorners(intersectCorners);
end


%% compute overlap
intersection = polyarea(intersectCorners(1,:),intersectCorners(2,:));
unification = getHeightFromCorners(corners)*getWidthFromCorners(corners)+(x2-x1)*(y2-y1)-intersection;
overlap = intersection/unification;



end