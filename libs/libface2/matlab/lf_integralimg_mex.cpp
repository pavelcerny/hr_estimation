/*=================================================================
 * Synopsis:
 *  dstImg = lf_integral_img( srcImg  )
 *
 *  (i,j) pixel of dstImg will contain sum of pixels of src_img from
 *  top-left corner to pixel (i,j).
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
    mexErrMsgTxt("One input arguments required.\n\n"
                 "Synopsis:\n"
                 "  dstImg = lf_integralimg( srcImg  )\n"
                 "\n"
                 "  srcImg [H x W uint8] source image.\n"
                 "  dstImg [H X W double] integral image of srcImg returned in double matrix.\n");

  //
  mwSize num_rows = mxGetM( prhs[0] );
  mwSize num_cols = mxGetN( prhs[0] );

  //  mexPrintf("num_rows: %d   num_cols: %d  filter_size: %d\n", num_rows, num_cols, filter_size);

  uint8_t* src_img = (uint8_t*)mxCalloc( num_rows*num_cols, sizeof( uint8_t ));
  uint32_t* iimg = (uint32_t*)mxCalloc( num_rows*num_cols, sizeof( uint32_t ));

  if( !src_img || !iimg)
    mexErrMsgTxt("Cannot allocate memory for image buffers.");

  // convert Matlab column-wise matrix to row-wise src_img
  uint8_t* pr1 = (uint8_t*)mxGetPr(prhs[0]);
  for(int i=0; i < num_rows; i++)
    for(int j=0; j < num_cols; j++) 
      src_img[i*num_cols+j] = (double)pr1[i+j*num_rows];

  //
  IntegralImgUc( src_img, iimg, (int)num_cols, (int)num_rows );

  //
  plhs[0]       = mxCreateNumericMatrix( num_rows, num_cols, mxUINT32_CLASS, mxREAL );
  uint32_t* pr2 = (uint32_t*)mxGetPr( plhs[0] );

  // convert integral_img to Matlab
  for(int i=0; i < num_rows; i++)
    for(int j=0; j < num_cols; j++) 
      pr2[i+j*num_rows] = iimg[i*num_cols+j];


  mxFree( src_img );
  mxFree( iimg );

  return;
}


