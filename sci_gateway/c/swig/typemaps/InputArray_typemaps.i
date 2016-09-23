// OpenCV InputArray contour, points <= Scilab mlist contours

%typemap(typecheck, precedence=SWIG_TYPECHECK_POINTER) cv::InputArray points {
  $1 = SwigScilabCheckPtr(pvApiCtx, $input, SWIG_TypeQuery("Points *"), SWIG_Scilab_GetFuncName());
}

%typemap(in, noblock=1) cv::InputArray points {
  Points *pInPoints$input = NULL;
  if (SwigScilabPtrToObject(pvApiCtx, $input, (void**)&pInPoints$input, SWIG_TypeQuery("Points *"), 0, SWIG_Scilab_GetFuncName()) == SWIG_OK) {
    $1 = new cv::_InputArray(*pInPoints$input);
  }
  else {
    return SWIG_ERROR;
  }
}

%typemap(freearg, noblock=1) cv::InputArray points {
  delete $1;
}

// OpenCV InputArray <= Scilab mlist _p_cv_Mat or hypermat

%include Mat_sciHypermat.swg

%typemap(typecheck, fragment="SWIG_SciHypermat_AsMat", precedence=SWIG_TYPECHECK_POINTER) cv::InputArray {
  if (!($1 = SwigScilabCheckPtr(pvApiCtx, $input, SWIG_TypeQuery("cv::Mat *"), SWIG_Scilab_GetFuncName()))) {
    cv::Mat mat;
    $1 = (SWIG_SciHypermat_AsMat(pvApiCtx, $input, &mat, SWIG_Scilab_GetFuncName()) == SWIG_OK);
  }
}

%typemap(in, noblock=1, fragment="SWIG_SciHypermat_AsMat") cv::InputArray {
  cv::Mat *pInMat$input = NULL;
  cv::Mat inMat$input;
  if (SwigScilabPtrToObject(pvApiCtx, $input, (void**)&pInMat$input, SWIG_TypeQuery("cv::Mat *"), 0, SWIG_Scilab_GetFuncName()) == SWIG_OK) {
    $1 = new cv::_InputArray(*pInMat$input);
  }
  else {
    if (SWIG_SciHypermat_AsMat(pvApiCtx, $input, &inMat$input, SWIG_Scilab_GetFuncName()) == SWIG_OK) {
      $1 = new cv::_InputArray(inMat$input);
    }
    else {
      return SWIG_ERROR;
    }
  }
}

%typemap(freearg, noblock=1) cv::InputArray {
  delete $1;
}
