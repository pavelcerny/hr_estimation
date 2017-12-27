function [ hs_displayfit ] = displayEstFit( curve, sinusoid, timestamps, hs_displayfit, videodimms)
% X_SCALE = 25;
% Y_SCALE = 30;
videodimms_x = videodimms(2);
videodimms_y = videodimms(1);

TOP_LEFT = [videodimms_x * 0.47, 10];
WIDTH = videodimms_x* 0.5;
HEIGHT = 80;

MARGIN = 6;




x_normalize = WIDTH/(timestamps(end) - timestamps(1));
y_normalize = HEIGHT/(max(max(sinusoid),max(curve))-min(min(curve),min(sinusoid)));

x_time = (timestamps - timestamps(1)) * x_normalize + TOP_LEFT(1);
y_curve = (curve ) * y_normalize + TOP_LEFT(2) + HEIGHT/2 ;
y_sin =(sinusoid ) * y_normalize + TOP_LEFT(2) + HEIGHT/2;

if ~isempty(hs_displayfit.h_sinusoid)
    delete(hs_displayfit.h_sinusoid);
end
if ~isempty(hs_displayfit.h_curve)
    delete(hs_displayfit.h_curve);
end
if ~isempty(hs_displayfit.h_background)
    delete(hs_displayfit.h_background);
end

hs_displayfit.h_background=...  
        rectangle('Position',[(TOP_LEFT-MARGIN),...
                          WIDTH+2*MARGIN,HEIGHT+2*MARGIN],...
                    'FaceColor','w');
                
                
hs_displayfit.h_curve = line(x_time, y_curve);
hs_displayfit.h_sinusoid = line(x_time,y_sin);


set(hs_displayfit.h_sinusoid,'LineWidth',2,'color','r');
set(hs_displayfit.h_curve,'LineWidth',2,'color','b');

end

