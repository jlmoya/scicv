// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

// OpenCV PtLists (vector<vector<cv::Point> >) <= Scilab mlist PtLists

%typemap(in, noblock=1) PtLists& ptListsIn {
  if (SwigScilabPtrToObject(pvApiCtx, $input, (void**)&$1, SWIG_Scilab_TypeQuery("PtLists *"), 0, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
}

