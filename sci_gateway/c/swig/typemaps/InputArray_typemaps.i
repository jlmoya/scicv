// OpenCV InputArray <= Scilab Mlist Mat

// Scilab: Mat pointer <=> OpenCV: Input array & OutputArray

%fragment("SWIG_SciPtr_AsMat", "header") {

int SWIG_SciPtr_AsMat(void *pvApiCtx, SwigSciObject iVar, cv::Mat **mat, char *fname) {
  SciErr sciErr;
  int *piAddrVar = NULL;
  int iType = 0;
  void *pvPtr = NULL;

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

  if (iType == sci_mlist) {
    int iItemCount = 0;
    void *pvTypeinfo = NULL;

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

    *mat = static_cast<Mat*>(pvPtr);

    return SWIG_OK;
  }
  else {
    return SWIG_ERROR;
  }
}

}

%typemap(typecheck, precedence=SWIG_TYPECHECK_POINTER) cv::InputArray {
  cv::Mat *mat = NULL;
  $1 = SWIG_SciPtr_AsMat(pvApiCtx, $input, &mat, SWIG_Scilab_GetFuncName()) == SWIG_OK ? 1 : 0;
}

%typemap(in, noblock=1) cv::InputArray {
  cv::Mat *inputMat$input = NULL;
  if (SWIG_SciPtr_AsMat(pvApiCtx, $input, &inputMat$input, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
  $1 = new cv::_InputArray(*inputMat$input);
}

%typemap(freearg, noblock=1) cv::InputArray {
  delete $1;
}
