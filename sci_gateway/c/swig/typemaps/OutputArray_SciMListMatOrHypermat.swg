// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT

// OpenCV _InputOutputArray <= Scilab MList Mat or hypermat

%include Mat_sciHypermat.swg

%fragment("SWIG_SciMListMatOrHypermat_AsOutputArray", "header", fragment="SWIG_SciHypermat_AsMat") {
int SWIG_SciMListMatOrHypermat_AsOutputArray(void *pvApiCtx, SwigSciObject iVar, cv::_InputOutputArray **pInputOutputArray, cv::Mat **pInOutMat, char *fname) {
  if (SwigScilabPtrToObject(pvApiCtx, iVar, (void**)pInOutMat, SWIG_Scilab_TypeQuery("cv::Mat *"), 0, fname) == SWIG_OK) {
    *pInputOutputArray = new cv::_InputOutputArray(*(*pInOutMat));
    return SWIG_OK;
  }
  else {
    if (SWIG_SciHypermat_AsMat(pvApiCtx, iVar, pInOutMat, fname) == SWIG_OK) {
      *pInputOutputArray = new cv::_InputOutputArray(*(*pInOutMat));
      return SWIG_OK;
    }
    else {
      return SWIG_ERROR;
    }
  }
}
}
