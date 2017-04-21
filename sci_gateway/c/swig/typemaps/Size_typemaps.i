// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

// Scilab: double 1x2 <=> OpenCV Size

%fragment("SWIG_Check_Size", "header") {
int SWIG_Check_Size(void *pvApiCtx, SwigSciObject iVar, char *fname) {
  int *piValues = NULL;
  int iRows = 0;
  int iCols = 0;
  return (SWIG_SciDoubleOrInt32_AsIntArrayAndSize(pvApiCtx, iVar, &iRows, &iCols, &piValues, fname) == SWIG_OK) ? 1 : 0;
}
}

%fragment("SWIG_SciDoubleOrInt32_AsSize", "header") {
int SWIG_SciDoubleOrInt32_AsSize(void *pvApiCtx, SwigSciObject iVar, cv::Size *size, char *fname) {
  int *piValues = NULL;
  int iRows = 0;
  int iCols = 0;
  if (SWIG_SciDoubleOrInt32_AsIntArrayAndSize(pvApiCtx, iVar, &iRows, &iCols, &piValues, fname) != SWIG_OK) {
    return SWIG_ERROR;
  }

  if (iRows * iCols == 2) {
    size->height = piValues[0];
    size->width = piValues[1];
    return SWIG_OK;
  }
  else if (iRows * iCols == 1) {
    size->height = piValues[0];
    size->width = piValues[1];
    return SWIG_OK;
  }
  else {
    return SWIG_ERROR;
  }
}
}

// TODO: fix precedence
%typemap(typecheck, precedence=SWIG_TYPECHECK_DOUBLE, fragment="SWIG_Check_Size") cv::Size, const cv::Size& {
  $1 = SWIG_Check_Size(pvApiCtx, $input, SWIG_Scilab_GetFuncName());
}

%typemap(in, noblock=1, fragment="SWIG_SciDoubleOrInt32_AsSize") cv::Size {
  if (SWIG_SciDoubleOrInt32_AsSize(pvApiCtx, $input, &$1, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
}

%typemap(in, noblock=1, fragment="SWIG_SciDoubleOrInt32_AsSize") cv::Size& (cv::Size tmpSize)  {
  $1 = &tmpSize;
  if (SWIG_SciDoubleOrInt32_AsSize(pvApiCtx, $input, $1, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
}
