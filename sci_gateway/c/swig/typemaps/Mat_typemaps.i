%typemap(in, noblock=1, fragment="SWIG_SciMList_AsMat") cv::Mat& matIn {
  if (SWIG_SciMList_AsMat(pvApiCtx, $input, &$1, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
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
