% This script evaluates responses of landmark detectors.
%

load('../testimg/test_faces.mat','Faces');    % test images
load('../data/ilDetector.mat','ilDetector');  % landmark detectors

N = numel( Faces );      % num of faces
M = numel( ilDetector ); % number of landmarks

landIdx = 2;
faceIdx = 2;


figure(1); imshow( Faces(faceIdx).img ); hold on;
    

faceBox = Faces(faceIdx).faceBoxFD;
plotbox( faceBox );

face = imcrop( Faces(faceIdx).img, [faceBox(1) faceBox(2) ...
    faceBox(3)-faceBox(1) faceBox(4)-faceBox(2)]);

iImg = lf_integralimg( Faces(faceIdx).img );

faceBoxSize    = [(faceBox(3)-faceBox(1)+1) (faceBox(4)-faceBox(2)+1)];
scanWinSizePx  = round( [ilDetector(landIdx).scanWinSize(1)*faceBoxSize(1) ...
                        ilDetector(landIdx).scanWinSize(2)*faceBoxSize(2)] );
        
[score, cpuTime] = lf_lbppyrdetector_score(iImg, faceBox, ...
                      ilDetector(landIdx).baseWinSize, ...
                      scanWinSizePx, ...
                      ilDetector(landIdx).lbpPyrHeight, ...
                      ilDetector(landIdx).W);

                  
% [i,j] = find( score == max(score(:)));
% figure('name', ilDetector(landIdx).landmarkTag);
% faceRgb = repmat(face,[1 1 3]);
% imshow( faceRgb );
% hold on;
% contour( 3*score );
% colorbar;
% plot(j,i,'or','markerfacecolor','r','markersize',8);
                  
%
score1 = -inf*ones(size(iImg));
faceBox1 = faceBox;
faceBox2 = faceBox1 + 20;
plotbox( faceBox1);
plotbox( faceBox2);

[score2, cpuTime1] = lf_lbppyrdetector_update_score(score1,iImg, faceBox1, ...
                      ilDetector(landIdx).baseWinSize, ...
                      scanWinSizePx, ...
                      ilDetector(landIdx).lbpPyrHeight, ...
                      ilDetector(landIdx).W);
                  
[score3, cpuTime2] = lf_lbppyrdetector_update_score(score2,iImg, faceBox1, ...
                      ilDetector(landIdx).baseWinSize, ...
                      scanWinSizePx, ...
                      ilDetector(landIdx).lbpPyrHeight, ...
                      ilDetector(landIdx).W);


[score, cpuTime0] = lf_lbppyrdetector_score(iImg, faceBox1, ...
                      ilDetector(landIdx).baseWinSize, ...
                      scanWinSizePx, ...
                      ilDetector(landIdx).lbpPyrHeight, ...
                      ilDetector(landIdx).W);

                  
sc3 = score3(faceBox1(2):faceBox1(4),faceBox1(1):faceBox1(3));
sum(abs(sc3(:)-score(:)))

