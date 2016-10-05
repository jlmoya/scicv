// OpenCV OutputArrayOfArrays => Scilab mlist VecPoints

%typemap(in, numinputs=0, noblock=1) cv::OutputArrayOfArrays contours {
}

%typemap(arginit, noblock=1) cv::OutputArrayOfArrays contours {
  VectorPoints *pContours$argnum = new std::vector<std::vector<cv::Point> >();
  $1 = new cv::_OutputArray(*pContours$argnum);
}

%typemap(argout, noblock=1) cv::OutputArrayOfArrays contours {
  if (SwigScilabPtrFromObject(pvApiCtx, SWIG_Scilab_GetOutputPosition(), pContours$argnum, SWIG_Scilab_TypeQuery("VectorPoints *"), 0, "VecPoints") != SWIG_OK) {
    return SWIG_ERROR;
  }
  SWIG_Scilab_SetOutput(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + SWIG_Scilab_GetOutputPosition());
}

%typemap(freearg, noblock=1) cv::OutputArrayOfArrays contours {
  delete $1;
}
