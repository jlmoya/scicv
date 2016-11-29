// OpenCV PtLists (vector<vector<cv::Point> >) <= Scilab mlist PtLists

%typemap(in, noblock=1) PtLists& ptListsIn {
  if (SwigScilabPtrToObject(pvApiCtx, $input, (void**)&$1, SWIG_Scilab_TypeQuery("PtLists *"), 0, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
}

// OpenCV PtLists (vector<vector<cv::Point> >) => Scilab matrix list

%include PtLists_sciMatrixList.swg

%typemap(in, numinputs=0, noblock=1) PtLists* ptListsOut (PtLists tmpPtLists) {
    $1 = &tmpPtLists;
}

%typemap(argout, noblock=1, fragment="SWIG_SciMatrixList_FromPtLists") PtLists* ptListsOut {
  if (SWIG_SciMatrixList_FromPtLists(pvApiCtx, SWIG_Scilab_GetOutputPosition(), $1, SWIG_Scilab_GetFuncName()) == SWIG_OK) {
    SWIG_Scilab_SetOutput(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + SWIG_Scilab_GetOutputPosition());
  }
  else {
    return SWIG_ERROR;
  }
}
