// OpenCV KeyPoint <= Scilab: double 1x7

/*

%{
int SWIG_SciDoubleOrInt32_AsKeyPoint(void *pvApiCtx, SwigSciObject iVar, cv::KeyPoint *keypoint, char *fname) {
  int *piValues = NULL;
  int iRows = 0;
  int iCols = 0;
  if (SWIG_SciDoubleOrInt32_AsIntArrayAndSize(pvApiCtx, iVar, &iRows, &iCols, &piValues, fname) != SWIG_OK) {
    return SWIG_ERROR;
  }

  if (iRows * iCols == 7) {
    keypoint->x = piValues[0];
    keypoint->y = piValues[1];
    keypoint->size = piValues[2];
    keypoint->angle = piValues[3];
    keypoint->response = piValues[4];
    keypoint->octave =piValues[5];
    keypoint->class_id =piValues[6];

    return SWIG_OK;
  }
  else {
    return SWIG_ERROR;
  }
}
%}

// TODO: fix precedence
%typemap(typecheck, precedence=SWIG_TYPECHECK_DOUBLE) cv::KeyPoint, const cv::KeyPoint& {
  cv::KeyPoint keypoint;
  $1 = SWIG_SciDoubleOrInt32_AsKeyPoint(pvApiCtx, $input, &keypoint, SWIG_Scilab_GetFuncName()) == SWIG_OK ? 1 : 0;
}

%typemap(in, noblock=1) cv::KeyPoint {
  if (SWIG_SciDoubleOrInt32_AsKeyPoint(pvApiCtx, $input, &$1, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
}

%typemap(in, noblock=1) cv::KeyPoint& (cv::KeyPoint tmpRect)  {
  $1 = &tmpKeyPoint;
  if (SWIG_SciDoubleOrInt32_AsKeyPoint(pvApiCtx, $input, $1, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
}

*/
