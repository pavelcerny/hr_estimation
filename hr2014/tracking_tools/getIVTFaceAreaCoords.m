function [ p ] = getIVTFaceAreaCoords( I,bb,LandmarkModel )

if(size (I,3) ~= 1)
    I=rgb2gray(I);
end

[faceImgGray,enlargedFaceBox] = getNormalizedFrame(I, bb, LandmarkModel.data.options);
landmarksInFbxCoor = detector(faceImgGray, LandmarkModel );

landmarks = getLndmrksPosFromDetectImg( enlargedFaceBox, landmarksInFbxCoor );
[corners, rotation] = getFaceAreaCoordsFromLandmarks( landmarks );

w = getWidthFromCorners(corners);
h = getHeightFromCorners(corners);


p = [mean(corners(1,:)) mean(corners(2,:)) w h rotation];


end
