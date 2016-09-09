// OpenCV Point <=> Scilab: double 1x2

%{
int SWIG_SciDoubleOrInt32_AsPoint(void *pvApiCtx, SwigSciObject iVar, cv::Point *point, char *fname) {
  int *piValues = NULL;
  int iRows = 0;
  int iCols = 0;
  if (SWIG_SciDoubleOrInt32_AsIntArrayAndSize(pvApiCtx, iVar, &iRows, &iCols, &piValues, fname) != SWIG_OK) {
    return SWIG_ERROR;
  }

  if (iRows * iCols == 2) {
    point->x = piValues[0];
    point->y = piValues[1];
    return SWIG_OK;
  }
  else {
    return SWIG_ERROR;
  }
}
%}

// TODO: fix precedence
%typemap(typecheck, precedence=SWIG_TYPECHECK_DOUBLE) cv::Point, const cv::Point& {
  cv::Point point;
  $1 = SWIG_SciDoubleOrInt32_AsPoint(pvApiCtx, $input, &point, SWIG_Scilab_GetFuncName()) == SWIG_OK ? 1 : 0;
}

%typemap(in, noblock=1) cv::Point {
  if (SWIG_SciDoubleOrInt32_AsPoint(pvApiCtx, $input, &$1, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
}

%typemap(in, noblock=1) cv::Point& (cv::Point tmpPoint)  {
  $1 = &tmpPoint;
  if (SWIG_SciDoubleOrInt32_AsPoint(pvApiCtx, $input, $1, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
}
