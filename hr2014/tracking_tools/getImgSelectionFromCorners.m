function [ imgSelection ] = getImgSelectionFromCorners(I,corners,outDimmensions)
if nargin<3
    outDimmensions = [80 80]; % [width height]
end
if size(corners,1) ~= 2 || size(corners,2) ~= 4
    error('dimmension missmatch, Corners must be 2x4 matrix');
end
    
    inPoints=[corners(:,1)'; corners(:,2)'; corners(:,3)'];
    outPoints=[1 1; outDimmensions(1) 1;outDimmensions];
    
%     Tr = maketform('affine', inPoints, outPoints);
%     imgSelection = imtransform(I, Tr, 'bilinear','xdata',[1 outDimmensions(1)],'ydata',[1 outDimmensions(2)],'XYScale',1);

     warpMat = lf_estimaffinetform( inPoints'-1, outPoints'-1 );
 
     imgSelection = zeros(outDimmensions(1), outDimmensions(2),3,'uint8');
     imgSelection(:,:,1) = lf_affinetform( I(:,:,1), warpMat, outDimmensions(1), outDimmensions(2) );
     imgSelection(:,:,2) = lf_affinetform( I(:,:,2), warpMat, outDimmensions(1), outDimmensions(2) );
     imgSelection(:,:,3) = lf_affinetform( I(:,:,3), warpMat, outDimmensions(1), outDimmensions(2) );

end

