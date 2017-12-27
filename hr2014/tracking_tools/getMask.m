function [ mask ] = getMask( methodAverage, dimmension )
switch methodAverage
        case 'gauss'
            imgWidth = dimmension(2);
            imgHeight = dimmension(1);
            sigmaWidth = [imgWidth,imgHeight].* [0.45 0.45];
            center = ([imgWidth, imgHeight]) / 2;
            mask = getGaussMaskMatrix(imgWidth,imgHeight,sigmaWidth,center);
%         case 'forehead'
%             imgWidth = dimmension(2);
%             imgHeight = dimmension(1);
%             gaussWidthCoeff = 0.45;
%             gaussHeightCoeff = 0.13+0.06;
%             gaussCenter=[0.5 0.15];
%             
%             sigmaWidth = [imgWidth,imgHeight].*[ gaussWidthCoeff,...
%                 gaussHeightCoeff];
%             center = [imgWidth,imgHeight].* gaussCenter;
%             mask = getGaussMaskMatrix(imgWidth,imgHeight,sigmaWidth,center);
%         case 'rightcheek'
%             gaussWidthCoeff = 0.11;
%             gaussHeightCoeff = 0.09;
%             gaussCenter=[0.87 0.7];
%             imgWidth = dimmension(2);
%             imgHeight = dimmension(1);
%             sigmaWidth = [imgWidth,imgHeight].*[ gaussWidthCoeff,...
%                 gaussHeightCoeff];
%             center = [imgWidth,imgHeight].* gaussCenter;
%             mask = getGaussMaskMatrix(imgWidth,imgHeight,sigmaWidth,center);
%         case 'leftcheek'
%             gaussWidthCoeff = 0.11;
%             gaussHeightCoeff = 0.09;
%             gaussCenter=[1-0.87 0.7];
%             imgWidth = dimmension(2);
%             imgHeight = dimmension(1);
%             sigmaWidth = [imgWidth,imgHeight].*[ gaussWidthCoeff,...
%                 gaussHeightCoeff];
%             center = [imgWidth,imgHeight].* gaussCenter;
%             mask = getGaussMaskMatrix(imgWidth,imgHeight,sigmaWidth,center);
%         case 'all'
%             imgWidth = dimmension(2);
%             imgHeight = dimmension(1);
%             gaussWidthCoeff = 0.45;
%             gaussHeightCoeff = 0.13+0.06;
%             gaussCenter=[0.5 0.15];
%             
%             sigmaWidth = [imgWidth,imgHeight].*[ gaussWidthCoeff,...
%                 gaussHeightCoeff];
%             center = [imgWidth,imgHeight].* gaussCenter;
%             mask = getGaussMaskMatrix(imgWidth,imgHeight,sigmaWidth,center);
%             gaussWidthCoeff = 0.11;
%             gaussHeightCoeff = 0.09;%-0.02;
%             gaussCenter=[0.87 0.7];
%             imgWidth = dimmension(2);
%             imgHeight = dimmension(1);
%             sigmaWidth = [imgWidth,imgHeight].*[ gaussWidthCoeff,...
%                 gaussHeightCoeff];
%             center = [imgWidth,imgHeight].* gaussCenter;
%             mask = mask + getGaussMaskMatrix(imgWidth,imgHeight,sigmaWidth,center);
%             
%             gaussWidthCoeff = 0.11;
%             gaussHeightCoeff = 0.09; %-0.02;
%             gaussCenter=[1-0.87 0.7];
%             imgWidth = dimmension(2);
%             imgHeight = dimmension(1);
%             sigmaWidth = [imgWidth,imgHeight].*[ gaussWidthCoeff,...
%                 gaussHeightCoeff];
%             center = [imgWidth,imgHeight].* gaussCenter;
%             mask = mask + getGaussMaskMatrix(imgWidth,imgHeight,sigmaWidth,center);
%             
%         case 'square'
%             imgWidth = dimmension(2);
%             imgHeight = dimmension(1);
%             sigmaWidth = [imgWidth,imgHeight].* [0.45 0.45];
%             center = ([imgWidth, imgHeight] + 1) / 2;
%             mask = getGaussMaskMatrix(imgWidth,imgHeight,sigmaWidth,center);
%             
%             
        otherwise
            error('method %s is not implemented',method);
end

mask = mask/sum(mask(:));
end

