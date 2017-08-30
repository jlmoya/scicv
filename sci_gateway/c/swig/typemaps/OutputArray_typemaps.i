// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

// OpenCV OutputArray linesPolarCoordinates => Scilab double nx2

%include VectorVec2f_SciDouble.swg

%typemap(in, numinputs=0, noblock=1) cv::OutputArray linesPolarCoordinates {
}

%typemap(arginit, noblock=1) cv::OutputArray linesPolarCoordinates {
  std::vector<Vec2f> *pOutVector$argnum = new std::vector<Vec2f>();
  $1 = new cv::_OutputArray(*pOutVector$argnum);
}

%typemap(argout, noblock=1, fragment="SWIG_SciDouble_FromVectorVec2f") cv::OutputArray linesPolarCoordinates {
  if (SWIG_SciDouble_FromVectorVec2f(pvApiCtx, SWIG_Scilab_GetOutputPosition(), pOutVector$argnum, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
  SWIG_Scilab_SetOutput(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + SWIG_Scilab_GetOutputPosition());
}

%typemap(freearg, noblock=1) cv::OutputArray linesPolarCoordinates{
  delete $1;
  delete pOutVector$argnum;
}

// OpenCV OutputArray linesCartesianCoordinates => Scilab double nx2

%include VectorVec4i_SciDouble.swg

%typemap(in, numinputs=0, noblock=1) cv::OutputArray linesCartesianCoordinates {
}

%typemap(arginit, noblock=1) cv::OutputArray linesCartesianCoordinates {
  std::vector<Vec4i> *pOutVector$argnum = new std::vector<Vec4i>();
  $1 = new cv::_OutputArray(*pOutVector$argnum);
}

%typemap(argout, noblock=1, fragment="SWIG_SciDouble_FromVectorVec4i") cv::OutputArray linesCartesianCoordinates {
  if (SWIG_SciDouble_FromVectorVec4i(pvApiCtx, SWIG_Scilab_GetOutputPosition(), pOutVector$argnum, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
  SWIG_Scilab_SetOutput(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + SWIG_Scilab_GetOutputPosition());
}

%typemap(freearg, noblock=1) cv::OutputArray linesCartesianCoordinates{
  delete $1;
  delete pOutVector$argnum;
}

// OpenCV OutputArray => Scilab mlist Mat

%typemap(in, numinputs=0, noblock=1) cv::OutputArray {
}

%typemap(arginit, noblock=1) cv::OutputArray {
  cv::Mat *pOutMat$argnum = new Mat();
  $1 = new cv::_OutputArray(*pOutMat$argnum);
}

%typemap(argout, noblock=1) cv::OutputArray {
  if (SwigScilabPtrFromObject(pvApiCtx, SWIG_Scilab_GetOutputPosition(), pOutMat$argnum, SWIG_Scilab_TypeQuery("cv::Mat *"), 0, "Mat") != SWIG_OK) {
    return SWIG_ERROR;
  }
  SWIG_Scilab_SetOutput(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + SWIG_Scilab_GetOutputPosition());
}

%typemap(freearg, noblock=1) cv::OutputArray {
  delete $1;
}

