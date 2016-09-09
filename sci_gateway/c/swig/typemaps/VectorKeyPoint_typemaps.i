// OpenCV std::vector<KeyPoint> => Scilab: list matrix[1,6]

/*
%typemap(in, numinputs=0, noblock=1) vector<cv::KeyPoint>& (vector<cv::KeyPoint> vKeyPoint) {
  $1 = &vKeyPoint;
}

%typemap(argout, noblock=0) vector<cv::KeyPoint>& {
  SciErr sciErr;
  int *piListAddr = NULL;
  int nbElements = $1->size();
  int iVarOut =  SWIG_Scilab_GetOutputPosition();

  sciErr = createList(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + iVarOut, nbElements, &piListAddr);
  if (sciErr.iErr) {
    printError(&sciErr, 0);
    return SWIG_ERROR;
  }

  for (int i = 0; i<nbElements; i++) {
    cv::KeyPoint keypoint = $1->at(i);
    double pdKeyPoint[7] = { keypoint.pt, keypoint.size, keypoint.angle, keypoint.response, keypoint.octave, keypoint.class_id };
    sciErr = createMatrixOfDoubleInList(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + iVarOut, piListAddr, i+1, 1, 6, &pdKeyPoint[0]);
    if (sciErr.iErr) {
      printError(&sciErr, 0);
      return SWIG_ERROR;
    }
  }

  SWIG_Scilab_SetOutput(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + iVarOut);
}
*/
