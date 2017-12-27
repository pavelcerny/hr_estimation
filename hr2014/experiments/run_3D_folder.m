if exist('pModuleState','var'), esFreeEyeScanState(pModuleState,pFnc); end
if exist('videoObj','var'), delete(videoObj); clear videoObj; end
clear all; close all;
LIB_PATH = '../libs/'; %% path to libs (folder on Dropbox)
DataBases = {'2012-08-09-CMP-cam1', '2012-08-09-CMP-cam2', '2014-Plesek','2014-1-5-Slavia','2014-1-5-Slavia-webcam','CMP-near','CMP-far','CMP-talking'};
%                     1                 2                       3                   4                   5                   6           7       8

Formats = {'avi','MOV','mp4','webm'};

DATABASE = DataBases{1};
VIDEO_FPS = 15;
MAX_FRAMES = VIDEO_FPS*15;

REMOVE_EVERY_NTH_FRAME = 0;
if REMOVE_EVERY_NTH_FRAME > 0
    newFPS = VIDEO_FPS - (VIDEO_FPS/REMOVE_EVERY_NTH_FRAME);
else
    newFPS = VIDEO_FPS;
end
INCLUDE_UP_TO = 15;
VIRTUAL_FPS = 40;
HIPASS_FRAME_LENGTH = floor(7/15*VIRTUAL_FPS); %def 15
LENGTH_HR = 8;
ESTIMATE_HR_FRAME_LENGTH = round(LENGTH_HR*VIRTUAL_FPS); %def 60
ESTIMATE_HR_EVERY_NTH_FRAME = 10; %def 15

ESTIMATE_AFTER_FRAME = LENGTH_HR * newFPS; %ESTIMATE_HR_FRAME_LENGTH;

ALPHA = 0.3;

IMG_ROI_HEIGHT = 80;
IMG_ROI_WIDTH = 80;

KEEP_LAST_N_ESTIMATIONS = 15;
WITHOUT_BLUE = 0;

TAKE_FRAME_1 = 19*newFPS;
TAKE_FRAME_2 = 27*newFPS;

SCREENS = ['screens' num2str(newFPS)];
OUTPUT = ['../../statistics2/' DATABASE '/'];
if ~exist(OUTPUT,'dir')
    mkdir(OUTPUT);
end

if ~exist([OUTPUT SCREENS],'dir')
    mkdir(OUTPUT,SCREENS)
end
CSV = [int2str(newFPS) 'stat.csv'];


folder = ['../../video/' DATABASE '/' int2str(VIDEO_FPS) 'fps/'];

fid = fopen([OUTPUT CSV],'a');
fprintf(fid,'%s, %s, %.2f fps, HIPASS_FRAME_LENGTH %d,ESTIMATE_HR_FRAME_LENGTH %d, WITHOUT_BLUE %d, alpha %.2f\n',...
    datestr(now),DATABASE,newFPS,HIPASS_FRAME_LENGTH, ESTIMATE_HR_FRAME_LENGTH,WITHOUT_BLUE,ALPHA);
fclose(fid);

%% TESTS
ROTATE = 0;
if strcmp(DATABASE,'2014-Plesek'), ROTATE = 1; end
videos = getVideoFilesInfos(folder,Formats);


%% load libs
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

total_frames = 0;
t_total =0;

for v = 1: min(numel(videos),Inf)
    video = videos(v).name;
    fprintf('using: %s\n',video);
    
    videoObj = VideoReader([folder video]);
    nFrames = videoObj.NumberOfFrames;
    if nFrames == 0
        delete(videoObj)
        videoObj = VideoReader([folder video]);
        nFrames = videoObj.NumberOfFrames;
    end
    fprintf('------%d\n',nFrames);
    
    no_frames= min(nFrames,MAX_FRAMES);
    
    %%
    h_figure = figure;
    h1tracker=[]; h_landmarks= []; h3tracker=[];
h0=[];h_infotext=[];h_roi=[];
h_bpm = [];
h_est.fitness=[];
h_est.estimations=[];
h_est.filter =  [];
h_est.hrUpperText = [];
h_est.hrLowerText =  [];
    h1_tracker=[];
    hs_displayfit.h_sinusoid = [];
    hs_displayfit.h_curve = [];
    hs_displayfit.h_background = [];
    curve = [0 0];
    sinusoid = [0 0];
    timestamps_ordered = [0 0];
    
    % initialize HR estimation
    HiPassStruct = initHiPassFilter(HIPASS_FRAME_LENGTH);
    HrEstStruct = initHrFitnessEstimator(ESTIMATE_HR_FRAME_LENGTH);
    
    hrfitness = zeros(HrEstStruct.hrUpperBound-HrEstStruct.hrLowerBound+1,KEEP_LAST_N_ESTIMATIONS) ;
    hrestimated = repmat(HrEstStruct.hrLowerBound,1,KEEP_LAST_N_ESTIMATIONS);
    hrfiltered = repmat(HrEstStruct.hrLowerBound,1,KEEP_LAST_N_ESTIMATIONS);
    
    roiOutDimmension = [IMG_ROI_WIDTH IMG_ROI_HEIGHT];
    mask = getMask('gauss', roiOutDimmension);
    
    % reset time counters
    global Timming;
    Timming.filter = 0;
    Timming.filterCalls = 0;
    Timming.iImg = 0;
    Timming.iImgCalls = 0;
    Timming.filterInit = 0;
    Timming.trackerTime = 0;
    Timming.lbfgs = 0;
    %
    t_subtotal=0;
    t_tracker=0;
    t_estimation=0;
    t_graphic=0;
    t_ROI=0;
    t_getimg = 0;
    t_subtotal0=cputime;
    t_tracker0=cputime;
    t_estimation0=cputime;
    t_graphic0=cputime;
    t_ROI0=cputime;
    t_getimg0 = 0;
    lastframe_timestamp = t_subtotal0;
    
    % temoporary storage for results
    array_length = no_frames/VIDEO_FPS*newFPS;
    measurements = zeros(3,array_length);
    hiPassMeasurements = zeros(3,array_length);
    projVectors = zeros(3,array_length);
    a0s =zeros(1,array_length);
    a1s =zeros(1,array_length);
    projVector = [0;0;0];
    a0=0;
    a1=0;
    estimations = zeros(1,array_length);
    estimationsFilter = zeros(1,array_length);
    
    % run program
    t_0=cputime;
    hr=0;
    filterHr=0;
    frame = 0;
    trackerStarted = false;
    noIncludedMeasur = 0;
    lastMeasurement = [0;0;0];
    lastTimestamp = 0;
    inserted_more=0;
    frame_idx = 0;
    realFrameInVideo = 0;
    take_screen1 = 1;
    take_screen2 = 1;
    
    counter = 0;
    
    while realFrameInVideo < no_frames
        realFrameInVideo = realFrameInVideo + 1;
        if mod(realFrameInVideo,REMOVE_EVERY_NTH_FRAME) ==  0
            continue;
        end
        frame_idx = frame_idx + 1;
        
        screen = 0;
        if frame_idx > TAKE_FRAME_1 && take_screen1
            screen = 1;            
        end
         if frame_idx > TAKE_FRAME_2 && take_screen2
            screen = 1;            
        end
        
        %% acquire video frame
        t_getimg0 = cputime;
        videoFrame = read(videoObj,realFrameInVideo);
        if ROTATE; videoFrame = imrotate(videoFrame,270); end
        timestamp =realFrameInVideo/VIDEO_FPS;
        iteration_timestamp = cputime;
        processFPS = 1/(iteration_timestamp - lastframe_timestamp);
        lastframe_timestamp = iteration_timestamp;
        
        t_getimg = addRuntime(t_getimg, t_getimg0);
        
        %% STRT
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
        if screen
            if isempty(h0)
                h0 = imshow( videoFrame,'border','tight' );
                hold on;
            else
                set(h0,'CData',videoFrame);
            end
        end
        t_graphic = addRuntime(t_graphic,t_graphic0);
        
        
        if trackerStarted
            %% Estimate HR
            t_ROI0=cputime;
            
            cornersRoi = getFaceAreaCoordsFromLandmarks( [ mean(State.L2d,2) State.L2d] );
            imgROI = getImgSelectionFromCorners(videoFrame,cornersRoi,roiOutDimmension);
            
            
            %convert imgROI to RGB vector
            measurement = getRGBVectorFromFaceImage(imgROI,mask);
            
            if WITHOUT_BLUE
                %             measurement(1)=0; % r
                %            measurement(2)=0; % g
                measurement(3)=0; % b
            end
            
            t_ROI = addRuntime(t_ROI,t_ROI0);
            t_estimation0 = cputime;

            if frame_idx >1
                [ HiPassStruct,  HrEstStruct, inserted_more] = insertVirtualMeasurements( lastMeasurement,...
                    lastTimestamp, measurement, timestamp, HiPassStruct,  HrEstStruct, INCLUDE_UP_TO,...
                    VIRTUAL_FPS,inserted_more);
            end
            lastMeasurement = measurement;
            lastTimestamp = timestamp;
            
            [hiPassedMeasurement, HiPassStruct] = hiPassFilter( measurement, HiPassStruct);
            
            measurements(:,frame_idx)=measurement;
            hiPassMeasurements(:,frame_idx)=hiPassedMeasurement;
            
            HrEstStruct  = hrFitnessUpdate( hiPassedMeasurement, timestamp, HrEstStruct );
            
            if mod(frame_idx,ESTIMATE_HR_EVERY_NTH_FRAME) ==  0 && frame_idx >= ESTIMATE_AFTER_FRAME
                [ fitness, HrEstStruct,models ] = hrFitnessEstimate( HrEstStruct );
                [hr, hr_idx] = findHrFromFitness(HrEstStruct,fitness);
                
                timestamps_ordered = getTimesFromHrEstQueue(HrEstStruct);
                measures_ordered = getMeasuresFromHrEstQueue(HrEstStruct);
                
                curve = models.projVector(:,hr_idx)'*measures_ordered;
                sinusoid = sin(models.omega(hr_idx)*timestamps_ordered+models.phi(hr_idx))+models.a0(hr_idx)+models.a1(hr_idx)*timestamps_ordered;
                
                projVector = models.projVector(:,hr_idx);
                a0 = models.a0(hr_idx);
                a1 = models.a1(hr_idx);
                % if frame > 90
                %             h_f = figure;
                %             plot(timestamps_ordered, curve);
                %             hold on;
                %             plot(timestamps_ordered, sinusoid,'r');
                %             hold off;
                %             close(h_f);
                % end
                %%
                
                if isempty(ALPHA)
                    alpha = max(0,0.9-fitness(hr_idx));fprintf('%.2f\n',fitness(hr_idx));
                    %             alpha = likelyhood(hr_idx); fprintf('%.2f\n',likelyhood(hr_idx));
                else
                    alpha = ALPHA;
                end
                
                
                if filterHr == 0
                    filterHr = hr;
                else
                    filterHr = (1-alpha) * filterHr + alpha * hr;
                end
                %%
                %             fprintf('%d: %d bpm (%.0f) bpm\n', frame, hr,filterHr);
                hrfitness = [hrfitness(:,2:end) fitness'];
                hrestimated = [hrestimated(2:end) hr];
                hrfiltered = [hrfiltered(2:end) filterHr];
                counter= counter +1;
%                 if counter == 5
%                     5
%                 end
            end
            
            t_estimation=addRuntime(t_estimation,t_estimation0);
            projVectors(:,frame_idx) = projVector;
            a0s(frame_idx) = a0;
            a1s(frame_idx) = a1;
            estimations(frame_idx)=hr;
            estimationsFilter(frame_idx)=filterHr;
            
            %% Display graphic
            t_graphic0=cputime;
            if screen
                
                
                delete(h_infotext);
                h_infotext = text(20,140,sprintf('(%3.0f bpm)\n %3.3f s\n %3.3f fps',hr,filterHr,timestamp,processFPS), 'FontSize',20, 'color', 'y');
                delete(h_bpm);
                h_bpm = text(20,50,sprintf('%3d bpm',hr), 'FontSize',40, 'color', 'y');
                
                delete(h_roi);
                h_roi = plotcorners(cornersRoi,'y',4);
                %         [ h3,h4, h5 ] = displayEstimations( hrfitness,hrestimated,hrfilter,videoHeight,lowestHR, h3,h4,h5)
        [ h_est ] = displayEstimations( hrfitness,hrestimated,hrfiltered,size(videoFrame,1),h_est, HrEstStruct);
                delete(h_landmarks);
                h_landmarks=plot( State.L2d(1,:),State.L2d(2,:),'o','color','b','markersize',8,'markerfacecolor','r');
                hs_displayfit = displayEstFit( curve, sinusoid, timestamps_ordered, hs_displayfit,size(videoFrame));
                
            end
            t_graphic = addRuntime(t_graphic,t_graphic0);
            
        end
        
        t_graphic0=cputime;
        if screen
            drawnow;
            if take_screen1
                saveas(h_figure,[OUTPUT SCREENS '/' video '_scr_01.png']);
                take_screen1=0;
            else
                saveas(h_figure,[OUTPUT SCREENS '/' video '_scr_02.png']);
                take_screen2=0;
            end
        end
        t_graphic = addRuntime(t_graphic,t_graphic0);
        %% END
    end
    
    annotated = readHRAnnotation1s(folder,video);
    annotated = annotated';
    est = getEstForSecFromFrame(estimations,newFPS);
    estFilter = getEstForSecFromFrame(estimationsFilter,newFPS);
    %     fprintf('ann: ');
    %     fprintf('%.2f ',annotated); fprintf('\n');
    %     fprintf('est: ');
    %     fprintf('%.2f ',est); fprintf('\n');
    %     fprintf('fil: ');
    %     fprintf('%.2f ',estFilter); fprintf('\n');
    
    from = ESTIMATE_AFTER_FRAME/newFPS+2;
    
    fprintf('ann: ');
    fprintf('%.2f ',annotated(from:end)); fprintf('\n');
    fprintf('est: ');
    fprintf('%.2f ',est(from:end)); fprintf('\n');
    fprintf('fil: ');
    fprintf('%.2f ',estFilter(from:end)); fprintf('\n');
    
    fid = fopen([OUTPUT CSV],'a');
    fprintf(fid,'ann, %s, ',video);
    fprintf(fid,'%.2f, ',annotated(from:end)); fprintf(fid,'\n');
    fprintf(fid,'est, %s, ',video);
    fprintf(fid,'%.2f, ',est(from:end)); fprintf(fid,'\n');
    fprintf(fid,'fil, %s, ',video);
    fprintf(fid,'%.2f, ',estFilter(from:end)); fprintf(fid,'\n');
    
    difEndEst = min(numel(annotated),numel(est));
    difEndFilter = min(numel(annotated),numel(estFilter));
    
    difEst = abs(annotated(from:difEndEst) - est(from:difEndEst));
    fprintf(fid,'difEst, %s, ',video);
    fprintf(fid,'%.2f, ',difEst); fprintf(fid,'\n');
    
    difFilter = abs(annotated(from:difEndFilter)-estFilter(from:difEndFilter));
    fprintf(fid,'difFil, %s, ',video);
    fprintf(fid,'%.2f, ',difFilter); fprintf(fid,'\n');
    
    fprintf(fid,'median difEst, %s, ',video);
    fprintf(fid,'%.2f, ',median(difEst)); fprintf(fid,'\n');
    
    fprintf(fid,'median difFil, %s, ',video);
    fprintf(fid,'%.2f, ',median(difFilter)); fprintf(fid,'\n');
    
    fprintf(fid,'std difEst, %s, ',video);
    fprintf(fid,'%.2f, ',std(difEst)); fprintf(fid,'\n');
    
    fprintf(fid,'std difFil, %s, ',video);
    fprintf(fid,'%.2f, ',std(difFilter)); fprintf(fid,'\n');
    
    fclose(fid);
    
    
    close(h_figure);
    delete(videoObj); clear videoObj;
    
    t_subtotal = addRuntime(t_subtotal,t_subtotal0);
    t_lost = t_subtotal-t_tracker-t_estimation-t_graphic-t_ROI-t_getimg;
    
    total_frames = total_frames + frame_idx;
    t_total = t_total + t_subtotal;
    
    for i=1:size(projVectors,2)
        if projVectors(2,i) < 0
            projVectors(:,i) = projVectors(:,i)*-1;
        end
    end
    %     h_figure = plotRGBsignal(projVectors); title('proj Vectors');
    %     drawnow;
    %     saveas(h_figure,[OUTPUT SCREENS '/' video '_projVect.png'],'png');
    %
    %     plot(a0s);
    %     title('a0');
    %     drawnow;
    %     saveas(h_figure,[OUTPUT SCREENS '/' video '_a0.png'],'png');
    %     plot(a1s);
    %     title('a1');
    %     drawnow;
    %     saveas(h_figure,[OUTPUT SCREENS '/' video '_a1.png'],'png');
    %     close(h_figure);
    
    
    fprintf('total time        =  %-3.2f, fps = %-3.2f\n', t_subtotal,frame_idx/t_subtotal);
    fprintf('tracker time      =  %-3.2f, fps = %-3.2f, from total: %-3.2f%%\n', t_tracker ,frame_idx/t_tracker,t_tracker/t_subtotal*100);
    fprintf('ROI ->vector time =  %-3.2f, fps = %-3.2f, from total: %-3.2f%%\n', t_ROI ,frame_idx/t_ROI,t_ROI/t_subtotal*100);
    fprintf('estimation time   =  %-3.2f, fps = %-3.2f, from total: %-3.2f%%\n', t_estimation, frame_idx/t_estimation, t_estimation/t_subtotal*100);
    fprintf('graphic time      =  %-3.2f, fps = %-3.2f, from total: %-3.2f%%\n', t_graphic,frame_idx/t_graphic,t_graphic/t_subtotal*100);
    fprintf('get img time      =  %-3.2f, fps = %-3.2f, from total: %-3.2f%%\n', t_getimg,frame_idx/t_getimg,t_getimg/t_subtotal*100);
    fprintf('"lost time"       =  %-3.2f               from total: %-3.2f%%\n',t_lost, t_lost/t_subtotal*100);
    
    
    
    
end

esFreeEyeScanState(pModuleState,pFnc);
clear pModuleState
clear pFnc

fprintf('total total time  =  %-3.2f, fps = %-3.2f\n', t_total,total_frames/t_total);

