function State = fl3d_init( imSize, landmarks3d, LandmarkModel, R0, t0 )
% FL3D_INIT
% 
% State = fl3d_init( imSize, landmarks3d, LandmarkModel, R0, t0 )
%

    State.LandmarkModel = LandmarkModel;

    State.focalLength = max( imSize );
    State.K           = eye( 3 );
    State.K(1,3)      = imSize(2)/2; %center of projection
    State.K(2,3)      = imSize(1)/2;
    State.K(1,1)      = State.focalLength;
    State.K(2,2)      = State.focalLength;
    
    State.L3d    = landmarks3d;
   
%    [R0,t0]     = landmarks2Rt( landmarks2d, landmarks3d, State.K, 0, 0);
    R0          = double( R0 ); 
    t0          = double( t0 );
    rpy         = R2rpy_g( R0 );
    State.theta = [rpy' ; t0];
    
    % projection matrix and 2d landmarks
%    State.P = State.K * [rpy2R_g( State.theta(1:3)), State.theta(4:6) ];
    State.P = State.K * [R0 t0];
    State.L2d = p2e( State.P * e2p( State.L3d ) );    
    
%    State.trackerTime = 0;
end