// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

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

%typemap(typecheck, fragment="SWIG_Check_SciHypermat", precedence = SWIG_TYPECHECK_POINTER) cv::InputArray {
  if (!($1 = SwigScilabCheckPtr(pvApiCtx, $input, SWIG_Scilab_TypeQuery("cv::Mat *"), SWIG_Scilab_GetFuncName()))) {
    cv::Mat *pMat = NULL;
    $1 = SWIG_Check_SciHypermat(pvApiCtx, $input, SWIG_Scilab_GetFuncName());
  }
}

%include Mat_SciMListMatOrHypermat.swg

%typemap(in, noblock=1, fragment="SWIG_SciMListMatOrHypermat_AsMat") cv::InputArray  {
  cv::Mat *pMat$1_name = NULL;
  int iNewMat$1_name = 0;
  if (SWIG_SciMListMatOrHypermat_AsMat(pvApiCtx, $input, &pMat$1_name, &iNewMat$1_name, SWIG_Scilab_GetFuncName()) == SWIG_OK) {
	  $1 = new cv::_InputArray(*pMat$1_name);
  }
  else {
    return SWIG_ERROR;
	}
}

%typemap(freearg, noblock=1) cv::InputArray {
  if (iNewMat$1_name) {
    pMat$1_name->release();
  }
  delete $1;
}
