// OpenCV InputArray <= Scilab mlist _p_cv_Mat
//                   => Scilab hypermat

%typemap(in, noblock=1) cv::Mat& matIn {
  if (SwigScilabPtrToObject(pvApiCtx, $input, (void**)&$1, SWIG_TypeQuery("cv::Mat *"), 0, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
}

%typemap(in, numinputs=0, noblock=1) cv::Mat* matOut (cv::Mat tmpMat) {
    $1 = &tmpMat;
}

%typemap(argout, noblock=1, fragment="SWIG_SciHypermat_FromMat") cv::Mat* matOut {
  if (SWIG_SciHypermat_FromMat(pvApiCtx, SWIG_Scilab_GetOutputPosition(), $1, SWIG_Scilab_GetFuncName()) == SWIG_OK) {
    SWIG_Scilab_SetOutput(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + SWIG_Scilab_GetOutputPosition());
  }
  else {
    return SWIG_ERROR;
  }
}
