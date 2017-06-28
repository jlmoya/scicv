// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

// OpenCV Mat* <= Scilab Mat list / single Mat

%include MatPtr_sciMatList.swg

// TODO: fix precedence
%typemap(typecheck, fragment="SWIG_SciMatList_AsMatPtr", precedence=SWIG_TYPECHECK_POINTER) (const cv::Mat* images, int nimages) {
  if (!($1 = SwigScilabCheckPtr(pvApiCtx, $input, SWIG_Scilab_TypeQuery("cv::Mat *"), SWIG_Scilab_GetFuncName()))) {
    cv::Mat *pMat = NULL;
    if (!($1 = SWIG_SciHypermat_AsMat(pvApiCtx, $input, &pMat, SWIG_Scilab_GetFuncName())) == SWIG_OK) {
      cv::Mat *pMatArray = NULL;
      int iMatArrayCount = 0;
      $1 = (SWIG_SciMatList_AsMatPtr(pvApiCtx, $input, &pMatArray, &iMatArrayCount, SWIG_Scilab_GetFuncName()) == SWIG_OK);
    }
  }
}

%typemap(in, noblock=1, fragment="SWIG_SciMatList_AsMatPtr") (const cv::Mat* images, int nimages) {
  if (SwigScilabPtrToObject(pvApiCtx, $input, (void**)&$1, SWIG_Scilab_TypeQuery("cv::Mat *"), 0, fname) == SWIG_OK) {
    $2 = 1;
  } else if (SWIG_SciHypermat_AsMat(pvApiCtx, $input, &$1, SWIG_Scilab_GetFuncName()) == SWIG_OK) {
    $2 = 1;
  } else if (SWIG_SciMatList_AsMatPtr(pvApiCtx, $input, &$1, &$2, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
}


