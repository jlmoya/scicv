// OpenCV OutputArray => Scilab mlist Mat

%typemap(in, numinputs=0, noblock=1) cv::OutputArray {
}

%typemap(arginit, noblock=1) cv::OutputArray {
  cv::Mat *pOutMat$argnum = new Mat();
  $1 = new cv::_OutputArray(*pOutMat$argnum);
}

%typemap(argout, noblock=1) cv::OutputArray {
  if (SwigScilabPtrFromObject(pvApiCtx, SWIG_Scilab_GetOutputPosition(), pOutMat$argnum, SWIG_TypeQuery("cv::Mat *"), 0, "Mat") != SWIG_OK) {
    return SWIG_ERROR;
  }
  SWIG_Scilab_SetOutput(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + SWIG_Scilab_GetOutputPosition());
}

%typemap(freearg, noblock=1) cv::OutputArray {
  delete $1;
}
