function faceBox = face_box_frontal_v1(leftEye,rightEye, mouth)
% FACE_BOX_FRONTAL_V2
% 
% Synopsis:
%    faceBox = face_box_frontal_v1(leftEye,rightEye, mouth)
%
%

% facebox size
faceBoxSize = 2.7*norm(leftEye-rightEye);

S = 0.5*(leftEye+rightEye);
C = S*0.6+mouth*0.4;

% construct facebox
faceBox = round([C(1)-faceBoxSize/2 C(2)-faceBoxSize/2  ...
                 C(1)+faceBoxSize/2 C(2)+faceBoxSize/2]);

    
return;
    
    


