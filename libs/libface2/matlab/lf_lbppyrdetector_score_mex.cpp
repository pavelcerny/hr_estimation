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

  if( nrhs != 6 && nrhs != 7 && nrhs != 8 )
    mexErrMsgTxt("Six, seven or eight input arguments required.\n\n"
                 "Synopsis:\n"
                 "  score = lf_lbppyrdetector_score_mex(iImg,searchArea,baseWinSize,scanWinSize,lbpPyrHeight,W)\n"
                 "  score = lf_lbppyrdetector_score_mex(iImg,searchArea,baseWinSize,scanWinSize,lbpPyrHeight,W,prior)\n"
                 "\n");
       
  //
  int src_img_size[2];
  src_img_size[0] = mxGetN( prhs[0] );
  src_img_size[1] = mxGetM( prhs[0] );

  double* tmp;  
  tmp = (double*)mxGetPr( prhs[1] );
  int area[4];
  area[0] = (int)tmp[0]-1;
  area[1] = (int)tmp[1]-1;
  area[2] = (int)tmp[2]-1;
  area[3] = (int)tmp[3]-1;

  tmp = (double*)mxGetPr( prhs[2] );
  int base_win_size[2];
  base_win_size[0] = (int)tmp[0];
  base_win_size[1] = (int)tmp[1];

  tmp = (double*)mxGetPr( prhs[3] );
  int scan_win_size[2];
  scan_win_size[0] = (int)tmp[0];
  scan_win_size[1] = (int)tmp[1];

  int lbp_pyr_height = (int)mxGetScalar( prhs[4] );

  double* W = mxGetPr( prhs[5] );
  int num_weights = LF_MAX( mxGetN( prhs[5]), mxGetM( prhs[5] ));

  /*  mexPrintf("srcImgSize: %d %d\n", src_img_size[0], src_img_size[1]);
  mexPrintf("searchArea: %d %d %d %d\n", area[0], area[1], area[2], area[3] );
  mexPrintf("baseWinSize: %d %d\n", base_win_size[0], base_win_size[1] );
  mexPrintf("scanWinSize: %d %d\n", scan_win_size[0], scan_win_size[1] );
  mexPrintf("numWeights: %d\n", num_weights );
  mexPrintf("lbpPyrHeight: %d\n", lbp_pyr_height );
  */

  // output matrix
  plhs[0] = mxCreateDoubleMatrix( area[3]-area[1]+1, area[2]-area[0]+1, mxREAL);
  double *score = mxGetPr( plhs[0] );

  //
  uint32_t* pr1 = (uint32_t*)mxGetPr( prhs[0] );
  uint32_t* src_iimg = (uint32_t*)mxCalloc( src_img_size[0]*src_img_size[1], sizeof( uint32_t ));
  for( int i=0; i < src_img_size[0]; i++ )
    for( int j=0; j < src_img_size[1]; j++ )
      src_iimg[i+j*src_img_size[0]] = pr1[j+i*src_img_size[1]];

  double* prior = NULL;
  if( nrhs == 7 && !mxIsEmpty( prhs[6]))
  {
    int area_num_cols = area[2]-area[0]+1;
    int area_num_rows = area[3]-area[1]+1;

    /*    mexPrintf("area_num_cols: %d\n", area_num_cols);
          mexPrintf("area_num_rowss: %d\n", area_num_rows);*/


    if( mxGetN( prhs[6]) != area_num_cols || mxGetM( prhs[6] ) != area_num_rows )
      mexErrMsgTxt( "The matrix Prior must have the same size as define the search area." );

    prior = (double*)mxCalloc( area_num_cols*area_num_rows, sizeof( double) );
    if( !prior ) mexErrMsgTxt( "Cannot allocate memery."); 

    double* pr3 = (double*)mxGetPr(prhs[6] );
    for( int i=0; i < area_num_cols; i++ )
      for( int j=0; j < area_num_rows; j++)
        prior[ i+j*area_num_cols ] = pr3[ j+i*area_num_rows ];
  }

  CLbpPyrDetector det;

  if( det.Init(base_win_size, lbp_pyr_height, num_weights, W  ) != kOK ) 
    mexErrMsgTxt("det.Init(...) error.\n");

  double t0 = CpuTime();
  if( det.CompScore( score, src_img_size, src_iimg, area, scan_win_size, prior ) != kOK)
      mexErrMsgTxt("det.ScanArea(...) error.\n");
  double cpu_time = CpuTime() - t0;

  plhs[1] = mxCreateDoubleScalar( cpu_time );

  mxFree( src_iimg );
  mxFree( prior );

  return;
}


