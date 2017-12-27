function [ handler ] = plotRGBsignal( ys_signal,x_time)

handler = figure;
GREEN = [0 .7 0];
hold on;
if nargin <2
   plot(ys_signal(1,:),'r');  
plot(ys_signal(2,:),'Color',GREEN);
plot(ys_signal(3,:),'b'); 
    
else
plot(x_time,ys_signal(1,:),'r');  
plot(x_time,ys_signal(2,:),'Color',GREEN);
plot(x_time,ys_signal(3,:),'b');
 
end
hold off;
 legend('r','g','b');


end

