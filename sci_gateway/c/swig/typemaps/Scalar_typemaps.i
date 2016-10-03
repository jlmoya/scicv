// OpenCV Scalar => Scilab double 1x1 ... 1x4

%fragment("SWIG_SciDoubleOrInt32_AsScalar", "header") {

int SWIG_SciDoubleOrInt32_AsScalar(void *pvApiCtx, SwigSciObject iVar, cv::Scalar *scalar, char *fname) {
  int *piValues = NULL;
  int iRows = 0;
  int iCols = 0;
  if (SWIG_SciDoubleOrInt32_AsIntArrayAndSize(pvApiCtx, iVar, &iRows, &iCols, &piValues, fname) != SWIG_OK) {
    return SWIG_ERROR;
  }

  int n = iRows * iCols;
  if ((n > 0) && (n <= 4)) {
    for (int i=0; i<n; i++) {
      (*scalar)[i] = piValues[i];
    }
    return SWIG_OK;
  }
  else {
    return SWIG_ERROR;
  }
}

}

// TODO: fix precedence
%typemap(typecheck, precedence=SWIG_TYPECHECK_DOUBLE, fragment="SWIG_SciDoubleOrInt32_AsScalar") cv::Scalar, cv::Scalar & {
  cv::Scalar scalar;
  $1 = SWIG_SciDoubleOrInt32_AsScalar(pvApiCtx, $input, &scalar, SWIG_Scilab_GetFuncName()) == SWIG_OK ? 1 : 0;
}

%typemap(in, noblock=1, fragment="SWIG_SciDoubleOrInt32_AsScalar") cv::Scalar {
  if (SWIG_SciDoubleOrInt32_AsScalar(pvApiCtx, $input, &$1, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
}

%typemap(in, noblock=1, fragment="SWIG_SciDoubleOrInt32_AsScalar") cv::Scalar& (cv::Scalar tmpScalar) {
  $1 = &tmpScalar;
  if (SWIG_SciDoubleOrInt32_AsScalar(pvApiCtx, $input, $1, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
}

