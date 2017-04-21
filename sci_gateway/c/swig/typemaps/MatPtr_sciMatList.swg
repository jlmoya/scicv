// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

%fragment("SWIG_SciMatList_AsMatPtr", "header") {

int SWIG_SciMatList_AsMatPtr(void *pvApiCtx, SwigSciObject iVar, cv::Mat **pMatArray, char *fname) {
  SciErr sciErr;
  int *piAddrVar = NULL;
  int iType = 0;

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

  if (iType == sci_list) {
    int iItemCount = 0;

    sciErr = getListItemNumber(pvApiCtx, piAddrVar, &iItemCount);
    if (sciErr.iErr) {
      printError(&sciErr, 0);
      return SWIG_ERROR;
    }
    if (iItemCount < 1) {
      // TODO return error message
      return SWIG_ERROR;
    }

    *pMatArray = new cv::Mat[iItemCount];
    for (int i = 0; i < iItemCount; i++) {
      cv::Mat *pMat = NULL;
      int *piItemAddr = NULL;

      sciErr = getMListInList(pvApiCtx, piAddrVar, i+1, &piItemAddr);
      if (sciErr.iErr) {
        printError(&sciErr, 0);
        return SWIG_ERROR;
      }

      // TODO check we have Mat type

      sciErr = getPointerInList(pvApiCtx, piItemAddr, 3, (void**) &pMat);
      if (sciErr.iErr) {
        printError(&sciErr, 0);
        return SWIG_ERROR;
      }

      (*pMatArray)[i] = *pMat;
    }
    return SWIG_OK;
  }
  else {
    return SWIG_ERROR;
  }
}

}
