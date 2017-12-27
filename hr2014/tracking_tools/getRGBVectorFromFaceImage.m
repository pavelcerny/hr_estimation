function [ rgbVector] = getRGBVectorFromFaceImage( imgROI,mask,sumMask)
% Converts RGB image to RGB vector
img = double(imgROI);

if nargin <3
rgbVector = [ sum(sum(img(:,:,1).*mask));
    sum(sum(img(:,:,2).*mask));
    sum(sum(img(:,:,3).*mask))  ]; 
else
    warning('a not-precomputed mask is used')
    rgbVector = [ sum(sum(img(:,:,1).*mask));
    sum(sum(img(:,:,2).*mask));
    sum(sum(img(:,:,3).*mask))  ]/sumMask;
end

% imgROI2=uint8(round(mask.*double(rgb2gray(uint8(imgROI)))));
% imshow(imgROI2);

end

