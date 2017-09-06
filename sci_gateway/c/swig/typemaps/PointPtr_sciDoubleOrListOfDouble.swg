// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

// OpenCV (Points**) <= Scilab double nx2

%fragment("SWIG_Check_SciDoubleOrListOfDouble", "header") {

int SWIG_Check_SciDoubleOrListOfDouble(void *pvApiCtx, SwigSciObject iVar, char *fname) {
  SciErr sciErr;
  int iType;
  int *piAddrVar = NULL;

  sciErr = getVarAddressFromPosition(pvApiCtx, iVar, &piAddrVar);
  if (sciErr.iErr) {
    printError(&sciErr, 0);
    return 0;
  }

  sciErr = getVarType(pvApiCtx, piAddrVar, &iType);
  if (sciErr.iErr) {
    printError(&sciErr, 0);
    return 0;
  }

  return (iType == sci_matrix) || ((iType == sci_list) || (iType == sci_mlist) || (iType == sci_tlist));
}

}


%fragment("SWIG_SciDoubleOrListOfDouble_AsPointPtr", "header", fragment="SWIG_SciDoubleOrInt32_AsIntArrayAndSize") {

int SWIG_SciDoubleOrListOfDouble_AsPointPtr(void *pvApiCtx, SwigSciObject iVar, cv::Point ***pPoints, int **piPointCount, int *piContourCount, char *fname) {
  SciErr sciErr;
  int iType = 0;
  int *piAddrVar = NULL;

  sciErr = getVarAddressFromPosition(pvApiCtx, iVar, &piAddrVar);
  if (sciErr.iErr) {
    printError(&sciErr, 0);
    return SWIG_ERROR;
  }

  sciErr = getVarType(pvApiCtx, piAddrVar, &iType);
  if (sciErr.iErr) {
    printError(&sciErr, 0);
    return SWIG_ERROR;
  }

  if (iType == sci_matrix) {
    int *piValues = NULL;
    int iRows = 0;
    int iCols = 0;
    if (SWIG_SciDoubleOrInt32_AsIntArrayAndSize(pvApiCtx, iVar, &iRows, &iCols, &piValues, fname) != SWIG_OK) {
      return SWIG_ERROR;
    }

    if (iRows != 2 ) {
      Scierror(999, _("%s: Wrong size for argument #%d: A matrix of 2xn double is expected.\n"), fname, iVar);
      return SWIG_ERROR;
    }

    *piContourCount = 1;
    *piPointCount = (int*) malloc(sizeof(int));
    *pPoints = (cv::Point**) malloc(sizeof(cv::Point*));

    (*piPointCount)[0] = iCols;
    (*pPoints)[0] = (cv::Point*) malloc(iCols * sizeof(cv::Point));
    for (int j=0; j<iCols; j++) {
      (*pPoints)[0][j] = cv::Point(piValues[2*j], piValues[2*j+1]);
    }
  }
  else if ((iType == sci_list) || (iType == sci_mlist) || (iType == sci_tlist)) {
    sciErr = getListItemNumber(pvApiCtx, piAddrVar, piContourCount);
    if (sciErr.iErr) {
      printError(&sciErr, 0);
      return SWIG_ERROR;
    }

    *piPointCount = (int*) malloc(*piContourCount * sizeof(int));
    *pPoints = (cv::Point**) malloc(*piContourCount * sizeof(cv::Point*));

    for (int i=0; i<*piContourCount; i++) {
      int *piAddrItem = NULL;
      int iItemType;
      int iCols;
      int iRows;
      double *pdValues;

      sciErr = getListItemAddress(pvApiCtx, piAddrVar, i+1, &piAddrItem);
      if (sciErr.iErr) {
        printError(&sciErr, 0);
        return SWIG_ERROR;
      }

      sciErr = getVarType(pvApiCtx, piAddrItem, &iItemType);
      if (sciErr.iErr) {
        printError(&sciErr, 0);
        return SWIG_ERROR;
      }

      if (iItemType == sci_matrix) {
        sciErr = getMatrixOfDoubleInList(pvApiCtx, piAddrVar, i+1, &iRows, &iCols, &pdValues);
        if (sciErr.iErr) {
            printError(&sciErr, 0);
            return SWIG_ERROR;
        }

        if (iRows != 2 ) {
          Scierror(999, _("%s: Wrong size for item #%d: A matrix of 2xn double is expected.\n"), fname, i+1);
          return SWIG_ERROR;
        }

        (*piPointCount)[i] = iCols;
        (*pPoints)[i] = (cv::Point*) malloc((*piPointCount)[i] * sizeof(cv::Point));
        for (int j=0; j<(*piPointCount)[i]; j++) {
          (*pPoints)[i][j] = cv::Point((int)pdValues[2*j], (int)pdValues[2*j+1]);
        }
      }
      else {
        Scierror(999, _("%s: Wrong type for item #%d: A matrix of 2xn double is expected.\n"), fname, i+1);
        return SWIG_ERROR;
      }
    }
  }
  else {
    Scierror(999, _("%s: Wrong size for argument #%d: A matrix of 2xn double or a list of matrixes of double 2xn is expected.\n"), fname, iVar);
    return SWIG_ERROR;
  }

  return SWIG_OK;
}

}
