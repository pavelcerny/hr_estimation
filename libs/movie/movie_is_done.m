function res = movie_is_done( State )
% MOVIE_IS_DONE
%
%  res = movie_is_done( State )
%

    res = State.curFrame == State.numFrames;

end