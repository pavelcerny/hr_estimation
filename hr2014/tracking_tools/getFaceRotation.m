function [ rotation ] = getFaceRotation(I,bb,LandmarkModel  )

if size(I,3)>0
    I=rgb2gray(I);
end

faceImgGray = getNormalizedFrame(I, bb, LandmarkModel.data.options);
landmarksInFbxCoor = detector(faceImgGray, LandmarkModel );

A = landmarksInFbxCoor(1,[6 2 3 7]);
A = [A; 1 1 1 1]';
b = landmarksInFbxCoor(2,[6 2 3 7])';
coeffEyeLineDirect = A\b;
coeffEyeLine = [coeffEyeLineDirect(1) -1 coeffEyeLineDirect(2)];

rotation = atan(-coeffEyeLine(1)/coeffEyeLine(2));
end

