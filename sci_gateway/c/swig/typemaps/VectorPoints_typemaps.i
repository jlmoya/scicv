// OpenCV VectorPoints => Scilab matrix list

%include VectorPoints_sciMatrixList.swg

%typemap(in, noblock=1) VectorPoints& vectorPointsIn {
  if (SwigScilabPtrToObject(pvApiCtx, $input, (void**)&$1, SWIG_Scilab_TypeQuery("VectorPoints *"), 0, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
}

%typemap(in, numinputs=0, noblock=1) VectorPoints* vectorPointsOut (VectorPoints tmpVectorPoints) {
    $1 = &tmpVectorPoints;
}

%typemap(argout, noblock=1, fragment="SWIG_SciMatrixList_FromVectorPoints") VectorPoints* vectorPointsOut {
  if (SWIG_SciMatrixList_FromVectorPoints(pvApiCtx, SWIG_Scilab_GetOutputPosition(), $1, SWIG_Scilab_GetFuncName()) == SWIG_OK) {
    SWIG_Scilab_SetOutput(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + SWIG_Scilab_GetOutputPosition());
  }
  else {
    return SWIG_ERROR;
  }
}
