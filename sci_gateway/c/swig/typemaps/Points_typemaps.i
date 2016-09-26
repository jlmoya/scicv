// OpenCV Points (vector<Point>) => Scilab double matrix

%include Points_sciDouble.swg

%typemap(in, noblock=1) Points& pointsIn {
  if (SwigScilabPtrToObject(pvApiCtx, $input, (void**)&$1, SWIG_TypeQuery("Points *"), 0, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
}

%typemap(in, numinputs=0, noblock=1) Points* pointsOut  {
}

%typemap(arginit, noblock=1) Points* pointsOut (Points tmpPoints) {
  $1 = &tmpPoints;
}

%typemap(argout, noblock=1, fragment="SWIG_SciDouble_FromPoints") Points* pointsOut {
  if (SWIG_SciDouble_FromPoints(pvApiCtx, SWIG_Scilab_GetOutputPosition(), $1, SWIG_Scilab_GetFuncName()) == SWIG_OK) {
    SWIG_Scilab_SetOutput(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + SWIG_Scilab_GetOutputPosition());
  }
  else {
    return SWIG_ERROR;
  }
}

// OpenCV Points (vector<Point>) => Scilab MList Points

%typemap(in, numinputs=0, noblock=1) Points* {
}

%typemap(arginit, noblock=1) Points* {
  $1 = new std::vector<cv::Point>();
}

%typemap(argout, noblock=1) Points* {
  if (SwigScilabPtrFromObject(pvApiCtx, SWIG_Scilab_GetOutputPosition(), $1, SWIG_TypeQuery("Points *"), 0, "Points") == SWIG_OK) {
    SWIG_Scilab_SetOutput(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + SWIG_Scilab_GetOutputPosition());
  }
  else {
    return SWIG_ERROR;
  }
}

