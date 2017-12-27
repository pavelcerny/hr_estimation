% Example: Detect landmarks in frontal faces.
% 


imageFile = '../../testimg/pussy_riot_gray.png';

modelFile = '../../dependencies/LandmarkRS/data/m8_flandmark_model_rs.dat';

% define how to create normalized frame
ExtBBox = struct('vertMargin',0.1,'horizMargin',0.1,...
                 'baseWidth',40,'baseHeight',40);

%%
addpath ../;

% load image and convert to grayscale
I = imread( imageFile );
I = im2uint8(I); if ndims(I) > 2, I = rgb2gray(I); end
figure(1); imshow(I,[]); hold on;

% init landmar detector
LandmarkPtr = lf_landmarkrs_init( modelFile );
        
% detect faces
faceBox = esFacedetector( I );
nFaces  = size( faceBox,2 );
plotbox( faceBox );

figure(2);

% 
for i = 1 : nFaces

    % crop normalized frame
    J = lf_get_nframe( I, faceBox(:,i), ExtBBox );

    % find landmarks in nomr. frame
    [Lf,score] = lf_landmarkrs_find( LandmarkPtr, J );

    % transfomr from NF to image
    L = lf_nframe2img( double(Lf), faceBox(:,i), ExtBBox );

    % display landmarks
    figure(1);
    plot(L(1,:),L(2,:),'+b');
    for j = 1 : size(L,2), 
        text(L(1,j),L(2,j),num2str(j),'fontsize',20,'color','m'); 
    end  
    
    figure(2); 
    subplot(1,nFaces,i);
    subimage(J ); 
    hold on;
    plot(Lf(1,:),Lf(2,:),'+b');
    
end

lf_landmarkrs_free( LandmarkPtr );


