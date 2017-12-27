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

  if( nrhs != 7 )
    mexErrMsgTxt("Six, seven or eight input arguments required.\n\n"
                 "Synopsis:\n"
                 "  outScore = lf_lbppyrdetector_update_score_mex(inScore,iImg,searchArea,baseWinSize,scanWinSize,lbpPyrHeight,W)\n"
                 "\n");
       
  //
  int src_img_size[2];
  src_img_size[0] = mxGetN( prhs[1] );
  src_img_size[1] = mxGetM( prhs[1] );

  double* tmp;  
  tmp = (double*)mxGetPr( prhs[2] );
  int area[4];
  area[0] = (int)tmp[0]-1;
  area[1] = (int)tmp[1]-1;
  area[2] = (int)tmp[2]-1;
  area[3] = (int)tmp[3]-1;

  tmp = (double*)mxGetPr( prhs[3] );
  int base_win_size[2];
  base_win_size[0] = (int)tmp[0];
  base_win_size[1] = (int)tmp[1];

  tmp = (double*)mxGetPr( prhs[4] );
  int scan_win_size[2];
  scan_win_size[0] = (int)tmp[0];
  scan_win_size[1] = (int)tmp[1];

  int lbp_pyr_height = (int)mxGetScalar( prhs[5] );

  double* W = mxGetPr( prhs[6] );
  int num_weights = LF_MAX( mxGetN( prhs[6]), mxGetM( prhs[6] ));

  /*
  mexPrintf("srcImgSize: %d %d\n", src_img_size[0], src_img_size[1]);
  mexPrintf("searchArea: %d %d %d %d\n", area[0], area[1], area[2], area[3] );
  mexPrintf("baseWinSize: %d %d\n", base_win_size[0], base_win_size[1] );
  mexPrintf("scanWinSize: %d %d\n", scan_win_size[0], scan_win_size[1] );
  mexPrintf("numWeights: %d\n", num_weights );
  mexPrintf("lbpPyrHeight: %d\n", lbp_pyr_height );
  */

  // output matrix
  plhs[0] = mxCreateDoubleMatrix( src_img_size[1], src_img_size[0], mxREAL);
  double *out_score = mxGetPr( plhs[0] );

  double *tmp_score = (double*)mxCalloc( src_img_size[0]*src_img_size[1], sizeof(double));
  if( tmp_score == NULL)
    mexErrMsgTxt("Not enough memory");

  double swap_time = 0;
  double t0 = CpuTime();

  double *in_score = mxGetPr( prhs[0] );
  for( int i=0; i < src_img_size[0]; i++ )
    for( int j=0; j < src_img_size[1]; j++ )
      tmp_score[i+j*src_img_size[0]] = in_score[j+i*src_img_size[1]];

  swap_time = swap_time + CpuTime()-t0;

  //
  t0 = CpuTime();
  uint32_t* pr1 = (uint32_t*)mxGetPr( prhs[1] );
  uint32_t* src_iimg = (uint32_t*)mxCalloc( src_img_size[0]*src_img_size[1], sizeof( uint32_t ));
  for( int i=0; i < src_img_size[0]; i++ )
    for( int j=0; j < src_img_size[1]; j++ )
      src_iimg[i+j*src_img_size[0]] = pr1[j+i*src_img_size[1]];
  swap_time = swap_time + CpuTime()-t0;


  CLbpPyrDetector det;

  if( det.Init(base_win_size, lbp_pyr_height, num_weights, W  ) != kOK ) 
    mexErrMsgTxt("det.Init(...) error.\n");

  t0 = CpuTime();
  if( det.UpdateScore( tmp_score, src_img_size, src_iimg, area, scan_win_size ) != kOK)
      mexErrMsgTxt("det.ScanArea(...) error.\n");
  double cpu_time = CpuTime() - t0;

  t0 = CpuTime();
  for( int i=0; i < src_img_size[0]; i++ )
    for( int j=0; j < src_img_size[1]; j++ )
      out_score[j+i*src_img_size[1]] = tmp_score[i+j*src_img_size[0]];
  swap_time = swap_time + CpuTime()-t0;


  plhs[1] = mxCreateDoubleScalar( cpu_time );
  plhs[2] = mxCreateDoubleScalar( swap_time );
  

  mxFree( tmp_score );
  mxFree( src_iimg );

  return;
}


