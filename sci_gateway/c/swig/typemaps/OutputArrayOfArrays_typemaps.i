// OpenCV OutputArrayOfArrays => Scilab mlist PtLists

%typemap(in, numinputs=0, noblock=1) cv::OutputArrayOfArrays contours {
}

%typemap(arginit, noblock=1) cv::OutputArrayOfArrays contours {
  PtLists *pPtLists$argnum = new std::vector<std::vector<cv::Point> >();
  $1 = new cv::_OutputArray(*pPtLists$argnum);
}

%typemap(argout, noblock=1) cv::OutputArrayOfArrays contours {
  if (SwigScilabPtrFromObject(pvApiCtx, SWIG_Scilab_GetOutputPosition(), pPtLists$argnum, SWIG_Scilab_TypeQuery("PtLists *"), 0, "PtLists") != SWIG_OK) {
    return SWIG_ERROR;
  }
  SWIG_Scilab_SetOutput(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + SWIG_Scilab_GetOutputPosition());
}

%typemap(freearg, noblock=1) cv::OutputArrayOfArrays contours {
  delete $1;
}
