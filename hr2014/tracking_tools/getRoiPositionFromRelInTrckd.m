function cornersRoi = getRoiPositionFromRelInTrckd(roiPosRelInTracked, cornersTrckd)

middleTrckd = getMiddleFromCorners(cornersTrckd);
rotTrckd = getRotationFromCorners(cornersTrckd);
wTrckd = getWidthFromCorners(cornersTrckd);
hTrckd = getHeightFromCorners(cornersTrckd);
dimsTrckd = [wTrckd hTrckd];


middle = roiPosRelInTracked.middleRelative .* dimsTrckd + middleTrckd;
rot = roiPosRelInTracked.deltaRot + rotTrckd;
dims = roiPosRelInTracked.dimmensionRelative .* dimsTrckd;

cornersRoi = getCornersFromP([middle dims rot]);

end