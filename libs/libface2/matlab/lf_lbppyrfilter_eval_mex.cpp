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

  if( nrhs != 2  )
    mexErrMsgTxt("Three input arguments required.\n\n"
                 "  [val,gradCol,gradRow,cpuTime] = lf_lbppyrfilter_eval( handle, p )\n"
                 "  handle [ ] returned by lf_lbppyrfilter_init()\n"
                 "  p    [2x1] position 1-based \n"
                 "  val  [1x1]  value of filtered response \n"
                 "  gradCol [1x1] gradient\n"
                 "  gradRow [1x1] gradient\n"
                 "  cpuTime [1x1] cpu time \n"
                 "\n");
       
  //
  CLbpPyrFilter *filter;
  double* tmp = mxGetPr( prhs[0]  );
  memcpy( &filter, tmp, sizeof( &filter ));

  tmp = (double*)mxGetPr( prhs[1] );
  double col = tmp[0];
  double row = tmp[1];

  double val;
  double grad_col;
  double grad_row;
  
/*  mexPrintf("pos : %f %f\n", row, col );*/

  double t0 = CpuTime();
  filter->Eval( col-1, row-1, val, grad_col, grad_row );
  double cpu_time = CpuTime() - t0;

  plhs[0] = mxCreateDoubleScalar( val );
  plhs[1] = mxCreateDoubleScalar( grad_col );
  plhs[2] = mxCreateDoubleScalar( grad_row );
  plhs[3] = mxCreateDoubleScalar( cpu_time );
  
  return;
}


