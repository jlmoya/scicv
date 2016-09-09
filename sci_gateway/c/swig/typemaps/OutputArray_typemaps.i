// OpenCV OutputArray => Scilab Mlist Mat

%{
int SWIG_SciPtr_FromMat(void *pvApiCtx, SwigSciObject iVarOut, cv::Mat *mat, char *fname) {
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
%}

%typemap(in, numinputs=0, noblock=1) cv::OutputArray {
}

%typemap(arginit, noblock=1) cv::OutputArray {
  cv::Mat *outputMat$argnum = new Mat();
  $1 = new cv::_OutputArray(*outputMat$argnum);
}

%typemap(argout, noblock=1) cv::OutputArray {
  if (SWIG_SciPtr_FromMat(pvApiCtx, SWIG_Scilab_GetOutputPosition(), outputMat$argnum, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
  SWIG_Scilab_SetOutput(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + SWIG_Scilab_GetOutputPosition());
}

%typemap(freearg, noblock=1) cv::OutputArray {
  delete $1;
}
