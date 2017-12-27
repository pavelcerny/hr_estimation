/*=================================================================
 * Synopsis:
 *  dstImg = lf_cropanddownscale_img( srcImg, rect, outImgSize  )
 *
 *  It crops rectangle rect [tlc tlr brc brr] from srcImg and it 
 *  downscales the rectangle to 
 *  the outImgSize [width x height].
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

  if( nrhs != 3 )
    mexErrMsgTxt("Three input arguments required.\n\n"
                 "Synopsis:\n"
                 "  dstImg = lf_cropanddownscale( srcImg, rect, outImgSize)\n"
                 " \n"
                 " srcImg [W x H uint8] Souce image\n"
                 " rect   [4 x 1 double] Area to crop [tlc tlr brc brr]; 1-based\n"
                 " outImgSize [2 x 1] = [width height] of the output image \n"
                 "\n"
                 " dstImg [width x height uint8] output image\n" 
                 "\n");
       
  //
  int src_img_size[2];
  src_img_size[0] = mxGetN( prhs[0] );
  src_img_size[1] = mxGetM( prhs[0] );

  double* tmp;  
  tmp = (double*)mxGetPr( prhs[1] );
  int rect[4];
  rect[0] = (int)tmp[0]-1;
  rect[1] = (int)tmp[1]-1;
  rect[2] = (int)tmp[2]-1;
  rect[3] = (int)tmp[3]-1;

  tmp = (double*)mxGetPr( prhs[2] );
  int dst_img_size[2];
  dst_img_size[0] = (int)tmp[0];
  dst_img_size[1] = (int)tmp[1];

  //
  if( rect[2]-rect[0]+1 < dst_img_size[0] || rect[3]-rect[1]+1 < dst_img_size[1] )
    mexErrMsgTxt("Output image must not be bigger than cropped region.");
  
  //
  uint8_t* src_img = (uint8_t*)mxCalloc( src_img_size[0]*src_img_size[1], sizeof( uint8_t ));
  uint32_t* iimg   = (uint32_t*)mxCalloc( src_img_size[0]*src_img_size[1], sizeof( uint32_t ));
  uint8_t* dst_img = (uint8_t*)mxCalloc( dst_img_size[0]*dst_img_size[1], sizeof( uint8_t ));

  if( !src_img || !iimg || !dst_img)
    mexErrMsgTxt("Cannot allocate memory for working images.");

  // convert Matlab column-wise matrix to row-wise src_img
  uint8_t* pr1 = (uint8_t*)mxGetPr(prhs[0]);
  for(int i=0; i < src_img_size[1]; i++)
    for(int j=0; j < src_img_size[0]; j++) 
      src_img[i*src_img_size[0]+j] = (uint8_t)pr1[i+j*src_img_size[1]];

  //
  IntegralImgUc( src_img, iimg, src_img_size[0], src_img_size[1] );

  //
  CropAndDownscale( src_img_size, iimg, rect, dst_img_size, dst_img);
  
  // 
  plhs[0]      = mxCreateNumericMatrix(dst_img_size[1], dst_img_size[0], mxUINT8_CLASS, mxREAL );
  uint8_t* pr2 = (uint8_t*)mxGetPr( plhs[0] );

  // convert integral_img to Matlab
  for(int i=0; i < dst_img_size[1]; i++)
    for(int j=0; j < dst_img_size[0]; j++) 
      pr2[i+j*dst_img_size[1]] = dst_img[i*dst_img_size[0]+j];

  //
  mxFree( dst_img );
  mxFree( src_img );
  mxFree( iimg );

  return;
}


