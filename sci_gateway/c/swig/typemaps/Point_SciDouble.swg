// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

%fragment("SWIG_SciDoubleOrInt32_AsPoint", "header", fragment ="SWIG_SciDoubleOrInt32_AsIntArrayAndSize") {

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

}


%fragment("SWIG_SciDouble_FromPoint", "header", fragment="SWIG_SciDouble_FromDoubleArrayAndSize") {

int SWIG_SciDouble_FromPoint(void *pvApiCtx, SwigSciObject iVarOut, cv::Point *pPoint, char *fname) {
  double pdValues[2];
  pdValues[0] = pPoint->x;
  pdValues[1] = pPoint->y;
  if (SWIG_SciDouble_FromDoubleArrayAndSize(pvApiCtx, iVarOut, 1, 2, pdValues) != SWIG_OK) {
    return SWIG_ERROR;
  }
  return SWIG_OK;
}

}
