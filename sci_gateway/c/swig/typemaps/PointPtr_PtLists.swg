// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

// OpenCV PtLists (std::vector<<vector<cv::Point>>) => OpenCV Point**

%fragment("SWIG_PtLists_AsPointPtr", "header") {

int SWIG_PtLists_AsPointPtr(void *pvApiCtx, SwigSciObject iVar, cv::Point ***pPoints, int **piPointCount, int *piContourCount, char *fname) {
  std::vector<std::vector<cv::Point> > *pPtLists = NULL;
  if (SwigScilabPtrToObject(pvApiCtx, iVar, (void**)&pPtLists, SWIG_Scilab_TypeQuery("PtLists *"), 0, SWIG_Scilab_GetFuncName()) == SWIG_OK) {
    *piContourCount = pPtLists->size();
    *piPointCount = (int*) malloc(pPtLists->size() * sizeof(int));
    *pPoints = (cv::Point**) malloc(pPtLists->size() * sizeof(cv::Point*));
    for (int i=0; i<pPtLists->size(); i++) {
      std::vector<cv::Point> pPtList = pPtLists->at(i);
      (*piPointCount)[i] = pPtList.size();
      (*pPoints)[i] = (cv::Point*) malloc(pPtList.size() * sizeof(cv::Point));
      for (int j=0; j<pPtList.size(); j++) {
        (*pPoints)[i][j] = pPtList[j];
      }
    }
    return SWIG_OK;
  }
  else {
    return SWIG_ERROR;
  }
}

}
