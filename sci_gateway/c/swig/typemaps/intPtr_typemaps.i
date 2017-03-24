// Scilab Computer Vision Toolbox
// Copyright (C) 2017 - Scilab Enterprises

// OpenCV int* channels <= Scilab double matrix

%typemap(typecheck, noblock=0) const int* {
  int *piAddr = NULL;
  SciErr sciErr = getVarAddressFromPosition(pvApiCtx, $input, &piAddr);
  if (sciErr.iErr) {
     printError(&sciErr, 0);
     return SWIG_ERROR;
  }
  $1 = isDoubleType(pvApiCtx, piAddr);
}

%typemap(in, noblock=1, fragment="SWIG_SciDoubleOrInt32_AsIntArrayAndSize") const int* (int iRowCount, int iColCount) {
  if (SWIG_SciDoubleOrInt32_AsIntArrayAndSize(pvApiCtx, $input, &iRowCount, &iColCount, &$1, fname) != SWIG_OK) {
    return SWIG_ERROR;
  }
}
