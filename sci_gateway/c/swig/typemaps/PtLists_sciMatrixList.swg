// OpenCV PtLists (vector<vector<cv::Point> >) => Scilab matrix list

%fragment("SWIG_SciMatrixList_FromPtLists", "header") {

int SWIG_SciMatrixList_FromPtLists(void *pvApiCtx, SwigSciObject iVarOut, PtLists *pPtLists, char *fname) {
  SciErr sciErr;
  int *piListAddr = NULL;
  int ptListsCount = (int) pPtLists->size();

  sciErr = createList(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + iVarOut, ptListsCount, &piListAddr);
  if (sciErr.iErr) {
    printError(&sciErr, 0);
    return SWIG_ERROR;
  }

  for (int i = 0; i < ptListsCount; i++) {
    PtList ptList = pPtLists->at(i);
    int ptListSize = (int) ptList.size();

    double *pdValues = (double *) malloc(2 * ptListSize * sizeof(double));
    for (int j = 0; j < ptListSize; j++) {
      cv::Point pt = ptList.at(j);
      pdValues[2*j] = pt.x;
      pdValues[2*j+1] = pt.y;
    }

    sciErr = createMatrixOfDoubleInList(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + iVarOut, piListAddr, i+1, 2, ptListsCount, pdValues);
    if (sciErr.iErr) {
      printError(&sciErr, 0);
      return SWIG_ERROR;
    }
  }
  return SWIG_OK;
}

}

