function [rpy] = R2rpy_g(R)
%R2RPY_G- rotation matrix from roll,pitch,yaw on faces
%
%  [rpy] = R2rpy_g(R)
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
% Note: the order of rotation: R = Ry(yaw) * Rz(pitch) * Rx(roll) !
%       pitch assumed in range (-pi/2, +pi/2)
%

% alpha = sym('alpha');
% beta = sym('beta');
% gamma = sym('gamma');
% 
% Rx = [1, 0 ,0; ...
%     0, cos(alpha), sin(alpha); ...
%     0,-sin(alpha), cos(alpha)];
% Ry = [cos(beta), 0,sin(beta); ...
%     0     , 1,   0;     ...
%     -sin(beta),0,cos(beta)];
% Rz = [cos(gamma),-sin(gamma), 0; ...
%     sin(gamma), cos(gamma), 0; ...
%     0,0,1];
% 
% RR = Ry * Rx * Rz;


a = -(asin(R(2,3))+pi); %range <-3*pi/2, -pi/2> (z-axis inverted)
c = atan2(R(2,1)/cos(a), R(2,2)/cos(a));
b = atan2(R(1,3)/cos(a), R(3,3)/cos(a));

rpy = [c, -(a+pi), -b];