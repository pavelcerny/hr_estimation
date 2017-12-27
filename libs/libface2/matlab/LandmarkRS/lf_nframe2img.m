function outPoints = lf_nframe2img( inPoints, faceBox, Settings )
% LF_NFRAME2IMG map from normalized frame to image.
%
% Synopsis:
%   outPoints = lf_nframe2img( inPoints, faceBox, Settings )
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

    b = (Settings.baseWidth*extFaceBox(1) - extFaceBox(3))/(Settings.baseWidth-1);
    a = extFaceBox(1) - b;

    d = (Settings.baseHeight*extFaceBox(2) - extFaceBox(4))/(Settings.baseHeight-1);
    c = extFaceBox(2) - d;

    outPoints = [inPoints(1,:)*a + b ; inPoints(2,:)*c+d ];

return;
