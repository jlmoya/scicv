// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

// OpenCV float** ranges <= Scilab double matrix

%typemap(typecheck, noblock=0) float** ranges {
  int *piAddr;
  SciErr sciErr = getVarAddressFromPosition(pvApiCtx, $input, &piAddr);
  if (sciErr.iErr) {
    printError(&sciErr, 0);
    return SWIG_ERROR;
  }
  $1 = isDoubleType(pvApiCtx, piAddr);
}

%typemap(in, noblock=1, fragment="SWIG_SciDouble_AsFloatArrayAndSize") float** ranges (int iRowCount, int iColCount) {
  float *pfValues = NULL;
  if (SWIG_SciDouble_AsFloatArrayAndSize(pvApiCtx, $input, &iRowCount, &iColCount, &pfValues, fname) != SWIG_OK) {
    return SWIG_ERROR;
  }
  if ((iRowCount == 2) || (iColCount == 2)) {
    int n = iRowCount == 2 ? iColCount : iRowCount;
    $1 = (float**) malloc(n * sizeof(float*));
    for (int i=0; i<n; i++) {
      $1[i] = (float *) malloc(2 * sizeof(float));
      $1[i][0] = pfValues[i*2];
      $1[i][1] = pfValues[i*2+1];
    }
  }
  else {
    Scierror(999,_("%s: Wrong size for input argument #%d: a matrix with 2 rows or columns expected.", SWIG_Scilab_GetFuncName(), $input));
    return SWIG_ERROR;
  }
}
