// OpenCV Mat <=> Scilab mlist _p_cv_Mat

%fragment("SWIG_SciMList_AsMat", "header") {

int SWIG_SciMList_AsMat(void *pvApiCtx, SwigSciObject iVarInput, cv::Mat **pMat, char *fname) {
  SciErr sciErr;
  int *piAddrVar = NULL;

  sciErr = getVarAddressFromPosition(pvApiCtx, iVarInput, &piAddrVar);
  if (sciErr.iErr) {
    printError(&sciErr, 0);
    return sciErr.iErr;
  }

  if (isMListType(pvApiCtx, piAddrVar)) {
    int iItemCount = 0;
    void *pvTypeinfo = NULL;
    void *pvPtr = NULL;

    sciErr = getListItemNumber(pvApiCtx, piAddrVar, &iItemCount);
    if (sciErr.iErr)
    {
      printError(&sciErr, 0);
      return SWIG_ERROR;
    }
    if (iItemCount < 3) {
      return SWIG_ERROR;
    }

    sciErr = getPointerInList(pvApiCtx, piAddrVar, 2, &pvTypeinfo);
    if (sciErr.iErr) {
      printError(&sciErr, 0);
      return SWIG_ERROR;
    }

    // TODO check we have Mat pointer

    sciErr = getPointerInList(pvApiCtx, piAddrVar, 3, &pvPtr);
    if (sciErr.iErr) {
      printError(&sciErr, 0);
      return SWIG_ERROR;
    }

    *pMat = static_cast<Mat*>(pvPtr);

    return SWIG_OK;
  }
  else {
    return SWIG_ERROR;
  }
}

}

%fragment("SWIG_SciMList_FromMat", "header") {

int SWIG_SciMList_FromMat(void *pvApiCtx, SwigSciObject iVarOut, cv::Mat *mat, char *fname) {
  SciErr sciErr;
  swig_type_info *descriptor = NULL;

  if (mat == NULL) {
    return SWIG_ERROR;
  }

  descriptor = SWIG_TypeQuery("cv::Mat *");
  if (descriptor) {
    int *piMListAddr = NULL;
    const char *pstString = NULL;

    sciErr = createMList(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + iVarOut, 3, &piMListAddr);
    if (sciErr.iErr) {
      printError(&sciErr, 0);
      return SWIG_ERROR;
    }

    pstString = SWIG_TypeName(descriptor);
    sciErr = createMatrixOfStringInList(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + iVarOut, piMListAddr, 1, 1, 1, &pstString);
    if (sciErr.iErr) {
      printError(&sciErr, 0);
      return SWIG_ERROR;
    }

    sciErr = createPointerInList(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + iVarOut, piMListAddr, 2, descriptor);
    if (sciErr.iErr) {
      printError(&sciErr, 0);
      return SWIG_ERROR;
    }

    sciErr = createPointerInList(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + iVarOut, piMListAddr, 3, mat);
    if (sciErr.iErr) {
      printError(&sciErr, 0);
      return SWIG_ERROR;
    }
  }
  else {
    sciErr = createPointer(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + iVarOut, mat);
    if (sciErr.iErr) {
      printError(&sciErr, 0);
      return SWIG_ERROR;
    }
  }
  return SWIG_OK;
}
}
