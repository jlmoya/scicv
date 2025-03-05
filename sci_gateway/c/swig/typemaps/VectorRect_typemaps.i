// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT

// OpenCV std::vector<Rect> => Scilab: list matrix[1,4]

%typemap(in, numinputs=0, noblock=1) std::vector<cv::Rect_<int>>& (vector<cv::Rect_<int>> vRect) {
  $1 = &vRect;
}

%typemap(argout, noblock=0) std::vector<cv::Rect_<int>>& {
  SciErr sciErr;
  int *piListAddr = NULL;
  int nbElements = (int) $1->size();
  int iVarOut =  SWIG_Scilab_GetOutputPosition();

  sciErr = createList(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + iVarOut, nbElements, &piListAddr);
  if (sciErr.iErr) {
    printError(&sciErr, 0);
    return SWIG_ERROR;
  }

  for (int i = 0; i<nbElements; i++) {
    cv::Rect_<int> rect = $1->at(i);
    double pdRect[4] = { rect.x, rect.y, rect.width, rect.height };
    sciErr = createMatrixOfDoubleInList(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + iVarOut, piListAddr, i+1, 1, 4, &pdRect[0]);
    if (sciErr.iErr) {
      printError(&sciErr, 0);
      return SWIG_ERROR;
    }
  }

  SWIG_Scilab_SetOutput(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + iVarOut);
}
