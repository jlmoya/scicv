// OpenCV Rect <= Scilab: double 1x4

%{
int SWIG_SciDoubleOrInt32_AsRect(void *pvApiCtx, SwigSciObject iVar, cv::Rect *rect, char *fname) {
  int *piValues = NULL;
  int iRows = 0;
  int iCols = 0;
  if (SWIG_SciDoubleOrInt32_AsIntArrayAndSize(pvApiCtx, iVar, &iRows, &iCols, &piValues, fname) != SWIG_OK) {
    return SWIG_ERROR;
  }

  if (iRows * iCols == 4) {
    rect->x = piValues[0];
    rect->y = piValues[1];
    rect->width = piValues[2];
    rect->height = piValues[3];
    return SWIG_OK;
  }
  else {
    return SWIG_ERROR;
  }
}
%}

// TODO: fix precedence
%typemap(typecheck, precedence=SWIG_TYPECHECK_DOUBLE) cv::Rect, const cv::Rect& {
  cv::Rect rect;
  $1 = SWIG_SciDoubleOrInt32_AsRect(pvApiCtx, $input, &rect, SWIG_Scilab_GetFuncName()) == SWIG_OK ? 1 : 0;
}

%typemap(in, noblock=1) cv::Rect {
  if (SWIG_SciDoubleOrInt32_AsRect(pvApiCtx, $input, &$1, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
}

%typemap(in, noblock=1) cv::Rect& (cv::Rect tmpRect)  {
  $1 = &tmpRect;
  if (SWIG_SciDoubleOrInt32_AsRect(pvApiCtx, $input, $1, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
}


