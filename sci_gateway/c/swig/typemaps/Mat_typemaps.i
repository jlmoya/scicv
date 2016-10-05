// OpenCV Mat& matIn <= Scilab mlist Mat

%typemap(in, noblock=1) cv::Mat& matIn {
  if (SwigScilabPtrToObject(pvApiCtx, $input, (void**)&$1, SWIG_Scilab_TypeQuery("cv::Mat *"), 0, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
}

%typemap(argout) cv::Mat& matIn;

// OpenCV Mat* hypermatOut => Scilab hypermat

%typemap(in, numinputs=0, noblock=1) cv::Mat* hypermatOut (cv::Mat tmpMat) {
    $1 = &tmpMat;
}

%typemap(argout, noblock=1, fragment="SWIG_SciHypermat_FromMat") cv::Mat* hypermatOut {
  if (SWIG_SciHypermat_FromMat(pvApiCtx, SWIG_Scilab_GetOutputPosition(), $1, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
  SWIG_Scilab_SetOutput(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + SWIG_Scilab_GetOutputPosition());
}


// OpenCV Mat* matOut => Scilab mlist Mat

%typemap(in, numinputs=0, noblock=1) cv::Mat* matOut (cv::Mat tmpMat) {
    $1 = new cv::Mat();
}

%typemap(argout, noblock=1) cv::Mat* matOut {
  if (SwigScilabPtrFromObject(pvApiCtx, SWIG_Scilab_GetOutputPosition(), $1, SWIG_Scilab_TypeQuery("cv::Mat *"), 0, "Mat") != SWIG_OK) {
    return SWIG_ERROR;
  }
  // TOTO
  SWIG_Scilab_SetOutput(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + SWIG_Scilab_GetOutputPosition());
}


// OpenCV return Mat => Scilab mlist Mat

%typemap(out, noblock=1) cv::Mat {
  if (SwigScilabPtrFromObject(pvApiCtx, SWIG_Scilab_GetOutputPosition(), new cv::Mat(result), SWIG_Scilab_TypeQuery("cv::Mat *"), 0, "Mat") != SWIG_OK) {
    return SWIG_ERROR;
  }
  SWIG_Scilab_SetOutput(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + SWIG_Scilab_GetOutputPosition());
}

%typemap(out, noblock=1) cv::Mat* {
  if (SwigScilabPtrFromObject(pvApiCtx, SWIG_Scilab_GetOutputPosition(), result, SWIG_Scilab_TypeQuery("cv::Mat *"), 0, "Mat") != SWIG_OK) {
    return SWIG_ERROR;
  }
  SWIG_Scilab_SetOutput(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + SWIG_Scilab_GetOutputPosition());
}
