function J = lf_get_nframe( I, faceBox, Settings )
% LF_GET_NFRAME compute normalized frame from given faceBox.
%
% Synopsis:
%   J = lf_get_nframe( I, faceBox, Settings )
%
% Settings.vertMargin  [1x1] 
% Settings.horizMargin [1x1]
% Settings.baseWidth   [1x1]
% Settings.baseHeight  [1x1]
% 
% The extended faceBox is 
%
%  extFaceBox = faceBox(:) + [-dx -dy dx dy]'
%
% where dx = round( horizMargin*(faceBox(3)-faceBox(1)+1 ))
%       dy = round( vertMargin* (faceBox(4)-faceBox(2)+1 ))
%

    dx = round( Settings.horizMargin*(faceBox(3)-faceBox(1)+1 ));
    dy = round( Settings.vertMargin* (faceBox(4)-faceBox(2)+1 ));

    extFaceBox = faceBox(:) + [-dx -dy dx dy]';

    extBoxWidth  = extFaceBox(3)-extFaceBox(1)+1;
    extBoxHeight = extFaceBox(4)-extFaceBox(2)+1;

    if extBoxWidth >= Settings.baseWidth && extBoxHeight >= Settings.baseHeight
        J = lf_cropanddownscale( uint8(I), extFaceBox, [Settings.baseWidth Settings.baseHeight]);
    else
        inPoints  = [extFaceBox(1) extFaceBox(2) ; ...
                     extFaceBox(3) extFaceBox(2); ...
                     extFaceBox(3) extFaceBox(4)];
        outPoints = [1 1; Settings.baseWidth 1; Settings.baseWidth Settings.baseHeight ];
        warpMat   = lf_estimaffinetform( inPoints, outPoints );

        J = lf_affinetform( uint8(I), warpMat, Settings.baseHeight, Settings.baseWidth );

    end

return;
