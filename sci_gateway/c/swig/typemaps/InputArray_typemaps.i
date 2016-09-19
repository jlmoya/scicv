// OpenCV InputArray <= Scilab mlist _p_cv_Mat

%include Mat_sciMList.swg
%include Mat_sciHypermat.swg

%typemap(typecheck, fragment="SWIG_SciMList_AsMat,SWIG_SciHypermat_AsMat", precedence=SWIG_TYPECHECK_POINTER) cv::InputArray {
  cv::Mat *pMat = NULL;  
  if (SWIG_SciMList_AsMat(pvApiCtx, $input, &pMat, SWIG_Scilab_GetFuncName()) == SWIG_OK) {
    $1 = 1;
  } 
  else {
    cv::Mat mat;
    $1 = (SWIG_SciHypermat_AsMat(pvApiCtx, $input, &mat, SWIG_Scilab_GetFuncName()) == SWIG_OK);      
  }
}

%typemap(in, noblock=1, fragment="SWIG_SciMList_AsMat,SWIG_SciHypermat_AsMat") cv::InputArray {
  cv::Mat *pInMat$input = NULL;
  cv::Mat inMat$input;
  if (SWIG_SciMList_AsMat(pvApiCtx, $input, &pInMat$input, SWIG_Scilab_GetFuncName()) == SWIG_OK) {
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
