// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

// OpenCV Point** <= Scilab mlist Points or double nx2

%include PointPtr_sciDoubleOrListOfDouble.swg

%include PointPtr_PtLists.swg

%typemap(typecheck, precedence=SWIG_TYPECHECK_POINTER, fragment="SWIG_Check_SciDoubleOrListOfDouble") (cv::Point const **pts, const int *npts, int ncontours) {
  if (!($1 = SwigScilabCheckPtr(pvApiCtx, $input, SWIG_Scilab_TypeQuery("PtList *"), SWIG_Scilab_GetFuncName()))) {
    $1 = SWIG_Check_SciDoubleOrListOfDouble(pvApiCtx, $input, SWIG_Scilab_GetFuncName());
  }
}

%typemap(in, noblock=1, fragment="SWIG_SciDoubleOrListOfDouble_AsPointPtr,SWIG_PtLists_AsPointPtr") (cv::Point const **pts, const int *npts, int ncontours) {
  if (SWIG_PtLists_AsPointPtr(pvApiCtx, $input, &$1, &$2, &$3, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    if (SWIG_SciDoubleOrListOfDouble_AsPointPtr(pvApiCtx, $input, &$1, &$2, &$3, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
      return SWIG_ERROR;
    }
  }
}

%typemap(freearg, noblock=1) (cv::Point const **pts, const int *npts, int ncontours) {
  delete $1;
}
