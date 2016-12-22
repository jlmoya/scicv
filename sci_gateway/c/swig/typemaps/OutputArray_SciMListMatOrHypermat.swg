// OpenCV OutputArray <= Scilab MList Mat or hypermat

%include Mat_sciHypermat.swg

%fragment("SWIG_SciMListMatOrHypermat_AsOutputArray", "header", fragment="SWIG_SciHypermat_AsMat") {
int SWIG_SciMListMatOrHypermat_AsOutputArray(void *pvApiCtx, SwigSciObject iVar, cv::_OutputArray **pOutputArray, cv::Mat **pInOutMat, char *fname) {
  if (SwigScilabPtrToObject(pvApiCtx, iVar, (void**)pInOutMat, SWIG_Scilab_TypeQuery("cv::Mat *"), 0, fname) == SWIG_OK) {
    *pOutputArray = new cv::_OutputArray(*(*pInOutMat));
    return SWIG_OK;
  }
  else {
    if (SWIG_SciHypermat_AsMat(pvApiCtx, iVar, pInOutMat, fname) == SWIG_OK) {
      *pOutputArray = new cv::_OutputArray(*(*pInOutMat));
      return SWIG_OK;
    }
    else {
      return SWIG_ERROR;
    }
  }
}
}
