// OpenCV InputArray contour, points <= Scilab mlist Points

%typemap(typecheck, precedence=SWIG_TYPECHECK_POINTER) cv::InputArray points {
  $1 = SwigScilabCheckPtr(pvApiCtx, $input, SWIG_Scilab_TypeQuery("PtList *"), SWIG_Scilab_GetFuncName());
}

%typemap(in, noblock=1) cv::InputArray points {
  PtList *pInPtList$input = NULL;
  if (SwigScilabPtrToObject(pvApiCtx, $input, (void**)&pInPtList$input, SWIG_Scilab_TypeQuery("PtList *"), 0, SWIG_Scilab_GetFuncName()) == SWIG_OK) {
    $1 = new cv::_InputArray(*pInPtList$input);
  }
  else {
    return SWIG_ERROR;
  }
}

%typemap(freearg, noblock=1) cv::InputArray points {
  delete $1;
}

// OpenCV InputArray <= Scilab mlist Mat or hypermat

%typemap(typecheck, fragment="SWIG_SciHypermat_AsMat", precedence=SWIG_TYPECHECK_POINTER) cv::InputArray {
  if (!($1 = SwigScilabCheckPtr(pvApiCtx, $input, SWIG_Scilab_TypeQuery("cv::Mat *"), SWIG_Scilab_GetFuncName()))) {
    cv::Mat mat;
    $1 = (SWIG_SciHypermat_AsMat(pvApiCtx, $input, &mat, SWIG_Scilab_GetFuncName()) == SWIG_OK);
  }
}

%include InputArray_SciMListMatOrHypermat.swg

%typemap(in, noblock=1, fragment="SWIG_SciMListMatOrHypermat_AsInputArray") cv::InputArray {
  if (SWIG_SciMListMatOrHypermat_AsInputArray(pvApiCtx, $input, &$1, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
	  return SWIG_ERROR;
	}
}

%typemap(freearg, noblock=1) cv::InputArray {
  delete $1;
}
