/*=================================================================
 *
 * warpMat = lf_estimaffinetform( inPoints, outPoints )
 *
 *=================================================================*/

#include <mex.h>

#include "libface.h"

using namespace libface;

/*======================================================================
  Main code plus interface to Matlab.
========================================================================*/

void mexFunction( int nlhs, mxArray *plhs[],int nrhs, const mxArray *prhs[] )
{
    int i, j;

    if( nrhs != 2 )
        mexErrMsgTxt("Two input arguments are required.\n\n"
                     "Synopsis:\n"
                     "  warpMat = lf_estimaffinetform( inPoints, outPoints )\n"
                     "where\n"
                    "  inPoints [2xN (double)]\n"
                    "  outPoints [2xN (double)]\n"
                    "\n"
                    "  warpMatrix [2 x 3 (double)] warp matrix\n");

    /* */
    mwSize src_points_num_rows = mxGetM(prhs[0]);
    mwSize src_points_num_cols = mxGetN(prhs[0]);

    mwSize dst_points_num_rows = mxGetM(prhs[1]);
    mwSize dst_points_num_cols = mxGetN(prhs[1]);

    if( dst_points_num_rows != 2 || src_points_num_rows != 2 || src_points_num_cols != dst_points_num_cols)
        mexErrMsgTxt("The input arguments have wrong size. See help.\n");

//    double* src_points = (double*)mxCalloc(src_points_num_rows*src_points_num_cols, sizeof(double));
//    double* dst_points = (double*)mxCalloc(dst_points_num_rows*dst_points_num_cols, sizeof(double));

    double* tmp1 = mxGetPr( prhs[0] );
    double* tmp2 = mxGetPr( prhs[1] );
/*    for(i=0; i< src_points_num_rows; i++ )
    {
        for( j=0; j < src_points_num_cols; j++ )
        {
            src_points[j+i*src_points_num_cols] = tmp1[j*src_points_num_rows+i];
            dst_points[j+i*dst_points_num_cols] = tmp2[j*dst_points_num_rows+i];
        }
    }
*/
    /* */
    double* warp_mat = (double*)mxCalloc(6, sizeof(double));

    /* */
//    if(CompAffineTform( src_points_num_cols, src_points, dst_points, warp_mat ) != kOK)
//        mexErrMsgTxt("Problem calling CompAffineTform");
    if(CompAffineTform( src_points_num_cols, tmp2, tmp1, warp_mat ) != kOK)
        mexErrMsgTxt("Problem calling CompAffineTform");


    /* convert matrix to Matlab column-wise format */
    plhs[0] = mxCreateDoubleMatrix(2, 3, mxREAL);
    double* tmp3 = (double*)mxGetPr( plhs[0] );
    for(i=0; i < 2; i++)
        for(j = 0; j < 3; j++)
            tmp3[j*2+i] = warp_mat[j+3*i];


    /* */
//    mxFree( src_points );
//    mxFree( dst_points );
    mxFree( warp_mat );

    return;
}


