%include Point_SciDouble.swg

// OpenCV Point <= Scilab double 1x2

// TODO: fix precedence
%typemap(typecheck, precedence=SWIG_TYPECHECK_DOUBLE, fragment="SWIG_SciDoubleOrInt32_AsPoint") cv::Point, cv::Point& {
  cv::Point point;
  $1 = SWIG_SciDoubleOrInt32_AsPoint(pvApiCtx, $input, &point, SWIG_Scilab_GetFuncName()) == SWIG_OK ? 1 : 0;
}

%typemap(in, noblock=1, fragment="SWIG_SciDoubleOrInt32_AsPoint") cv::Point {
  if (SWIG_SciDoubleOrInt32_AsPoint(pvApiCtx, $input, &$1, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
}

// OpenCV Point => Scilab double 1x2
%typemap(in, numinputs=0, noblock=1) cv::Point* {
}

%typemap(arginit, noblock=1) cv::Point* (cv::Point tmpPoint) {
  $1 = &tmpPoint;
}

%typemap(argout, noblock=1, fragment="SWIG_SciDouble_FromPoint") cv::Point* {
  if (SWIG_SciDouble_FromPoint(pvApiCtx, SWIG_Scilab_GetOutputPosition(), $1, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
  SWIG_Scilab_SetOutput(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + SWIG_Scilab_GetOutputPosition());
}

