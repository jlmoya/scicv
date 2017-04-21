// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

// OpenCV KeyPoints (vector<KeyPoint>) => Scilab double matrix

%include KeyPoints_sciKeyPoints.swg

%typemap(in, noblock=1) KeyPoints& keyPointsIn {
  if (SwigScilabPtrToObject(pvApiCtx, $input, (void**)&$1, SWIG_Scilab_TypeQuery("KeyPoints *"), 0, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
}

%typemap(in, numinputs=0, noblock=1) KeyPoints* keyPointsMatrixOut  {
}

%typemap(arginit, noblock=1) KeyPoints* keyPointsMatrixOut (KeyPoints tmpKeyPoints) {
  $1 = &tmpKeyPoints;
}

%typemap(argout, noblock=1, fragment="SWIG_SciKeyPoints_FromKeyPoints") KeyPoints* keyPointsMatrixOut {
  if (SWIG_SciKeyPoints_FromKeyPoints(pvApiCtx, SWIG_Scilab_GetOutputPosition(), $1, SWIG_Scilab_GetFuncName()) == SWIG_OK) {
    SWIG_Scilab_SetOutput(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + SWIG_Scilab_GetOutputPosition());
  }
  else {
    return SWIG_ERROR;
  }
}

// OpenCV KeyPoints (vector<KeyPoint>) => Scilab MList KeyPoints

%typemap(in, numinputs=0, noblock=1) KeyPoints* {
}

%typemap(arginit, noblock=1) KeyPoints* {
  $1 = new std::vector<cv::KeyPoint>();
}

%typemap(argout, noblock=1) KeyPoints* {
  if (SwigScilabPtrFromObject(pvApiCtx, SWIG_Scilab_GetOutputPosition(), $1, SWIG_Scilab_TypeQuery("KeyPoints *"), 0, "KeyPoints") == SWIG_OK) {
    SWIG_Scilab_SetOutput(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + SWIG_Scilab_GetOutputPosition());
  }
  else {
    return SWIG_ERROR;
  }
}


