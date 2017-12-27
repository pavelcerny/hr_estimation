%

INCLUDES   = '-I../ -I../dependencies/Eyedea/Eyedea/ -I../dependencies/Eyedea/3rd_Party/';
LIBS       = ['../lib/libface-x86_64.a' ...
            ' ../dependencies/Eyedea/Eyedea/libs/libeye-x86_64.a' ...
            ' ../dependencies/Eyedea/3rd_Party/.libs/libmatutls-x86_64.a' ...
            ' ../dependencies/Eyedea/3rd_Party/iniparser3.0b/src/libiniparser.a'];
FLAGS      = '-largeArrayDims -lm -DMATLAB';


OUTPUT_MEX = {'lf_integralimg', 'lf_estimaffinetform', 'lf_affinetform',...
              'lf_affinenormrect','lf_cropanddownscale','lf_lbppyrdetector'};
  
          
          
%%     

for i = 1 : numel( OUTPUT_MEX )
    
    str = ['mex ' FLAGS ' ' INCLUDES ' -O -output ' OUTPUT_MEX{i} ' ' OUTPUT_MEX{i} '_mex.cpp ' LIBS];
    eval( str );

end