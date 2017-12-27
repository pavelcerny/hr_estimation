/*=================================================================
 *  Returns affinely normalized image patch.
 *
 *  outImg = lf_affinenormrect( inImg, inLandmarks, outLandmarks, outNumRows, outNumCols )
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
    if( nrhs != 5 )
        mexErrMsgTxt("Five input arguments required.\n\n"
                 "Synopsis:\n"
                 "  outImg = lf_affinenormrect( inImg, inLandmarks, outLandmarks, outNumRows, outNumCols )\n"
                 "where\n"
                 "  inImg [inNumRows x inNumCols (uint8)] input image\n"
                 "  inLandmarks [2 x L] Landmarks in inImg ; 1-based coordinates\n"
                 "  outLandmarks [2 x L] Landmarks in outImg ; 1-based coordinates\n"
                 "  outNumRows [1 x 1] number of rows in outImg\n"
                 "  outNumCols [1 x 1] number of columns in outImg\n"
                 "\n"
                 "  outImg [outNumRows x outNumCols (uint8)] output image\n");

    /* */
    mwSize in_img_num_rows = mxGetM( prhs[0] );
    mwSize in_img_num_cols = mxGetN( prhs[0] );

    mwSize num_landmarks = mxGetN( prhs[1] );

    if( mxGetM( prhs[1] ) != 2 || num_landmarks < 3 )
        mexErrMsgTxt("The second argument has wrong size.");

    if( mxGetM( prhs[2] ) != 2 || mxGetN( prhs[2] ) != num_landmarks )
        mexErrMsgTxt("The third argument has wrong size.");

    mwSize out_img_num_rows = mxGetScalar( prhs[3] );
    mwSize out_img_num_cols = mxGetScalar( prhs[4] );

    double* in_landmarks  = (double*)mxCalloc( num_landmarks*2, sizeof(double));
    double* out_landmarks = (double*)mxCalloc( num_landmarks*2, sizeof(double));

    double* tmp1 = mxGetPr( prhs[1] );
    double* tmp2 = mxGetPr( prhs[2] );
    for(int i=0; i< 2; i++ )
    {
        for( int j=0; j < num_landmarks; j++ )
        {
//            in_landmarks[j+i*num_landmarks] = tmp1[j*2+i]-1;
//            out_landmarks[j+i*num_landmarks] = tmp2[j*2+i]-1;
            in_landmarks[j*2+i] = tmp1[j*2+i]-1;
            out_landmarks[j*2+i] = tmp2[j*2+i]-1;
        }
    }

    /* */
    Eye_Matrix_uc * in_img = NULL;
    if ( (in_img = eyeAllocMatrix_uc( in_img_num_rows, in_img_num_cols ) ) == NULL )
        mexErrMsgTxt("Memory allocation problem.\n");

    // Convert in_img  EyeFace format
    unsigned char* tmp = (unsigned char*)mxGetPr(prhs[0]);
    for(int i=0, cnt = 0; i < in_img_num_rows; i++)
        for(int j=0; j < in_img_num_cols; j++)
            in_img->data[cnt++] = (unsigned char)tmp[i+j*in_img_num_rows];


    plhs[0] = mxCreateNumericMatrix( out_img_num_rows, out_img_num_cols, mxUINT8_CLASS, mxREAL);
    uint8_t* out_img = (uint8_t*)mxGetPr( plhs[0] );

    /* */
    CAffineNormRect rect;

    if( rect.Init( out_img_num_rows, out_img_num_cols, num_landmarks, out_landmarks ) != kOK)
        mexErrMsgTxt("CaffineNormRect.Init() failed.");

    if( rect.ExtractRect( in_img, in_landmarks ) != kOK)
        mexErrMsgTxt("CaffineNormRect.ExtractrRect() failed.");

    if( rect.CopyToMatlab( out_img ) != kOK)
        mexErrMsgTxt("CaffineNormRect.CopyToMatlab() failed.");


    /* */
    mxFree( in_landmarks);
    mxFree( out_landmarks);
    eyeFreeMatrix( in_img );

    return;
}
