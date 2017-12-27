function State = movie_expand( videoFile, nFrames )
% MOVIE_EXPAND Expand movie to files.
% 
%  State = movie_expand( videoFile )
%  State = movie_expand( videoFile,nFrames )
%

    workDir  = pwd;

    RootDir = '/home/noxx/tmp/matMovie';
    
    if videoFile(1) ~= '/', RootDir = [RootDir '/']; end
           
    videoDir = [RootDir videoFile];
    
    if ~exist( videoDir ), 
        
        mkdir( videoDir ); 

        cd( videoDir );

        if nargin == 1
            cmd = ['mplayer -vo png ' videoFile];
        else
            cmd = ['mplayer -vo png -frames ' num2str(nFrames) '  ' videoFile];
        end

        system( cmd );
    end
    
    Dir = dir( videoDir );
    idx = find( ~[Dir.isdir] );
    
    tmp1          = struct2cell( Dir );
    names         = tmp1(1,idx);
    State.imgName = sort( names );
    
    State.curFrame  = 1;
    State.imgRoot   = [videoDir '/']; 
    State.numFrames = numel( State.imgName );
   
    cd( workDir );
return;
