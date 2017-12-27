function [ LandmarksInOrigImg ] = getLndmrksPosFromDetectImg( enlargedFaceBox, LandmarksInSmallImg )
LandmarksInOrigImg =  LandmarksInSmallImg/40;
LandmarksInOrigImg(1,:) = LandmarksInOrigImg(1,:) * bbWidth(enlargedFaceBox) + enlargedFaceBox(1);
LandmarksInOrigImg(2,:) = LandmarksInOrigImg(2,:) * bbHeight(enlargedFaceBox) + enlargedFaceBox(2);

end

