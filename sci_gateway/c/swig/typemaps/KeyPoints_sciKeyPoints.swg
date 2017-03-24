// Scilab Computer Vision Toolbox
// Copyright (C) 2017 - Scilab Enterprises

// OpenCV Points (vector<KeyPoint>) => Scilab double nx2

%fragment("SWIG_SciKeyPoints_FromKeyPoints", "header", fragment="SWIG_SciDouble_FromDoubleArrayAndSize") {

int SWIG_SciKeyPoints_FromKeyPoints(void *pvApiCtx, SwigSciObject iVarOut, KeyPoints *pKeyPoints, char *fname) {
  SciErr sciErr;
  int keyPointCount = (int) pKeyPoints->size();

  int keyPointSize = 7;
  double* pdValues = (double *) malloc(keyPointSize * keyPointCount * sizeof(double));
  for (int i = 0; i < keyPointCount; i++) {
    cv::KeyPoint keyPoint = pKeyPoints->at(i);
    pdValues[i*keyPointSize]   = keyPoint.pt.x;
    pdValues[i*keyPointSize+1] = keyPoint.pt.y;
    pdValues[i*keyPointSize+2] = keyPoint.size;
    pdValues[i*keyPointSize+3] = keyPoint.angle;
    pdValues[i*keyPointSize+4] = keyPoint.response;
    pdValues[i*keyPointSize+5] = keyPoint.octave;
    pdValues[i*keyPointSize+6] = keyPoint.class_id;
  }

  if (SWIG_SciDouble_FromDoubleArrayAndSize(pvApiCtx, iVarOut, keyPointSize, keyPointCount, pdValues) != SWIG_OK) {
    return SWIG_ERROR;
  }

	free(pdValues);
  return SWIG_OK;
}

}
