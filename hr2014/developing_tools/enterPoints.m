function [TL, BR] = enterPoints(img)


%enter points
x=[0 0];
y=[0 0];
h=figure;
imshow(img,'Border','tight');
grid on;
hold on;

h1 = text(30,30,sprintf('1) enter Top Left position of ROI\n'), 'FontSize',20, 'color', 'y');
        

[x(1),y(1)] = ginput(1);
plot(x,y,'b+');
delete(h1);

h1 = text(30,30,sprintf('1) enter Bottom Right position of ROI\n'), 'FontSize',20, 'color', 'y');
[x(2),y(2)] = ginput(1);
plot(x,y,'b+');
delete(h1);

plot(x,y,'y+');
pause(0.15);
plot(x,y,'b+');
pause(0.3);

TL = [x(1); y(1)];
BR = [x(2); y(2)];
cornersRoi = [TL [BR(1); TL(2)] BR [TL(1); BR(2)]];

h1=plotcorners(cornersRoi,'y');
pause(0.3)
close(h);

TL = [x(1); y(1)];
BR = [x(2); y(2)];
end