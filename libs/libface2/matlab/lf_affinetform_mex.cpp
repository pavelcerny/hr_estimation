/*=================================================================
 * Synopsis:
 *  outImg = lf_affinetform(inImg, warpMatrix, outImgNumRows, outImgNumCols )
 *
 *=================================================================*/

#include <mex.h>

#include "libface.h"

/*======================================================================
  Main code plus interface to Matlab.
========================================================================*/

void mexFunction( int nlhs, mxArray *plhs[],int nrhs, const mxArray *prhs[] )
{

  if( nrhs != 4 )
    mexErrMsgTxt("Four input arguments required.\n\n"
                 "Synopsis:\n"
                 "  outImg = lf_affinetform( inImg, warpMatrix, outImgNumRows, outImgNumCols )\n"
                 "where\n"
                 "  inImg [inImgNumRows x inImgNumCols (uint8)] input image\n"
                 "  warpMatrix [2 x 3 (double)] warp matrix should be 0-based. \n"
                 "  outImgNumRows [1x1 (double)] height of the output image \n"
                 "  outImgNumCols [1x1 (double)] width of the output image \n"
                 "\n"
                 "  outImg [outImgNumRows x outImgNumCols (uint8)] output image \n");

  /* */
  mwSize src_img_num_rows = mxGetM(prhs[0]);
  mwSize src_img_num_cols = mxGetN(prhs[0]);

  /* */
  double* warp_mat = mxGetPr(prhs[1]);
  if( (mxGetM(prhs[1]) != 2) || (mxGetN(prhs[1]) != 3))
    mexErrMsgTxt("The second argument must be matrix 2x3.\n");

  /* */
  mwSize dst_img_num_rows = mxGetScalar(prhs[2]);
  mwSize dst_img_num_cols = mxGetScalar(prhs[3]);

  /* */
  Eye_Matrix_uc * src_img = NULL;
  if ( (src_img = eyeAllocMatrix_uc( src_img_num_rows, src_img_num_cols ) ) == NULL )
      mexErrMsgTxt("Memory allocation problem.\n");

  // Convert frame to EyeFace format
  unsigned char* tmp = (unsigned char*)mxGetPr(prhs[0]);
  for(int i=0, cnt = 0; i < src_img_num_rows; i++)
      for(int j=0; j < src_img_num_cols; j++)
        src_img->data[cnt++] = (unsigned char)tmp[i+j*src_img_num_rows];

  /* Crop the face image                                           */
  Eye_Affine23_Matrix aff;
  aff.dAcc = warp_mat[0]; aff.dAcr = warp_mat[2]; aff.dBc  = warp_mat[4];
  aff.dArc = warp_mat[1]; aff.dArr = warp_mat[3]; aff.dBr  = warp_mat[5];

  Eye_Matrix_uc * dst_img = NULL;
  if( (dst_img = eyeAllocMatrix_uc( dst_img_num_rows, dst_img_num_cols ) ) == NULL )
      mexErrMsgTxt("Memory allocation problem.\n");

  /* warp image */
  if(( eye_affine_warp_with_2dfilter_rw( src_img, dst_img, &aff)!=0 ))
      mexErrMsgTxt("Affine tform implemented in libeye failed.\n");

  /* */
  plhs[0] = mxCreateNumericMatrix(dst_img_num_rows, dst_img_num_cols, mxUINT8_CLASS, mxREAL);
  tmp = (unsigned char*)mxGetPr( plhs[0] );

  for(int i = 0, cnt = 0; i < dst_img_num_cols; i++)
    for(int j = 0; j < dst_img_num_rows; j++)
        tmp[cnt++] = (unsigned char)dst_img->data[i+j*dst_img_num_cols];

  /* */
  eyeFreeMatrix( dst_img );
  eyeFreeMatrix( src_img );

  return;
}
