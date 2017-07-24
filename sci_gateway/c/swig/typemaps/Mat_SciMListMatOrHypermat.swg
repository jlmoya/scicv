// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

// OpenCV Mat <= Scilab MList Mat or hypermat

%include Mat_sciHypermat.swg

%fragment("SWIG_SciMListMatOrHypermat_AsMat", "header", fragment="SWIG_SciHypermat_AsMat") {
int SWIG_SciMListMatOrHypermat_AsMat(void *pvApiCtx, SwigSciObject iVar, cv::Mat **pInMat, int *iNewMat, char *fname) {
  if (SwigScilabPtrToObject(pvApiCtx, iVar, (void**)pInMat, SWIG_Scilab_TypeQuery("cv::Mat *"), 0, fname) == SWIG_OK) {
    *iNewMat = 0;
    return SWIG_OK;
  }
  else {
    if (SWIG_SciHypermat_AsMat(pvApiCtx, iVar, pInMat, fname) == SWIG_OK) {
      *iNewMat = 1;
      return SWIG_OK;
    }
    else {
      return SWIG_ERROR;
    }
  }
}
}
