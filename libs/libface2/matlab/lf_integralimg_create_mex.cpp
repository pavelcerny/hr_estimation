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

  if( nrhs != 1 || nlhs != 1 )
    mexErrMsgTxt("Just one input and one ouput argument is required.\n\n"
                 "Synopsis:\n"
                 "  handle = lf_integralimg_create( srcImg  )\n"
                 "\n"
                 "  srcImg [H x W uint8] source image.\n"
                 "  handle [...] pointer to integral image resident in memory.\n");

  //
  mwSize num_rows = mxGetM( prhs[0] );
  mwSize num_cols = mxGetN( prhs[0] );

  //  mexPrintf("num_rows: %d   num_cols: %d  filter_size: %d\n", num_rows, num_cols, filter_size);

  uint8_t* src_img = (uint8_t*)mxCalloc( num_rows*num_cols, sizeof( uint8_t ));
  //  uint32_t* iimg   = (uint32_t*)mxCalloc( num_rows*num_cols, sizeof( uint32_t ));

  CImgUint32* iimg = new CImgUint32();

  
  if( iimg->Init((int)num_cols, (int)num_rows ) != kOK || !src_img )
    mexErrMsgTxt("Memory allocation problem.");

  // convert Matlab column-wise matrix to row-wise src_img
  uint8_t* pr1 = (uint8_t*)mxGetPr(prhs[0]);
  for(int i=0; i < num_rows; i++)
    for(int j=0; j < num_cols; j++) 
      src_img[i*num_cols+j] = (double)pr1[i+j*num_rows];

  //
  IntegralImgUc( src_img, iimg->data_ , (int)num_cols, (int)num_rows );

  /* Put pointer to Matlab workspace */
  mwSize dims[1];
  dims[0] = sizeof( &iimg );
  plhs[0] = mxCreateNumericArray( 1, dims, mxINT8_CLASS, mxREAL );
  double *pdTmp = mxGetPr( plhs[0] );
  memcpy( pdTmp, &iimg, sizeof( &iimg ));

  //
  mxFree( src_img );

  return;
}


