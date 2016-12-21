// OpenCV InputArray <= Scilab MList Mat or hypermat

%include Mat_sciHypermat.swg

%fragment("SWIG_SciMListMatOrHypermat_AsInputArray", "header", fragment="SWIG_SciHypermat_AsMat") {
int SWIG_SciMListMatOrHypermat_AsInputArray(void *pvApiCtx, SwigSciObject iVar, cv::_InputArray **pInputArray, char *fname) {
  cv::Mat *pInMat$input = NULL;
  cv::Mat inMat$input;
  if (SwigScilabPtrToObject(pvApiCtx, iVar, (void**)&pInMat$input, SWIG_Scilab_TypeQuery("cv::Mat *"), 0, fname) == SWIG_OK) {
    *pInputArray = new cv::_InputArray(*pInMat$input);
  }
  else {
    if (SWIG_SciHypermat_AsMat(pvApiCtx, iVar, &inMat$input, fname) == SWIG_OK) {
      *pInputArray = new cv::_InputArray(inMat$input);
    }
    else {
      return SWIG_ERROR;
    }
  }
}
}
