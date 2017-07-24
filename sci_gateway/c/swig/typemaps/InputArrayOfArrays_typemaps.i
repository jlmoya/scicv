// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

// OpenCV InputArrayOfArrays <= Scilab mlist PtLists

%typemap(typecheck, precedence=SWIG_TYPECHECK_POINTER) cv::InputArrayOfArrays contours {
  $1 = SwigScilabCheckPtr(pvApiCtx, $input, SWIG_Scilab_TypeQuery("PtLists *"), SWIG_Scilab_GetFuncName());
}

%typemap(in, noblock=1) cv::InputArrayOfArrays contours (PtLists *ptLists) {
	ptLists = new std::vector<std::vector<cv::Point> >();
  if (SwigScilabPtrToObject(pvApiCtx, $input, (void**)&ptLists, SWIG_Scilab_TypeQuery("PtLists *"), 0, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
  $1 = new cv::_InputArray(*ptLists);
}

%typemap(freearg, noblock=1) cv::InputArrayOfArrays contours {
}

