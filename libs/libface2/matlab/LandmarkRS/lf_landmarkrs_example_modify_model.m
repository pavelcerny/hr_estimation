% Example: Show how to set default scores (=bias of unary potentials)
%  and how to modify weights.
%

clc, clear, close all

imageFile = '../../testimg/pussy_riot_gray.png';

modelFile    = '../../dependencies/LandmarkRS/data/m8_flandmark_model_rs.dat';
modelFileMat = '../../dependencies/LandmarkRS/data/model.mat';

% define how to create normalized frame
ExtBBox = struct('vertMargin',0.1,'horizMargin',0.1,...
                 'baseWidth',40,'baseHeight',40);


%%
load(modelFileMat,'model');
S  = model.data.options.S;
nL = size(S,2); 
nEdges = 7;


%% plot search spaces
figure(1);
axis([1 40 1 40]);
axis ij;
hold on; grid on;
for i = 1 : nL
    plotbox(S(:,i));
    y = 0.5*(S(4,i)+S(2,i));
    x = 0.5*(S(3,i)+S(1,i));
    plot(x,y,'+r');
    text(x,y,num2str(i));
end

%% generate default scores
defaultScore = [];

for i = 1 : nL
   
    % size of the search space
    height = S(4,i) - S(2,i) + 1;
    width  = S(3,i) - S(1,i) + 1;
    
    A = zeros(height, width);
    y = round(0.5*(S(4,i)+S(2,i))-S(2,i) )+1;
    x = round(0.5*(S(3,i)+S(1,i))-S(1,i) )+1;
    A(y,x) = 100; 
    defaultScore = [defaultScore ; A(:)];
    
    fprintf('L=%2d  x=%d, y=%d\n', i, x+S(1,i)-1, y+(S(2,i)-1));
end

%% get weights for unary and pairwise components
W   = [];
cnt = 0;
for i = 1 : nL
    cnt = cnt + 1;
    W{cnt} = model.W(model.data.mapTable(i, 1):model.data.mapTable(i, 2));
end

for i = 1 : nEdges
    cnt = cnt + 1;
    W{cnt} = model.W(model.data.mapTable(i+1, 3):model.data.mapTable(i+1, 4));
end

%% set weights 
weights = [];
for i = 1 : numel( W )
    w = W{i}(:);
    
    % erase edge potentials
    if i > nL, w = 0*w; end   
          %  if i > 8, w = 1e-9*w; end
           % if i ==5 , w = 1e-9*w; end
    weights = [weights; w];
end


%% detect landmarks with default scores set

% load image and convert to grayscale
I = imread( imageFile );
I = im2uint8(I); if ndims(I) > 2, I = rgb2gray(I); end
figure(2); imshow(I,[]); hold on;

% init landmar detector
LandmarkPtr = lf_landmarkrs_init( modelFile );
        
% set default scores
lf_landmarkrs_set_default_score( LandmarkPtr, defaultScore );

% set new weights
lf_landmarkrs_update_weights( LandmarkPtr, weights );


% detect faces
faceBox = esFacedetector( I );
nFaces  = size( faceBox,2 );
plotbox( faceBox );

% 
for i = 1 : nFaces

    % crop normalized frame
    J = lf_get_nframe( I, faceBox(:,i), ExtBBox );

    % find landmarks in nomr. frame
    [Lf,score] = lf_landmarkrs_find( LandmarkPtr, J );

    %
    fprintf('face = %d\n', i);
    for j = 1 : nL
        fprintf('L=%2d, x=%d, y=%d\n', j, Lf(1,j), Lf(2,j));
    end
    
    % transfomr from NF to image
    L = lf_nframe2img( double(Lf), faceBox(:,i), ExtBBox );

    % display landmarks
    figure(2);
    plot(L(1,:),L(2,:),'+b');
    for j = 1 : size(L,2), 
        text(L(1,j),L(2,j),num2str(j),'fontsize',20,'color','m'); 
    end  
    
    figure(3); 
    subplot(1,nFaces,i);
    subimage(J ); 
    hold on;
    plot(Lf(1,:),Lf(2,:),'+b');
    
end

lf_landmarkrs_free( LandmarkPtr );

