// OpenCV Vector Vector of Points => Scilab matrix list

%fragment("SWIG_SciMatrixList_FromVectorPoints", "header") {

int SWIG_SciMatrixList_FromVectorPoints(void *pvApiCtx, SwigSciObject iVarOut, VectorPoints *pVectorPoints, char *fname) {
  SciErr sciErr;
  int *piListAddr = NULL;
  int vectorPointsCount = pVectorPoints->size();

  sciErr = createList(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + iVarOut, vectorPointsCount, &piListAddr);
  if (sciErr.iErr) {
    printError(&sciErr, 0);
    return SWIG_ERROR;
  }

  for (int i = 0; i < vectorPointsCount; i++) {
    Points points = pVectorPoints->at(i);
    int pointsCount = points.size();

    double *pdValues = (double *) malloc(2 * pointsCount * sizeof(double));
    for (int j = 0; j < pointsCount; j++) {
      cv::Point pt = points.at(j);
      pdValues[2*j] = pt.x;
      pdValues[2*j+1] = pt.y;
    }

    sciErr = createMatrixOfDoubleInList(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + iVarOut, piListAddr, i+1, 2, pointsCount, pdValues);
    if (sciErr.iErr) {
      printError(&sciErr, 0);
      return SWIG_ERROR;
    }
  }
  return SWIG_OK;
}

}

