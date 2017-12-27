%

%testVideo = '/home/xfrancv/Work/Faces/3dlandmark/2014-01-24_landmark3d_pruned/tracker/video/GQRZyNFWF9k.avi';
testVideo = '/home/xfrancv/Work/Faces/3dlandmark/2014-01-24_landmark3d_pruned/tracker/video/Hpg5HaBJ8Ko.avi';

H  = movie_expand( testVideo );

figure;
for frame = 1 : H.numFrames
    
    [img, H] = movie_next_frame( H);
    
    if frame == 1
        h = imshow( img );
    else
        set(h,'cdata',img);
    end
    
    drawnow;
    pause(0.01);
    
end