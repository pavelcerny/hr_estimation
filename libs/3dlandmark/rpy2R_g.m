function [R] = rpy2R_g(rpy)
%RPY2R_G- rotation matrix from roll,pitch,yaw on faces
%
%  [R] = rpy2R_g(rpy)
%
%    rpy -  roll, pitch, yaw (in radians), for definition see Fig. 4 at
%           [Koestinger, Wolhart, Roth, Bishof; Annotated Facial Landmarks
%           in the Wild: A Large-scale, Real-World Database for Facial
%           Landmark Localization];
%
%    R - rotation matrix
%
% See also: R2rpy_g
%
% Note the order of rotation: R = Ry(yaw) * Rz(pitch) * Rx(roll) !
%

alpha = -pi-rpy(2);
beta = -rpy(3);
gamma = rpy(1);

Rx = [1, 0 ,0; ...
    0, cos(alpha), sin(alpha); ...
    0,-sin(alpha), cos(alpha)];
Ry = [cos(beta), 0,sin(beta); ...
    0     , 1,   0;     ...
    -sin(beta),0,cos(beta)];
Rz = [cos(gamma),-sin(gamma), 0; ...
    sin(gamma), cos(gamma), 0; ...
    0,0,1];


R = Ry * Rx * Rz;
%R = Ry * Rz * Rx;
