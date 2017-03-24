// Scilab Computer Vision Toolbox
// Copyright (C) 2017 - Scilab Enterprises

// OpenCV vector<cv::Point> (PtList) => Scilab double matrix

%include PtList_sciDouble.swg

%typemap(in, noblock=1) PtList& ptListIn {
  if (SwigScilabPtrToObject(pvApiCtx, $input, (void**)&$1, SWIG_Scilab_TypeQuery("PtList *"), 0, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
}

%typemap(in, numinputs=0, noblock=1) PtList* ptListOut  {
}

%typemap(arginit, noblock=1) PtList* ptListOut (PtList tmpPtList) {
  $1 = &tmpPtList;
}

%typemap(argout, noblock=1, fragment="SWIG_SciDouble_FromPtList") PtList* ptListOut {
  if (SWIG_SciDouble_FromPtList(pvApiCtx, SWIG_Scilab_GetOutputPosition(), $1, SWIG_Scilab_GetFuncName()) == SWIG_OK) {
    SWIG_Scilab_SetOutput(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + SWIG_Scilab_GetOutputPosition());
  }
  else {
    return SWIG_ERROR;
  }
}

// OpenCV PtList (vector<cv::Point>) => Scilab MList PtList

%typemap(in, numinputs=0, noblock=1) PtList* {
}

%typemap(arginit, noblock=1) PtList* {
  $1 = new std::vector<cv::Point>();
}

%typemap(argout, noblock=1) PtList* {
  if (SwigScilabPtrFromObject(pvApiCtx, SWIG_Scilab_GetOutputPosition(), $1, SWIG_Scilab_TypeQuery("PtList *"), 0, "PtList") == SWIG_OK) {
    SWIG_Scilab_SetOutput(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + SWIG_Scilab_GetOutputPosition());
  }
  else {
    return SWIG_ERROR;
  }
}

