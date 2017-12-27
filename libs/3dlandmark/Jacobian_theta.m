function [Jp, x] = Jacobian_theta(p, K, X)
%
%  [Jp] = Jacobian_theta(p, K, X)
%
%	p - (1x6) - roll, pitch, yaw, tx,ty,tz
%   K - camera matrix (3x3)
%   X - (3x7) 3D face model 
%
%  Jp - cell array of Jacobian matrix (2x6) (one per each landmark point)
%       (position of the landmark in the image vs. R,t)
%   x - (2x7) 2D landmark position
%

N = size(X,2); %number of landmark points
Jp = cell(N, 1);

f = K(1,1);
x0 = K(1,3);
y0 = K(2,3);

p1 = p(1);
p2 = p(2);
p3 = p(3);
p4 = p(4);
p5 = p(5);
p6 = p(6);

%Position of landmarks (in the image)

% X1 = X(1,1); X2 = X(2,1); X3 = X(3,1);
% x = [(X3*(f*cos(p2)*sin(p3) - x0*cos(p2)*cos(p3)) + f*p4 + p6*x0 + X1*(f*(cos(p1)*cos(p3) + sin(p1)*sin(p2)*sin(p3)) + x0*(cos(p1)*sin(p3) - cos(p3)*sin(p1)*sin(p2))) - X2*(f*(cos(p3)*sin(p1) - cos(p1)*sin(p2)*sin(p3)) + x0*(sin(p1)*sin(p3) + cos(p1)*cos(p3)*sin(p2))))/(p6 + X1*(cos(p1)*sin(p3) - cos(p3)*sin(p1)*sin(p2)) - X2*(sin(p1)*sin(p3) + cos(p1)*cos(p3)*sin(p2)) - X3*cos(p2)*cos(p3)); ...
%      (f*p5 + X3*(f*sin(p2) - y0*cos(p2)*cos(p3)) + p6*y0 - X2*(y0*(sin(p1)*sin(p3) + cos(p1)*cos(p3)*sin(p2)) + f*cos(p1)*cos(p2)) + X1*(y0*(cos(p1)*sin(p3) - cos(p3)*sin(p1)*sin(p2)) - f*cos(p2)*sin(p1)))/(p6 + X1*(cos(p1)*sin(p3) - cos(p3)*sin(p1)*sin(p2)) - X2*(sin(p1)*sin(p3) + cos(p1)*cos(p3)*sin(p2)) - X3*cos(p2)*cos(p3))];
	 
x = p2e( K*[rpy2R_g(p(1:3)),[p(4);p(5);p(6)]]*e2p(X) );
 
%Jacobian - derivatives according to horizontal and vertical direction
for i=1:N
	X1 = X(1,i); X2 = X(2,i); X3 = X(3,i);

	
	Jx = [
		                                                                                                                                                                                                                                (cos(p1)*(f*(X2*p4*sin(p3) + X2*X3*cos(p2)) - cos(p3)*(X2*f*p6 - X1*f*p4*sin(p2)) + X1*f*p6*sin(p2)*sin(p3)) - sin(p1)*(cos(p3)*(X1*f*p6 + X2*f*p4*sin(p2)) - f*(X1*p4*sin(p3) + X1*X3*cos(p2)) + X2*f*p6*sin(p2)*sin(p3)) + f*sin(p2)*(X1^2 + X2^2))/(X3*cos(p2)*cos(p3) - p6 - X1*cos(p1)*sin(p3) + X2*sin(p1)*sin(p3) + X2*cos(p1)*cos(p3)*sin(p2) + X1*cos(p3)*sin(p1)*sin(p2))^2
                                                                                                                                                                                                                                                                                                             (f*(X1*cos(p1) - X2*sin(p1) + p6*sin(p3))*(X2*cos(p1)*cos(p2) - X3*sin(p2) + X1*cos(p2)*sin(p1)) + f*p4*cos(p3)*(X2*cos(p1)*cos(p2) - X3*sin(p2) + X1*cos(p2)*sin(p1)))/(X3*cos(p2)*cos(p3) - p6 - X1*cos(p1)*sin(p3) + X2*sin(p1)*sin(p3) + X2*cos(p1)*cos(p3)*sin(p2) + X1*cos(p3)*sin(p1)*sin(p2))^2
 -(f*(X1^2*cos(p1)^2 + X3^2*cos(p2)^2 - X2^2*(cos(p1)^2 - 1) + X1^2*(cos(p1)^2 - 1)*(cos(p2)^2 - 1) - X2^2*cos(p1)^2*(cos(p2)^2 - 1) + 2*X2*X3*cos(p1)*cos(p2)*sin(p2)) - sin(p1)*(f*(2*X1*X2*cos(p1) + 2*X1*X2*cos(p1)*(cos(p2)^2 - 1) - 2*X1*X3*cos(p2)*sin(p2)) + f*cos(p3)*(X2*p4 + X1*p6*sin(p2)) + f*sin(p3)*(X2*p6 - X1*p4*sin(p2))) - f*cos(p3)*(X3*p6*cos(p2) - X1*p4*cos(p1) + X2*p6*cos(p1)*sin(p2)) + f*sin(p3)*(X1*p6*cos(p1) + X3*p4*cos(p2) + X2*p4*cos(p1)*sin(p2)))/(X3*cos(p2)*cos(p3) - p6 - X1*cos(p1)*sin(p3) + X2*sin(p1)*sin(p3) + X2*cos(p1)*cos(p3)*sin(p2) + X1*cos(p3)*sin(p1)*sin(p2))^2
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       f/(p6 + X1*(cos(p1)*sin(p3) - cos(p3)*sin(p1)*sin(p2)) - X2*(sin(p1)*sin(p3) + cos(p1)*cos(p3)*sin(p2)) - X3*cos(p2)*cos(p3))
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   0
                                                                                                                                                                                                                                                                                                                                                                       -(f*p4 + sin(p3)*(f*sin(p2)*(X2*cos(p1) + X1*sin(p1)) + X3*f*cos(p2)) + f*cos(p3)*(X1*cos(p1) - X2*sin(p1)))/(X3*cos(p2)*cos(p3) - p6 - X1*cos(p1)*sin(p3) + X2*sin(p1)*sin(p3) + X2*cos(p1)*cos(p3)*sin(p2) + X1*cos(p3)*sin(p1)*sin(p2))^2
  		]';
	
	Jy = [	 
 -(sin(p3)*(f*(X1^2*cos(p1)^2*cos(p2) - X1*p5*sin(p1) + X2^2*cos(p1)^2*cos(p2) + X1^2*cos(p2)*sin(p1)^2 + X2^2*cos(p2)*sin(p1)^2 - X2*p5*cos(p1)) - X3*f*(X2*cos(p1)*sin(p2) + X1*sin(p1)*sin(p2))) - cos(p3)*(f*(X1*p5*cos(p1)*sin(p2) - X2*p5*sin(p1)*sin(p2)) + X3*f*(X1*cos(p1)*cos(p2)^2 + X1*cos(p1)*sin(p2)^2 - X2*cos(p2)^2*sin(p1) - X2*sin(p1)*sin(p2)^2)) + f*p6*(X1*cos(p1)*cos(p2) - X2*cos(p2)*sin(p1)))/(X3*cos(p2)*cos(p3) - p6 - X1*cos(p1)*sin(p3) + X2*sin(p1)*sin(p3) + X2*cos(p1)*cos(p3)*sin(p2) + X1*cos(p3)*sin(p1)*sin(p2))^2
                                          (cos(p2)*(X3*f*p6 + f*cos(p3)*(X1*p5*sin(p1) + X2*p5*cos(p1))) + sin(p2)*(f*(X1*p6*sin(p1) + X2*p6*cos(p1)) + f*sin(p3)*(X1*X2*cos(p1)^2 + X1*X2*(cos(p1)^2 - 1) + X1^2*cos(p1)*sin(p1) - X2^2*cos(p1)*sin(p1)) - X3*f*p5*cos(p3)) - f*cos(p3)*(X2^2*cos(p1)^2 - X1^2*(cos(p1)^2 - 1) + X3^2 + 2*X1*X2*cos(p1)*sin(p1)) + f*cos(p2)*sin(p3)*(X1*X3*cos(p1) - X2*X3*sin(p1)))/(X3*cos(p2)*cos(p3) - p6 - X1*cos(p1)*sin(p3) + X2*sin(p1)*sin(p3) + X2*cos(p1)*cos(p3)*sin(p2) + X1*cos(p3)*sin(p1)*sin(p2))^2
                                                                                                                                                                                                                             -(f*(p5 + X3*sin(p2) - X2*cos(p1)*cos(p2) - X1*cos(p2)*sin(p1))*(X1*cos(p1)*cos(p3) - X2*cos(p3)*sin(p1) + X3*cos(p2)*sin(p3) + X2*cos(p1)*sin(p2)*sin(p3) + X1*sin(p1)*sin(p2)*sin(p3)))/(X3*cos(p2)*cos(p3) - p6 - X1*cos(p1)*sin(p3) + X2*sin(p1)*sin(p3) + X2*cos(p1)*cos(p3)*sin(p2) + X1*cos(p3)*sin(p1)*sin(p2))^2
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     0
                                                                                                                                                                                                                                                                                                                                                                                                                      f/(p6 + X1*(cos(p1)*sin(p3) - cos(p3)*sin(p1)*sin(p2)) - X2*(sin(p1)*sin(p3) + cos(p1)*cos(p3)*sin(p2)) - X3*cos(p2)*cos(p3))
                                                                                                                                                                                                                                                                                                                                                        -(f*(p5 + X3*sin(p2)) - f*cos(p2)*(X2*cos(p1) + X1*sin(p1)))/(X3*cos(p2)*cos(p3) - p6 - X1*cos(p1)*sin(p3) + X2*sin(p1)*sin(p3) + X2*cos(p1)*cos(p3)*sin(p2) + X1*cos(p3)*sin(p1)*sin(p2))^2
 		 ]';
	
	Jp{i} = [Jx; Jy];
end

