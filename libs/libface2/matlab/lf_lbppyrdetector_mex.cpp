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
                 "  [ceter,bbox,score,feat,cputime] = lf_lbppyrdetector(iImg,searchAarea,baseWinSize,scanWinSize,lbpPyrHeight,W)\n"
                 "  [...] = lf_lbppyrdetector(iImg,searchAarea,baseWinSize,scanWinSize,lbpPyrHeight,W,Prior,maxSteps)\n"
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
  
  /*
  mexPrintf("srcImgSize: %d %d\n", src_img_size[0], src_img_size[1]);
  mexPrintf("searchArea: %d %d %d %d\n", area[0], area[1], area[2], area[3] );
  mexPrintf("baseWinSize: %d %d\n", base_win_size[0], base_win_size[1] );
  mexPrintf("scanWinSize: %d %d\n", scan_win_size[0], scan_win_size[1] );
  mexPrintf("numWeights: %d\n", num_weights );
  mexPrintf("lbpPyrHeight: %d\n", lbp_pyr_height );
  */

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
  if( nrhs == 8 )
  {
    int max_steps = (int)mxGetScalar( prhs[7] );
    //    mexPrintf("max_steps: %d\n", max_steps);
    if( det.ScanAreaC2F( src_img_size, src_iimg, area, scan_win_size, prior, max_steps ) != kOK)
      mexErrMsgTxt("det.ScanAreaSP(...) error.\n");
  }
  else
  {
    if( det.ScanArea( src_img_size, src_iimg, area, scan_win_size, prior ) != kOK)
      mexErrMsgTxt("det.ScanArea(...) error.\n");
  }
  double cpu_time = CpuTime() - t0;

  /*
  mexPrintf("det.nnz_features: %d\n", det.get_nnz_features());
  mexPrintf("det.num_weights: %d\n", det.get_num_weights());
  */

  /*  if( det.ScanArea( src_img_size, src_iimg, area, scan_win_size, prior ) != kOK)
    mexErrMsgTxt("det.ScanArea(...) error.\n");
  */

  /*
  mexPrintf("pos_col: %d\n", det.get_pos_col()+1);
  mexPrintf("pos_row: %d\n", det.get_pos_row()+1);
  mexPrintf("score: %f\n", det.get_score());
  */

  if( det.ExtractFeatures( src_img_size, src_iimg, det.get_pos_col(), 
                           det.get_pos_row(), scan_win_size ) != kOK)
  {
    plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
    plhs[1] = mxCreateDoubleMatrix(0,0,mxREAL);
    plhs[2] = mxCreateDoubleMatrix(0,0,mxREAL);
    plhs[3] = mxCreateDoubleMatrix(0,0,mxREAL);
    return;
  }
  //    mexErrMsgTxt("det.ExtractFeatures(...) error.\n");

  double *pr;
  plhs[0] = mxCreateDoubleMatrix( 1, 2, mxREAL);
  pr = (double*)mxGetPr( plhs[0] );
  pr[0] = det.get_pos_col()+1;
  pr[1] = det.get_pos_row()+1;

  plhs[1] = mxCreateDoubleMatrix( 1, 4, mxREAL);
  pr = (double*)mxGetPr( plhs[1] );
  int* pr3 = det.get_est_bbox_ptr();
  pr[0] = (double)pr3[0]+1;
  pr[1] = (double)pr3[1]+1;
  pr[2] = (double)pr3[2]+1;
  pr[3] = (double)pr3[3]+1;

    //  plhs[0] = mxCreateDoubleScalar( det.get_pos_col()+1 );
    //plhs[1] = mxCreateDoubleScalar( det.get_pos_row()+1 );
  plhs[2] = mxCreateDoubleScalar( det.get_score() );


  plhs[3] = mxCreateNumericMatrix( det.get_num_weights(), 1, mxUINT8_CLASS, mxREAL);
  uint32_t* features = det.get_features_ptr();
  char* pr2          = (char*)mxGetPr(plhs[3]);
  
  memset( pr2, 0, det.get_num_weights() );
  for( int i = 0; i < det.get_nnz_features(); i++) pr2[ features[i] ] = 1; 


  plhs[4] = mxCreateDoubleScalar( cpu_time );

  mxFree( src_iimg );
  mxFree( prior );

  return;
}


