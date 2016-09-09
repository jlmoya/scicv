
// OpenCV float** ranges Scilab double matrix <=>

%typemap(typecheck, noblock=0) float** ranges {
  int *piAddr;
  SciErr sciErr = getVarAddressFromPosition(pvApiCtx, $input, &piAddr);
  if (sciErr.iErr) {
     printError(&sciErr, 0);
     return SWIG_ERROR;
  }
  $1 = isDoubleType(pvApiCtx, piAddr);
}

%typemap(in, noblock=1, fragment="SWIG_SciDouble_AsFloatArrayAndSize") float** ranges (int rowCount, int colCount)
{
  if (SWIG_SciDouble_AsFloatArrayAndSize(pvApiCtx, $input, &rowCount, &colCount, $1, fname) != SWIG_OK) {
    return SWIG_ERROR;
  }
}
