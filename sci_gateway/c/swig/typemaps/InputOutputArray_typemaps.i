// OpenCV InputOutputArray <=> Scilab mlist _p_cv_Mat

%include Mat_sciMList.swg
%include Mat_sciHypermat.swg

%typemap(typecheck, fragment="SWIG_SciMList_AsMat,SWIG_SciHypermat_AsMat", precedence=SWIG_TYPECHECK_POINTER) cv::InputOutputArray {
  cv::Mat *pMat = NULL;
  if (SWIG_SciMList_AsMat(pvApiCtx, $input, &pMat, SWIG_Scilab_GetFuncName()) == SWIG_OK) {
    $1 = 1;
  }
  else {
    cv::Mat mat;
    $1 = (SWIG_SciHypermat_AsMat(pvApiCtx, $input, &mat, SWIG_Scilab_GetFuncName()) == SWIG_OK);
  }
}

%typemap(in, noblock=1, fragment="SWIG_SciMList_AsMat,SWIG_SciHypermat_AsMat") cv::InputOutputArray {
  cv::Mat *pInMat$argnum = NULL;
  cv::Mat inMat$argnum;
  if (SWIG_SciMList_AsMat(pvApiCtx, $input, &pInMat$argnum, SWIG_Scilab_GetFuncName()) == SWIG_OK) {
    $1 = new cv::_OutputArray(*pInMat$argnum);
  }
  else {
    if (SWIG_SciHypermat_AsMat(pvApiCtx, $input, &inMat$argnum, SWIG_Scilab_GetFuncName()) == SWIG_OK) {
      $1 = new cv::_OutputArray(inMat$argnum);
    }
    else {
      return SWIG_ERROR;
    }
  }
}

%typemap(arginit, noblock=1) cv::InputOutputArray {
}

%typemap(argout, noblock=1, fragment="SWIG_SciMList_FromMat") cv::InputOutputArray {
  if (SWIG_SciMList_FromMat(pvApiCtx, SWIG_Scilab_GetOutputPosition(), &inMat$argnum, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
  SWIG_Scilab_SetOutput(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + SWIG_Scilab_GetOutputPosition());
}

%typemap(freearg, noblock=1) cv::InputOutputArray {
  delete $1;
}
