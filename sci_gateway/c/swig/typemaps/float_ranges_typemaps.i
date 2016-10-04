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
  $1 = (float**) malloc(iColCount * sizeof(float*));
  for (int i=0; i<iColCount; i++) {
    $1[i] = (float *) malloc(iRowCount * sizeof(float));
    for (int j=0; j<iRowCount; j++) {
      $1[i][j] = pfValues[i*iRowCount + j];
    }
  }
}
