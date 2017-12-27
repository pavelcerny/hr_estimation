clear all; close all;

%% 
%videoFile = '/home/xfrancv/Work/Faces/3dlandmark/code/data/GQRZyNFWF9k.avi';
videoFile = '/home/xfrancv/Work/Faces/3dlandmark/code/data/Hpg5HaBJ8Ko.avi';

addpath ../common/;

%
load('../data/multipie-mean-face.mat','X');
meanFace3d = X;
meanFace3dL7 = X ;

%
load('../data/ilDetector.mat');
mperm = [5,3,7,6,4,2,1];        %put 2d and 3d landmarks to correspondence
ilDetector = ilDetector(mperm);

        
%% Init face detector
[pModuleState,pFnc] = esInit;

%% Init 2d landmark detector clandmark
addpath('/home/xfrancv/Work/Faces/clandmark/clandmark_2014_01_24/mex/');
Flandmark = flandmark_class('/home/xfrancv/Work/Faces/clandmark/clandmark_2014_01_24/data/8Lfrontal_LFW_SPLIT_1.xml');


%%
global Timming;
Timming.filter = 0;
Timming.filterCalls = 0;
Timming.iImg = 0;
Timming.iImgCalls = 0;
Timming.filterInit = 0;
Timming.trackerTime = 0;
Timming.lbfgs = 0;


%%
VideoFileReader = movie_expand( videoFile, 2000 );


figure;
h0 = []; h1=[]; h2= []; h3=[]; h4=[];
frame = 0;
t0 = cputime;
trackerStarted = false;
while 1 % frame < 500
    
    
    frame = frame + 1;

    % get frame
    [videoFrame, VideoFileReader] = movie_next_frame(VideoFileReader);
    if movie_is_done( VideoFileReader); break; end
    
    % convert to grayscale
    img = rgb2gray( videoFrame );
    img = im2uint8( img );
    
    
    % init tracker by face detector
    if ~trackerStarted
        
        [Detections, pDetRes] = esRunDetector( img, pModuleState, pFnc);
        if ~isempty( Detections ) && Detections{1}.Confidence > 30
        
            faceBoxes = esGetFaceBoxes( Detections );
            faceBox   = faceBoxes(:,1);

            % estimate 2d landmarks
            L1 = Flandmark.detect(img, int32(faceBox));
            L1 = L1(:,2:end);
            
            % find initial R and t
            imSize      = size( img );
            focalLength = max( imSize);
            K           = eye( 3 );
            K(1,3)      = imSize(2)/2; %center of projection
            K(2,3)      = imSize(1)/2;
            K(1,1)      = focalLength;
            K(2,2)      = focalLength;
            [R0,t0]     = landmarks2Rt( L1, meanFace3dL7, K, 1, 0);
                        
            %
            State = fl3d_init( imSize, meanFace3d, ilDetector, R0, t0 );
            
            % 
            trackerStarted = true;
        end
    end

    %
    if trackerStarted 
        State = fl3d_update( img, State ); 
        
        if State.score > -40, trackerStarted = false; end
    end        
    
    % show results
    if isempty(h0)
        h0 = imshow( videoFrame );
        hold on;
    else
        set(h0,'CData',videoFrame);
    end
    if ~isempty(h1), delete( h1 ); h1=[]; end
    if ~isempty(h2), delete( h2 ); h2=[]; end
    if ~isempty(h3), delete( h3 ); h3 =[]; end
    
    if trackerStarted
        msg=[];
        msg{1} = sprintf('score=%.1f (%.1f-%.1f)',...
            State.score,min(State.scorePerLandmark),max(State.scorePerLandmark));
        msg{2} = sprintf('RPY=%4.1f/%4.1f/%4.1f',...
            180*State.theta(1)/pi,180*State.theta(2)/pi,180*State.theta(3)/pi );
        msg{3} = sprintf('XYZ=%.1f/%.1f/%.1f',State.theta(4),State.theta(5),State.theta(6) );
        msg{4} = sprintf('fbs=%dx%d', State.faceBoxSize(1), State.faceBoxSize(2) );
        h1=show_head_box( State.P, msg,'g','linewidth',2);
        
        h2=plot( State.L2d(1,:),State.L2d(2,:),'o','color','b','markersize',8,'markerfacecolor','g');
        for j=1:size(State.L2d,2)
            h3(j) = text( State.L2d(1,j),State.L2d(2,j), num2str(j));
            set(h3,'fontsize',20,'color','m');
        end
    end
    drawnow;   
end
runTime = cputime - t0;

%%
fprintf('Total time spent in tracker: %f[s]\n', Timming.trackerTime );
fprintf('Tracker time per frame     : %f[s] => fps=%f\n', Timming.trackerTime/frame, frame/Timming.trackerTime );
fprintf('Total runtime              : %f[s]\n', runTime );
fprintf('Per frame                  : %f[s] => fps=%f\n', runTime/frame, frame/runTime);
fprintf('Detailed tracker time statistics:\n');
disp(Timming);
