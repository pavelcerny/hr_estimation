/*=================================================================
 * Synopsis:
 *
 *
 *=================================================================*/

#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <mex.h>
#include <time.h>
#include <errno.h>

#include "libface.h"
#include <iostream>
using namespace std;
using namespace libface;

/*======================================================================
  Main code plus interface to Matlab.
========================================================================*/

void mexFunction( int nlhs, mxArray *plhs[],int nrhs, const mxArray *prhs[] )
{

  if( nrhs != 1  )
    mexErrMsgTxt("Release CLbpPyrFilter from memory.\n"                 
                 "lf_lbppyrfilter_free( handle )\n\n"                 
                 " handle [...] returned by lf_lbppyrfilter_init()\n"
                 "\n");       

  // get pointer from matlab
  CLbpPyrFilter *filter;
  double* tmp = mxGetPr( prhs[0]  );
  memcpy( &filter, tmp, sizeof( &filter ));

  if( filter != NULL ) delete filter;

  return;
}


