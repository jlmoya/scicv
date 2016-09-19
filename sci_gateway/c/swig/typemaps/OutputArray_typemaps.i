// OpenCV OutputArray => Scilab mlist _p_cv_Mat

%include Mat_sciMList.swg

%typemap(in, numinputs=0, noblock=1) cv::OutputArray {
}

%typemap(arginit, noblock=1) cv::OutputArray {
  cv::Mat *outputMat$argnum = new Mat();
  $1 = new cv::_OutputArray(*outputMat$argnum);
}

%typemap(argout, noblock=1, fragment="SWIG_SciMList_FromMat") cv::OutputArray {
  if (SWIG_SciMList_FromMat(pvApiCtx, SWIG_Scilab_GetOutputPosition(), outputMat$argnum, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
  SWIG_Scilab_SetOutput(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + SWIG_Scilab_GetOutputPosition());
}

%typemap(freearg, noblock=1) cv::OutputArray {
  delete $1;
}
