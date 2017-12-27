if exist('cap','var')
    cap.release;
end
if exist('pModuleState','var')
    esFreeEyeScanState(pModuleState,pFnc);
end
clear all; close all; ROTATE = 0;

LIB_PATH = '../libs/'; %% path to libs (folder on Dropbox)

DEFAULT_FPS =15;

VIDEO_FILE = [];
% VIDEO_FILE = [LIB_PATH '3dlandmark/data/Hpg5HaBJ8Ko.avi']; DEFAULT_FPS =30;
% VIDEO_FILE = ['/home/noxx/PavelCerny/video/2012-08-09-CMP/' 'cech_01_cam2.avi' ]; DEFAULT_FPS =15;
% VIDEO_FILE = '/home/noxx/guvcview_video-2.mkv'; DEFAULT_FPS =25;
% VIDEO_FILE = '~/PavelCerny/video/testovaci_videa/01_p1.MOV'; ROTATE = 1; DEFAULT_FPS =30;
% VIDEO_FILE = ['/home/noxx/PavelCerny/video/2014-1-5-Slavia/' 'adam.mp4' ]; DEFAULT_FPS =20;
% VIDEO_FILE = ['/home/noxx/PavelCerny/video/2014-1-5-Slavia-webcam/' 'adam.webm' ]; DEFAULT_FPS =25;


WEBCAM_TYPE = 0; %1; %%%%%% 0 for built in, 1 for USB
NO_FRAMES = Inf; %%%%%%%% number of taken frames, set "Inf" for infinite loop

if isempty(VIDEO_FILE)
    DEFAULT_FPS =10;
end

INCLUDE_UP_TO = 15; % upper limit on the included samples
VIRTUAL_FPS = 40;   % virtual sampling freqency

HIPASS_FRAME_LENGTH = floor(7/15*VIRTUAL_FPS);
ESTIMATE_HR_FRAME_LENGTH = round(8*VIRTUAL_FPS);
ESTIMATE_HR_EVERY_NTH_FRAME = 10;


ALPHA = 0.3;        % estimates smoothing filter coefficient, weight of a new estimate

IMG_ROI_HEIGHT = 80;
IMG_ROI_WIDTH = 80;

KEEP_LAST_N_ESTIMATIONS = 15; % number of columns for the fit-color-graph

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% THE CODE ABOVE SHOULD BE MODIFIED BY USER %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[EyeScanModuleDir,LandmarkModel] = initPaths( LIB_PATH );

%
load([ LIB_PATH '3dlandmark/data/multipie-mean-face.mat'],'X');
meanFace3d = X;
meanFace3dL7 = X ;

load([ LIB_PATH '3dlandmark/data/ilDetector.mat']);
mperm = [5,3,7,6,4,2,1];        %put 2d and 3d landmarks to correspondence
ilDetector = ilDetector(mperm);


%% Init face detector
[pModuleState,pFnc] = esInit(EyeScanModuleDir,'config.ini');

%% Init 2d landmark detector clandmark
if ~exist('LandmarkModel','var')
    load([LIB_PATH 'uricamic-flandmark-5c55724/data/model.mat']);
    LandmarkModel = model;
    LandmarkModel.landmarkUpdateCoef = 0.8;
    clear model;
end

figure;
h1tracker=[]; h_landmarks= []; h3tracker=[];
h0=[];h_infotext=[];h_roi=[];
h_bpm = [];
h_est.fitness=[];
h_est.estimations=[];
h_est.filter =  [];
h_est.hrUpperText = [];
h_est.hrLowerText =  [];
h1_tracker=[];
kalmanObj=[];
hs_displayfit.h_sinusoid = [];
hs_displayfit.h_curve = [];
hs_displayfit.h_background = [];
curve = [-1 1];
sinusoid = [-1 1];
timestamps_ordered = [0 1];



%% initialize HR estimation
HiPassStruct = initHiPassFilter(HIPASS_FRAME_LENGTH);
HrEstStruct = initHrFitnessEstimator(ESTIMATE_HR_FRAME_LENGTH);


hrfitness = zeros(HrEstStruct.hrUpperBound-HrEstStruct.hrLowerBound+1,KEEP_LAST_N_ESTIMATIONS) ;
hrestimated = repmat(HrEstStruct.hrLowerBound,1,KEEP_LAST_N_ESTIMATIONS);
hrfiltered = repmat(HrEstStruct.hrLowerBound,1,KEEP_LAST_N_ESTIMATIONS);

roiOutDimmension = [IMG_ROI_WIDTH IMG_ROI_HEIGHT];
mask = getMask('gauss', roiOutDimmension);

%% initialize video stream
if isempty(VIDEO_FILE)
    cap = cv.VideoCapture(WEBCAM_TYPE);
else
    VideoFileReader = movie_expand( VIDEO_FILE, 2000 );
    warning('fps not detected');
    fps=DEFAULT_FPS;
    
end

%% reset time counters
global Timming;
Timming.filter = 0;
Timming.filterCalls = 0;
Timming.iImg = 0;
Timming.iImgCalls = 0;
Timming.filterInit = 0;
Timming.trackerTime = 0;
Timming.lbfgs = 0;
%
t_total=0;
t_tracker=0;
t_estimation=0;
t_graphic=0;
t_ROI=0;
t_getimg = 0;
t_total0=cputime;
t_tracker0=cputime;
t_estimation0=cputime;
t_graphic0=cputime;
t_ROI0=cputime;
t_getimg0 = 0;
lastframe_timestamp = t_total0;


%% temoporary storage for results - TO BE DELETED
if NO_FRAMES ~= Inf
    measurements = zeros(3,NO_FRAMES);
    hiPassMeasurements = zeros(3,NO_FRAMES);
    projVectors = zeros(3,NO_FRAMES);
    a0s =zeros(1,NO_FRAMES);
    a1s =zeros(1,NO_FRAMES);
end

projVector = [0;0;0];
a0=0;
a1=0;


%% run program
t_0=cputime;
hr=0;
filterHr=0;
frame = 0;
trackerStarted = false;
noIncludedMeasur = 0;
lastMeasurement = [0;0;0];
lastTimestamp = 0;
inserted_more=0;
while frame < NO_FRAMES
    frame = frame + 1;
    
    %% acquire video frame
    t_getimg0 = cputime;
    
    if isempty(VIDEO_FILE)
        videoFrame = cap.read;
        timestamp = cputime-t_0;
        iteration_timestamp = timestamp;
    else
        [videoFrame, VideoFileReader] = movie_next_frame(VideoFileReader);
        if movie_is_done( VideoFileReader); break; end
        if ROTATE; videoFrame = imrotate(videoFrame,270); end
        timestamp=frame/fps;
        iteration_timestamp = cputime;
    end
    processFPS = 1/(iteration_timestamp - lastframe_timestamp);
    lastframe_timestamp = iteration_timestamp;
    
    t_getimg = addRuntime(t_getimg, t_getimg0);
    
    
    %% Do the tracking
    t_tracker0=cputime;
    
    % convert to grayscale
    img = rgb2gray( videoFrame );
    img = im2uint8( img );
    
    % init tracker by face detector
    if ~trackerStarted
        
        [Detections, pDetRes] = esRunDetector( img, pModuleState, pFnc);
        if ~isempty( Detections ) && Detections{1}.Confidence > 30
            
            faceBox = esGetBB(Detections{1});
            esFreeDetResult(pDetRes,pFnc);
            
            % estimate 2d landmarks
            [faceImgGray,enlargedFaceBox] = getNormalizedFrame(img, faceBox, LandmarkModel.data.options);
            L1 = detector(faceImgGray, LandmarkModel );
            L1 = getLndmrksPosFromDetectImg( enlargedFaceBox, L1 );
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
    
    if trackerStarted
        State = fl3d_update( img, State );
        
        if State.score > -40, trackerStarted = false; end
    end
    t_tracker = addRuntime(t_tracker,t_tracker0);
    
    %% Show video frame
    t_graphic0=cputime;
    
    if isempty(h0)
        h0 = imshow( videoFrame,'border','tight' );
        hold on;
    else
        set(h0,'CData',videoFrame);
    end
    
    t_graphic = addRuntime(t_graphic,t_graphic0);
    
    
    if trackerStarted
        %% Estimate HR
        t_ROI0=cputime;
        
        cornersRoi = getFaceAreaCoordsFromLandmarks( [ mean(State.L2d,2) State.L2d] );
        imgROI = getImgSelectionFromCorners(videoFrame,cornersRoi,roiOutDimmension);
        
        
        %convert imgROI to RGB vector
        
        measurement = getRGBVectorFromFaceImage(imgROI,mask);
        
        t_ROI = addRuntime(t_ROI,t_ROI0);
        t_estimation0 = cputime;
        
        
        if frame >1
            [ HiPassStruct,  HrEstStruct, inserted_more] = insertVirtualMeasurements( lastMeasurement,...
                lastTimestamp, measurement, timestamp, HiPassStruct,  HrEstStruct, INCLUDE_UP_TO,...
                VIRTUAL_FPS,inserted_more);
        end
        lastMeasurement = measurement;
        lastTimestamp = timestamp;
        
        [hiPassedMeasurement, HiPassStruct] = hiPassFilter( measurement, HiPassStruct);
        
        if NO_FRAMES ~= Inf
            measurements(:,frame)=measurement;
            hiPassMeasurements(:,frame)=hiPassedMeasurement;
        end
        
        HrEstStruct  = hrFitnessUpdate( hiPassedMeasurement, timestamp, HrEstStruct );
        
        if mod(frame,ESTIMATE_HR_EVERY_NTH_FRAME) ==  0
            [ fitness, HrEstStruct,models ] = hrFitnessEstimate( HrEstStruct );
            [hr, hr_idx] = findHrFromFitness(HrEstStruct,fitness);
            
            timestamps_ordered = getTimesFromHrEstQueue(HrEstStruct);
            measures_ordered = getMeasuresFromHrEstQueue(HrEstStruct);
            
            curve = models.projVector(:,hr_idx)'*measures_ordered;
            sinusoid = sin(models.omega(hr_idx)*timestamps_ordered+models.phi(hr_idx))+models.a0(hr_idx)+models.a1(hr_idx)*timestamps_ordered;
            
            projVector = models.projVector(:,hr_idx);
            a0 = models.a0(hr_idx);
            a1 = models.a1(hr_idx);
            
            
            if isempty(ALPHA)
                % computes the alpha from the quality of the fit, but it is
                % just an experiment
                alpha = max(0,0.9-fitness(hr_idx));fprintf('%.2f\n',fitness(hr_idx)); 
            else
                alpha = ALPHA;
            end
            
            
            if filterHr == 0
                %initialize smoothing filter on the first run
                filterHr = hr;
            else
                %next runs
                filterHr = (1-alpha) * filterHr + alpha * hr;
            end
            %%
            hrfitness = [hrfitness(:,2:end) fitness'];
            hrestimated = [hrestimated(2:end) hr];
            hrfiltered = [hrfiltered(2:end) filterHr];
        end
        
        t_estimation=addRuntime(t_estimation,t_estimation0);
        if NO_FRAMES ~= Inf
            projVectors(:,frame) = projVector;
            a0s(frame) = a0;
            a1s(frame) = a1;
        end
        
        %% Display graphic
        t_graphic0=cputime;
        
        delete(h_infotext);
        h_infotext = text(20,140,sprintf('(%3.0f bpm)\n %3.3f s\n %3.3f fps',filterHr,timestamp,processFPS), 'FontSize',20, 'color', 'y');
        delete(h_bpm);
        h_bpm = text(20,50,sprintf('%3d bpm',hr), 'FontSize',40, 'color', 'y');
        delete(h_roi);
        h_roi = plotcorners(cornersRoi,'y',4);
        [ h_est ] = displayEstimations( hrfitness,hrestimated,hrfiltered,size(videoFrame,1),h_est, HrEstStruct);
        delete(h_landmarks);
        h_landmarks=plot( State.L2d(1,:),State.L2d(2,:),'o','color','b','markersize',8,'markerfacecolor','r');
        hs_displayfit = displayEstFit( curve, sinusoid, timestamps_ordered, hs_displayfit,size(videoFrame));
        
        
        t_graphic = addRuntime(t_graphic,t_graphic0);
        
    end
    
    t_graphic0=cputime;
    drawnow;
    t_graphic = addRuntime(t_graphic,t_graphic0);
    
end

t_total = addRuntime(t_total,t_total0);
t_lost = t_total-t_tracker-t_estimation-t_graphic-t_ROI-t_getimg;

if isempty(VIDEO_FILE)
    cap.release;
    clear cap
end
esFreeEyeScanState(pModuleState,pFnc);
clear pModuleState
clear pFnc

%PLOT PROJECTION VECTORS AND A_0 A_1
% if NO_FRAMES ~= Inf
% % plotRGBsignal(projVectors); title('proj Vectors');
% % figure;plot(a0s); title('a0');
% % figure;plot(a1s); title('a1');
% end

fprintf('total time        =  %-3.2f, fps = %-3.2f\n', t_total,frame/t_total);
fprintf('tracker time      =  %-3.2f, fps = %-3.2f, from total: %-3.2f%%\n', t_tracker ,frame/t_tracker,t_tracker/t_total*100);
fprintf('ROI ->vector time =  %-3.2f, fps = %-3.2f, from total: %-3.2f%%\n', t_ROI ,frame/t_ROI,t_ROI/t_total*100);
fprintf('estimation time   =  %-3.2f, fps = %-3.2f, from total: %-3.2f%%\n', t_estimation, frame/t_estimation, t_estimation/t_total*100);
fprintf('graphic time      =  %-3.2f, fps = %-3.2f, from total: %-3.2f%%\n', t_graphic,frame/t_graphic,t_graphic/t_total*100);
fprintf('get img time      =  %-3.2f, fps = %-3.2f, from total: %-3.2f%%\n', t_getimg,frame/t_getimg,t_getimg/t_total*100);
fprintf('"lost time"       =  %-3.2f               from total: %-3.2f%%\n',t_lost, t_lost/t_total*100);
