// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

// OpenCV MatExpr => Scilab mlist Mat

%typemap(out, noblock=1) cv::MatExpr {
  cv::Mat *outMat = new cv::Mat(result);
  if (SwigScilabPtrFromObject(pvApiCtx, SWIG_Scilab_GetOutputPosition(), outMat, SWIG_Scilab_TypeQuery("cv::Mat *"), 0, "Mat") != SWIG_OK) {
    return SWIG_ERROR;
  }
  SWIG_Scilab_SetOutput(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + SWIG_Scilab_GetOutputPosition());
}

