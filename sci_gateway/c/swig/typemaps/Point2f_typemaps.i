// Scilab Computer Vision Toolbox
// Copyright (C) 2017 - Scilab Enterprises

%include Point2f_SciDouble.swg

// OpenCV Point2f <= Scilab double 1x2

// TODO: fix precedence
%typemap(typecheck, precedence=SWIG_TYPECHECK_DOUBLE, fragment="SWIG_SciDouble_AsPoint2f") cv::Point2f, cv::Point2f& {
  cv::Point2f point2f;
  $1 = SWIG_SciDouble_AsPoint2f(pvApiCtx, $input, &point2f, SWIG_Scilab_GetFuncName()) == SWIG_OK ? 1 : 0;
}

%typemap(in, noblock=1, fragment="SWIG_SciDoubleOrInt32_AsPoint2f") cv::Point2f {
  if (SWIG_SciDouble_AsPoint2f(pvApiCtx, $input, &$1, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
}

// OpenCV Point2f => Scilab double 1x2
%typemap(in, numinputs=0, noblock=1) cv::Point2f* {
}

%typemap(arginit, noblock=1) cv::Point2f* (cv::Point2f tmpPoint2f) {
  $1 = &tmpPoint2f;
}

%typemap(argout, noblock=1, fragment="SWIG_SciDouble_FromPoint2f") cv::Point2f* {
  if (SWIG_SciDouble_FromPoint2f(pvApiCtx, SWIG_Scilab_GetOutputPosition(), $1, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
  SWIG_Scilab_SetOutput(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + SWIG_Scilab_GetOutputPosition());
}

