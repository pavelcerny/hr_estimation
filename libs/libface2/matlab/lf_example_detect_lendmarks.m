%% This examples shows using the independent landmark detector to find 
% precise position of landmarks.
%

inImgFile = '../testimg/pussy_riot_gray.png';
img = imread( inImgFile );

%% load independent landmark detector
load('../data/ilDetector.mat');

%%
L = load('../testimg/pussy_riot.landmarks','-ascii');

%%
figure;
imshow( img );
hold on;

%% change ordering of landmarks to conform with ilDetector
perm = [1 7 3 6 2 5 4];
L1 = L(:,perm) + 4*randn(2,7);

%% derive face box from landmarks; normally, it is returned by face detector
d = norm( (L1(:,2)+L1(:,3))/2 - (L1(:,4)+L1(:,5))/2);
C = 0.6*( L1(:,2)+L1(:,3)+L1(:,4)+L1(:,5) ) / 4 + 0.4*(L1(:,5)+L1(:,6))/2 ;
faceBox = round([C(1)-d*1.35 C(2)-d*1.35 C(1)+1.35*d C(2)+1.35*d]);

%% integral image
iImg = lf_integralimg( img );

%% find precise position of landmarks around initial positions L1
for i = 1 : numel(ilDetector)
    
    faceBoxSize   = [(faceBox(3)-faceBox(1)+1) (faceBox(4)-faceBox(2)+1)];
    scanWinSizePx = round( [ilDetector(i).scanWinSize(1)*faceBoxSize(1) ...
                            ilDetector(i).scanWinSize(2)*faceBoxSize(2)] );
                    
    pos = round(L1(:,i));

    a = 1/(faceBox(3)-faceBox(1));
    b = -a*faceBox(1);
    c = 1/(faceBox(4)-faceBox(2));
    d = -c*faceBox(2);

    center = [a*pos(1)+b ; c*pos(2)+d];

    width       = ilDetector(i).searchSpace(3)-ilDetector(i).searchSpace(1);
    height      = ilDetector(i).searchSpace(4)-ilDetector(i).searchSpace(2);
    searchSpace = [center(1) - width/2 ...
                   center(2) - height/2 ...
                   center(1) + width/2 ...
                   center(2) + height/2 ];    
               
    a = faceBox(3)-faceBox(1);
    b = faceBox(1);
    c = faceBox(4)-faceBox(2);
    d = faceBox(2);
    searchSpacePx = round( [a*searchSpace(1)+b ...
                        c*searchSpace(2)+d ...
                        a*searchSpace(3)+b ...
                        c*searchSpace(4)+d] );               

    %% scan all positions
    t0 = cputime;
    [center, bbox, score, feat] = lf_lbppyrdetector( ...
        iImg, ...
        searchSpacePx, ...
        ilDetector(i).baseWinSize, ...
        scanWinSizePx, ...
        ilDetector(i).lbpPyrHeight, ...
        ilDetector(i).W, ...
        []);
    detTime1 = cputime - t0;
    L2(:,i) = center(:);

    %% coarse to fine; start with grid 5x5
    t0 = cputime;
    [center, bbox, score, feat] = lf_lbppyrdetector( ...
        iImg, ...
        searchSpacePx, ...
        ilDetector(i).baseWinSize, ...
        scanWinSizePx, ...
        ilDetector(i).lbpPyrHeight, ...
        ilDetector(i).W, ...
        [],5);
    detTime2 = cputime - t0;
    L3(:,i) = center(:);

    fprintf('\nLandmark: %s\n', ilDetector(i).landmarkTag );
    fprintf('Search space size: %d x %d px\n', searchSpacePx(4)-searchSpacePx(2), ...
    searchSpacePx(3)-searchSpacePx(1));
    fprintf('Scan win size    : %d x %d px\n', scanWinSizePx(1), scanWinSizePx(2));
    fprintf('all posistions: detector time: %f[s]\n', detTime1);
    fprintf('coarse to fine: detector time: %f[s]\n', detTime2);

    
end


plotbox( faceBox);
h1=plot(L1(1,:),L1(2,:),'+b');  
h2=plot(L2(1,:),L2(2,:),'xr');     
h3=plot(L3(1,:),L3(2,:),'sm');     
legend([h1 h2 h3],'initial','precise','coarse-to-fine');

