% This script evaluates responses of landmark detectors.
%

load('../testimg/test_faces.mat','Faces');    % test images
load('../data/ilDetector.mat','ilDetector');  % landmark detectors

N = numel( Faces );      % num of faces
M = numel( ilDetector ); % number of landmarks

% get landmark names
landmarkTags = [];
for i = 1 : M, landmarkTags{i} = ilDetector(i).landmarkTag; end

% go over images and plot landmarks
for i = 1 : N
    
    figure(1); imshow( Faces(i).img ); hold on;
    
    faceBox = Faces(i).faceBoxFD;
    plotbox( faceBox );

    % detector works on integral image
    iImg = lf_integralimg( Faces(i).img  );
    
    % get manual landmark annotations
    L = [];
    for j = 1 : M
        eval(['tmp = Faces(i).' landmarkTags{j} ';']);
        L(1,j) = tmp(1) - faceBox(1)+1; 
        L(2,j) = tmp(2) - faceBox(2)+1;
    end
    
    accCpuTime = 0;
    for j = 1 : M   
        % eval landmark score inside faceBox for j-th landmark
        
        faceBoxSize    = [(faceBox(3)-faceBox(1)+1) (faceBox(4)-faceBox(2)+1)];
        scanWinSizePx  = round( [ilDetector(j).scanWinSize(1)*faceBoxSize(1) ...
                                 ilDetector(j).scanWinSize(2)*faceBoxSize(2)] );
        
        [score, cpuTime] = lf_lbppyrdetector_score(iImg, faceBox, ...
                              ilDetector(j).baseWinSize, ...
                              scanWinSizePx, ...
                              ilDetector(j).lbpPyrHeight, ...
                              ilDetector(j).W);
        accCpuTime = accCpuTime + cpuTime;
        
        % plot
        face = imcrop( Faces(i).img, [faceBox(1) faceBox(2) ...
            faceBox(3)-faceBox(1)+1 faceBox(4)-faceBox(2)+1]);

        [x,y] = find( score == max(score(:)));
        h = figure(j+1);
        set(h, 'name', ilDetector(j).landmarkTag);
        faceRgb = repmat( face,[1 1 3]);
        imshow( faceRgb );
        hold on;
        contour( 3*score );
        colorbar;
        plot(y,x,'xm','markersize',12);
        plot(L(1,j),L(2,j),'r+','markersize',12);
    end
    
    fprintf('cpu time per landmark = %f[s]\n', accCpuTime/M);
    
    pause;
    close all;
end

% EOF