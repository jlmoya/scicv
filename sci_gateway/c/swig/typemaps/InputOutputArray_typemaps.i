// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT

// OpenCV InputOutputArray <= Scilab mlist Mat or hypermat
//                         => Scilab mlist Mat

%include Mat_sciHypermat.swg

%typemap(typecheck, fragment="SWIG_SciHypermat_AsMat", precedence=SWIG_TYPECHECK_POINTER) cv::InputOutputArray {
  if (!($1 = SwigScilabCheckPtr(pvApiCtx, $input, SWIG_Scilab_TypeQuery("cv::Mat *"), SWIG_Scilab_GetFuncName()))) {
    cv::Mat *pMat = NULL;
    $1 = (SWIG_SciHypermat_AsMat(pvApiCtx, $input, &pMat, SWIG_Scilab_GetFuncName()) == SWIG_OK);
  }
}

%include OutputArray_SciMListMatOrHypermat.swg

%typemap(in, noblock=1, fragment="SWIG_SciMListMatOrHypermat_AsOutputArray") cv::InputOutputArray {
  cv::Mat *pInOutMat$argnum = NULL;
  if (SWIG_SciMListMatOrHypermat_AsOutputArray(pvApiCtx, $input, &$1, &pInOutMat$argnum, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
	  return SWIG_ERROR;
	}
}

%typemap(arginit, noblock=1) cv::InputOutputArray {
}

%typemap(argout, noblock=1) cv::InputOutputArray {
  if (SwigScilabPtrFromObject(pvApiCtx, SWIG_Scilab_GetOutputPosition(), pInOutMat$argnum, SWIG_Scilab_TypeQuery("cv::Mat *"), 0, "Mat") != SWIG_OK) {
    return SWIG_ERROR;
  }
  SWIG_Scilab_SetOutput(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + SWIG_Scilab_GetOutputPosition());
}

%typemap(freearg, noblock=1) cv::InputOutputArray {
  delete $1;
}

// Special case for functions such as normalize, ... in core.hpp where "cv::InputOutputArray dst" is only an output
%typemap(in, numinputs=0, noblock=1) cv::InputOutputArray dst {
  cv::Mat *pInOutMat$argnum = new cv::Mat();
  $1 = new cv::_InputOutputArray(*pInOutMat$argnum);
}
%typemap(argout, noblock=1, fragment="SWIG_SciMListMatOrHypermat_AsOutputArray") cv::InputOutputArray dst {
  if (SwigScilabPtrFromObject(pvApiCtx, SWIG_Scilab_GetOutputPosition(), pInOutMat$argnum, SWIG_Scilab_TypeQuery("cv::Mat *"), 0, "Mat") != SWIG_OK) {
    return SWIG_ERROR;
  }
  SWIG_Scilab_SetOutput(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + SWIG_Scilab_GetOutputPosition());
}

