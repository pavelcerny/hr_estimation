function [ corners ,rotation ] = getFaceAreaCoordsFromLandmarks( landmarks )



%landmarks on face. left means left on the picture (right on the face)
EyeLL = landmarks(:,6);
EyeLR = landmarks(:,2);
EyeRL = landmarks(:,3);
EyeRR = landmarks(:,7);
MouthL = landmarks(:,4);
MouthR = landmarks(:,5);
FaceC = landmarks(:,1);
Nose = landmarks(:,8);

%% find distinguish lines in face
% compute line going through all four eye landmarks
A = landmarks(1,[6 2 3 7]);
A = [A; 1 1 1 1]';
b = landmarks(2,[6 2 3 7])';

coeffEyeLineDirect = A\b;
coeffEyeLine = [coeffEyeLineDirect(1) -1 coeffEyeLineDirect(2)];

%lines going through mouth landmarks vertical to eye line
coeffMouthL = vertical(coeffEyeLine,MouthL);
coeffMouthR = vertical(coeffEyeLine,MouthR);

%distance from mouth to eyes
intersection_MouthL_Eyes=intersection(coeffEyeLine,coeffMouthL);
intersection_MouthR_Eyes=intersection(coeffEyeLine,coeffMouthR);

tmp=(intersection_MouthL_Eyes-MouthL).^2;
dist_MouthL_Eyes=sqrt(tmp(1)+tmp(2));
tmp=(intersection_MouthR_Eyes-MouthR).^2;
dist_MouthR_Eyes=sqrt(tmp(1)+tmp(2));

distEyesMouth=(dist_MouthL_Eyes+dist_MouthR_Eyes)/2;

%lines going through both outside side of eyes (ROI left and right borders)
coeffEyeL=vertical(coeffEyeLine,EyeLL);
coeffEyeR=vertical(coeffEyeLine,EyeRR);

%center from which should the ROI be computed
centerOfEyes=(EyeLL+EyeLR+EyeRL+EyeRR)/4;
centerOfMouth=(MouthL+MouthR)/2;
centerOfFace=(centerOfEyes+centerOfMouth+FaceC)/3;

coeffCenter=[coeffEyeLine(1) coeffEyeLine(2) -(coeffEyeLine(1)*centerOfFace(1)+coeffEyeLine(2)*centerOfFace(2))];

%line above forehead and line under nose  (ROI up and down borders)
upperHeigthROI=1.3*distEyesMouth;
lowerHeigthROI=0.4*distEyesMouth;


coeffUpper=[coeffCenter(1) coeffCenter(2) coeffCenter(3)-upperHeigthROI];
coeffLower=[coeffCenter(1) coeffCenter(2) coeffCenter(3)+lowerHeigthROI];

%% coordinates of ROI corners
intersection_Upper_EyeL=intersection(coeffUpper,coeffEyeL);
intersection_Upper_EyeR=intersection(coeffUpper,coeffEyeR);
intersection_Lower_EyeL=intersection(coeffLower,coeffEyeL);
intersection_Lower_EyeR=intersection(coeffLower,coeffEyeR);

corners = [intersection_Upper_EyeL intersection_Upper_EyeR ...
     intersection_Lower_EyeR intersection_Lower_EyeL];

rotation = atan(-coeffCenter(1)/coeffCenter(2));
end

function verticalCoefficients = vertical(lineCoefficients, point)
% Return coefficients of general form of the line vertical to given one in
% given point
% vertical([a b c], [x y]) = [ a1 b1 c1 ]

a = lineCoefficients(1);
b = lineCoefficients(2);

verticalCoefficients = [ -b, a, -(-b*point(1)+a*point(2)) ];

end

function intersection = intersection( lineA,lineB )
% Returns coordinates of intersection of two lines in general form 
% intersection(lineA,lineB) = [x,y]

intersection = [lineA(1:2);lineB(1:2)]\-[lineA(3);lineB(3)];

end
