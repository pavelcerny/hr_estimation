function [t] = position_from_detector(K, faceBox, dAngles)
%
%
%  [t] = position_from_detector(K, faceBox, dAngles)
%

%yaw in radians
yaw = dAngles(3)*pi/180;

%eye-distance of the 3D model = 1
coeff = 2.7; %eye-distance to faceBoxSize ratio
faceBoxSize = faceBox(3)-faceBox(1); %square face

Ll = 1 / (faceBoxSize/coeff); %world length to image length ratio

x = faceBox(1) + faceBoxSize/2 + 0.2*faceBoxSize*sin(yaw);
y = faceBox(2) + faceBoxSize/2 + 0.05*faceBoxSize*sin(abs(yaw));

tx = Ll * (x-K(1,3));
ty = Ll * (y-K(2,3));
tz = Ll * K(1,1)*0.95;

t = [tx; ty; tz];

