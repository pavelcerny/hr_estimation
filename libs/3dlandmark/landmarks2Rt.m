function [R,t] = landmarks2Rt(L, X, K, ransac, bundel_adjustment)
%LANDMARKS2RT - head pose from detected landmarks
%
%  [R,t] = landmarks2Rt(L, X, K, ransac, bundel_adjustment)
%
%       L - landmarks (2x7) (s0 - landmark skipped)
%       X - model points (3x7)
%       K - camera matrix (3x3)
%       use_ransac - optional switch for Ransac ([true]/false)
%       bundel_adjustment - optional switch for b.a. ([true]/false)
%
%       R,t - head pose: rotation matrix (3x3), translation vector (3x1)
%
%       ( 3D points w.r.t. camera frame X' = [R,t; 0 0 0 1]*X
%         new camera projection matrix P' = K*[R,t];          )
%

objectP =  vect2cells(X);
imageP = vect2cells(L);

if nargin==3
    ransac = 1;
    bundel_adjustment = 1;
end

if ransac
  [rvec, tvec] = cv.solvePnPRansac(objectP, imageP, K, zeros(5,1));
else
  [rvec, tvec] = cv.solvePnP(objectP, imageP, K, zeros(5,1));
end

R = cv.Rodrigues(rvec);
t = tvec;
 
if bundel_adjustment
    [R t] = RtXu_ba( R, t, K, X, L ); 
end 
