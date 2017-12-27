function [img, State] = movie_next_frame( State )
% MOVIE_NEXT_FRAME
%
%  img = movie_next_frame( State, frameNum )
%

if State.curFrame >= State.numFrames
    img = [];
    return;
end

imgFile = [State.imgRoot State.imgName{ State.curFrame }];

img = imread( imgFile );

State.curFrame = State.curFrame + 1;
end