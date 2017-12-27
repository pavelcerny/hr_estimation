/*=================================================================
 *=================================================================*/

#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <mex.h>
#include <time.h>
#include <errno.h>

#include "libface.h"

using namespace libface;

/*======================================================================
  Main code plus interface to Matlab.
========================================================================*/

void mexFunction( int nlhs, mxArray *plhs[],int nrhs, const mxArray *prhs[] )
{

  if( nrhs != 1 )
    mexErrMsgTxt("Release integral image from memory.\n"
                 "Synopsis:\n"
                 "  lf_integralimg_free( handle  )\n"
                 "\n"
                 "  handle [...] pointer returned by lf_integralimg_create(...).\n");


  // get pointer 
  CImgUint32* iimg;
  double* tmp = mxGetPr( prhs[0]  );
  memcpy( &iimg, tmp, sizeof( &iimg ));

  if( iimg != NULL ) delete iimg;

  return;
}


