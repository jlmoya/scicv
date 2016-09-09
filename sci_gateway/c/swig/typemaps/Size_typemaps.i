// Scilab: double 1x2 <=> OpenCV Size

%{
int SWIG_SciDoubleOrInt32_AsSize(void *pvApiCtx, SwigSciObject iVar, cv::Size *size, char *fname) {
  int *piValues = NULL;
  int iRows = 0;
  int iCols = 0;
  if (SWIG_SciDoubleOrInt32_AsIntArrayAndSize(pvApiCtx, iVar, &iRows, &iCols, &piValues, fname) != SWIG_OK) {
    return SWIG_ERROR;
  }

  if (iRows * iCols == 2) {
    size->width = piValues[0];
    size->height = piValues[1];
    return SWIG_OK;
  }
  else {
    return SWIG_ERROR;
  }
}
%}

// TODO: fix precedence
%typemap(typecheck, precedence=SWIG_TYPECHECK_DOUBLE) cv::Size, const cv::Size& {
  cv::Size size;
  $1 = SWIG_SciDoubleOrInt32_AsSize(pvApiCtx, $input, &size, SWIG_Scilab_GetFuncName()) == SWIG_OK ? 1 : 0;
}

%typemap(in, noblock=1) cv::Size {
  if (SWIG_SciDoubleOrInt32_AsSize(pvApiCtx, $input, &$1, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
}

%typemap(in, noblock=1) cv::Size& (cv::Size tmpSize)  {
  $1 = &tmpSize;
  if (SWIG_SciDoubleOrInt32_AsSize(pvApiCtx, $input, $1, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
}
