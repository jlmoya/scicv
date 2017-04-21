// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

// OpenCV PtList (<vector<cv::Point>) => Scilab double nx2

%fragment("SWIG_SciDouble_FromPtList", "header", fragment="SWIG_SciDouble_FromDoubleArrayAndSize") {

int SWIG_SciDouble_FromPtList(void *pvApiCtx, SwigSciObject iVarOut, PtList *pPtList, char *fname) {
  int ptListSize = (int) pPtList->size();
  double* pdValues = (double *) malloc(2 * ptListSize * sizeof(double));
  for (int i = 0; i < ptListSize; i++) {
    cv::Point pt = pPtList->at(i);
    pdValues[2*i] = pt.x;
    pdValues[2*i+1] = pt.y;
  }
  if (SWIG_SciDouble_FromDoubleArrayAndSize(pvApiCtx, iVarOut, 2, ptListSize, pdValues) != SWIG_OK) {
    return SWIG_ERROR;
  }
  free(pdValues);
  return SWIG_OK;
}

}
