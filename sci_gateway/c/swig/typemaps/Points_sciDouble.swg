// OpenCV Points (vector<Point>) => Scilab double nx2

%fragment("SWIG_SciDouble_FromPoints", "header", fragment="SWIG_SciDouble_FromDoubleArrayAndSize") {

int SWIG_SciDouble_FromPoints(void *pvApiCtx, SwigSciObject iVarOut, Points *pPoints, char *fname) {
  int pointsCount = pPoints->size();
  double* pdValues = (double *) malloc(2 * pointsCount * sizeof(double));
  for (int i = 0; i < pointsCount; i++) {
    cv::Point pt = pPoints->at(i);
    pdValues[2*i] = pt.x;
    pdValues[2*i+1] = pt.y;
  }
  if (SWIG_SciDouble_FromDoubleArrayAndSize(pvApiCtx, iVarOut, 2, pointsCount, pdValues) != SWIG_OK) {
    return SWIG_ERROR;
  }
  return SWIG_OK;
}

}
