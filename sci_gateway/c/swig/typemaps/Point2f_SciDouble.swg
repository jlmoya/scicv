// Scilab Computer Vision Toolbox
// Copyright (C) 2017 - Scilab Enterprises

%fragment("SWIG_SciDouble_AsPoint2f", "header", fragment ="SWIG_SciDouble_AsFloatArrayAndSize") {
int SWIG_SciDouble_AsPoint2f(void *pvApiCtx, SwigSciObject iVar, cv::Point2f *point2f, char *fname) {
  float *pfValues = NULL;
  int iRows = 0;
  int iCols = 0;
  if (SWIG_SciDouble_AsFloatArrayAndSize(pvApiCtx, iVar, &iRows, &iCols, &pfValues, fname) != SWIG_OK) {
    return SWIG_ERROR;
  }
  if (iRows * iCols == 2) {
    point2f->x = pfValues[0];
    point2f->y = pfValues[1];
    return SWIG_OK;
  }
  else {
    return SWIG_ERROR;
  }
}
}


%fragment("SWIG_SciDouble_FromPoint2f", "header", fragment="SWIG_SciDouble_FromFloatArrayAndSize") {
int SWIG_SciDouble_FromPoint2f(void *pvApiCtx, SwigSciObject iVarOut, cv::Point2f *pPoint2f, char *fname) {
  float pfValues[2];
  pfValues[0] = pPoint2f->x;
  pfValues[1] = pPoint2f->y;
  if (SWIG_SciDouble_FromFloatArrayAndSize(pvApiCtx, iVarOut, 1, 2, pfValues) != SWIG_OK) {
    return SWIG_ERROR;
  }
  return SWIG_OK;
}
}
