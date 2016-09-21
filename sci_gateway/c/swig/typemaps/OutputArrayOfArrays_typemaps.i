// OpenCV OutputArrayOfArrays => Scilab mlist _p_cv_Mat

//%include VectorVectorPoints_sciMatrixList.swg

%fragment("SWIG_SciMatrixList_FromVectorVectorPoints", "header") {

int SWIG_SciMatrixList_FromVectorVectorPoints(void *pvApiCtx, SwigSciObject iVarOut, std::vector<std::vector<cv::Point> > *pVectorVectorPoints, char *fname) {
  SciErr sciErr;
  int *piListAddr = NULL;
  int nbVectorPoints = pVectorVectorPoints->size();

  sciErr = createList(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + iVarOut, nbVectorPoints, &piListAddr);
  if (sciErr.iErr) {
    printError(&sciErr, 0);
    return SWIG_ERROR;
  }

  for (int i = 0; i < nbVectorPoints; i++) {
    std::vector<cv::Point> vectorPoints = pVectorVectorPoints->at(i);
    int nbPoints = vectorPoints.size();

    double *pdValues = (double *) malloc(2 * nbPoints * sizeof(double));
    for (int j = 0; j < nbPoints; j++) {
      cv::Point pt = vectorPoints.at(j);
      pdValues[2*j] = pt.x;
      pdValues[2*j+1] = pt.y;
    }

    sciErr = createMatrixOfDoubleInList(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + iVarOut, piListAddr, i+1, 2, nbPoints, pdValues);
    if (sciErr.iErr) {
      printError(&sciErr, 0);
      return SWIG_ERROR;
    }
  }
  return SWIG_OK;
}

}


%typemap(in, numinputs=0, noblock=1) cv::OutputArrayOfArrays contours {
}

%typemap(arginit, noblock=1) cv::OutputArrayOfArrays contours {
  std::vector<std::vector<cv::Point> > contours$argnum;
  $1 = new cv::_OutputArray(contours$argnum);
}

%typemap(argout, noblock=1, fragment="SWIG_SciMatrixList_FromVectorVectorPoints") cv::OutputArrayOfArrays contours {
  if (SWIG_SciMatrixList_FromVectorVectorPoints(pvApiCtx, SWIG_Scilab_GetOutputPosition(), &contours$argnum, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
  SWIG_Scilab_SetOutput(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + SWIG_Scilab_GetOutputPosition());
}

%typemap(freearg, noblock=1) cv::OutputArrayOfArrays contours {
  delete $1;
}
