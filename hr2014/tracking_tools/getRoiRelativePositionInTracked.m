function roiPosRelInTracked = getRoiRelativePositionInTracked(cornersRoi, cornersTrckd)
% returns 

middleRoi = getMiddleFromCorners(cornersRoi);
middleTrckd = getMiddleFromCorners(cornersTrckd);

rotRoi = getRotationFromCorners(cornersRoi);
rotTrckd = getRotationFromCorners(cornersTrckd);

wRoi = getWidthFromCorners(cornersRoi);
hRoi = getHeightFromCorners(cornersRoi);

wTrckd = getWidthFromCorners(cornersTrckd);
hTrckd = getHeightFromCorners(cornersTrckd);

deltaMiddle = middleRoi - middleTrckd;
deltaRot = rotRoi - rotTrckd;

dimsRelative = [ wRoi/wTrckd hRoi/hTrckd ];

roiPosRelInTracked = struct('middleRelative',deltaMiddle ./ [wTrckd hTrckd],'deltaRot',deltaRot,...
                            'dimmensionRelative',dimsRelative);

end

