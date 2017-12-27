function State = fl3d_update( img, State, faceBox )
% FL3D_UPDATE
%
%  State = fl3d_update( img, State, faceBox )
%
%
    global Timming;

    startTim = cputime;

    
    % init integral image
    t0 = cputime;
    
%    img = histeq( img );
    iImgHandle   = lf_integralimg_create( img  );

    Timming.iImg = Timming.iImg + cputime-t0;
    Timming.iImgCalls = Timming.iImgCalls + 1;
    
    % compute face box from current landmarks
    if nargin < 3
        leftEye  = 0.5*(State.L2d(:,2)+State.L2d(:,6));
        rightEye = 0.5*(State.L2d(:,1)+State.L2d(:,5));
        mouth    = 0.5*(State.L2d(:,3)+State.L2d(:,4));
        faceBox  = face_box_frontal_v1(leftEye,rightEye, mouth) ;
    end
    
    % init LBP filters for each landmark
    nL           = numel( State.LandmarkModel );
    faceBoxSize  = [(faceBox(3)-faceBox(1)+1) (faceBox(4)-faceBox(2)+1)];
    State.filterHandle = [];
    for i = 1 : nL
        scanWinSizePx  = round( [State.LandmarkModel(i).scanWinSize(1)*faceBoxSize(1) ...
                                 State.LandmarkModel(i).scanWinSize(2)*faceBoxSize(2)] );

        t0 = cputime;
        
        State.filterHandle{i} = lf_lbppyrfilter_init( ...
            iImgHandle, ...
            scanWinSizePx, ...
            State.LandmarkModel(i).baseWinSize, ...
            State.LandmarkModel(i).lbpPyrHeight, ...
            State.LandmarkModel(i).W );
        
        Timming.filterInit = Timming.filterInit + cputime - t0;

    end    
                
    % optimize 3D pose
%    Opt = optimset('gradobj', 'on', ...
% 	               'LargeScale', 'off', ...
% 				   'display', 'off');
% 				   'display', 'iter-detailed');
    %[newTheta, score] = fminunc(@(p) fl3d_obj(p, State), State.theta, Opt );
    
    t0 = cputime;

    Opt.verb = 0;
    Opt.eps  = 1e-5;
    Opt.maxIter = 50;
    [newTheta, score] = lbfgs( 'fl3d_obj', State.theta, Opt, State );
    State.score = score;
    State.theta = newTheta; 

    State.faceBoxSize = faceBoxSize;

    [~, ~, State.scorePerLandmark] = fl3d_obj( State.theta, State  );
    
    Timming.lbfgs = Timming.lbfgs + cputime - t0;
        
    % release filters and intefral image from memmory
    for i = 1 : nL
        lf_lbppyrfilter_free( State.filterHandle{i} );
    end
    lf_integralimg_free( iImgHandle );
        
    % compute projection matrix
    State.P = State.K * [rpy2R_g( State.theta(1:3)), State.theta(4:6) ];
    
    % landmarks in 2d
    State.L2d = p2e( State.P * e2p( State.L3d ) );    

    %
    Timming.trackerTime = Timming.trackerTime + cputime - startTim;
end

