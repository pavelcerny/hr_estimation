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

using namespace libface;


/*======================================================================
  Main code plus interface to Matlab.
========================================================================*/

void mexFunction( int nlhs, mxArray *plhs[],int nrhs, const mxArray *prhs[] )
{

  if( nrhs != 5  )
    mexErrMsgTxt("Three input arguments required.\n\n"
                 "  handle = lf_lbppyrfilter_init( iImgHandle, scanWinSize, baseImgSize, lbpPyrHeight,W)\n"
                 "   iImgHandle [...] handle returned by lf_imtegralimg_create \n"
                 "   scanWinSize [2x1] scanning window size \n"
                 "   baseImgSize [2x1] width x height of base window\n"
                 "   lbpPyrHeight [1x1] \n"
                 "   W [Nx1] \n"
                 "\n");
       
  // arg 1
  CImgUint32* iimg;
  double* tmp = mxGetPr( prhs[0]  );
  memcpy( &iimg, tmp, sizeof( &iimg ));

  // arg 2
  tmp = (double*)mxGetPr( prhs[1] );
  int scan_win_size[2];
  scan_win_size[0] = (int)tmp[0];
  scan_win_size[1] = (int)tmp[1];

  // arg 3
  tmp = (double*)mxGetPr( prhs[2] );
  int base_img_size[2];
  base_img_size[0] = (int)tmp[0];
  base_img_size[1] = (int)tmp[1];

  // arg 4
  int lbp_pyr_height = (int)mxGetScalar( prhs[3] );

  // arg 5
  double* W          = mxGetPr( prhs[4] );
  int num_weights    = LF_MAX( mxGetN( prhs[4]), mxGetM( prhs[4] ));

  /*  mexPrintf("scanWinSize  : %d %d\n", scan_win_size[0], scan_win_size[1] );
  mexPrintf("baseImgSize  : %d %d\n", base_img_size[0], base_img_size[1] );
  mexPrintf("numWeights   : %d\n", num_weights );
  mexPrintf("lbpPyrHeight : %d\n", lbp_pyr_height );
  mexPrintf("num pixels in iimg: %d\n", iimg->num_pixels() );
  mexPrintf("sum of pixels: %d\n",  iimg->data_[iimg->num_pixels()-1 ]);
  */

  // initialize the filter
  CLbpPyrFilter *filter = new CLbpPyrFilter();

  if( filter->Init( base_img_size, lbp_pyr_height, num_weights, W  ) != kOK ) 
    mexErrMsgTxt("filter.Init(...) error.\n");

  // set image 
  filter->SetImage( iimg, scan_win_size );


  /* Put pointer to Matlab workspace */
  mwSize dims[1];
  dims[0] = sizeof( filter );
  plhs[0] = mxCreateNumericArray( 1, dims, mxINT8_CLASS, mxREAL );
  double *pdTmp = mxGetPr( plhs[0] );
  memcpy( pdTmp, &filter, sizeof( &filter ));

  return;
}


