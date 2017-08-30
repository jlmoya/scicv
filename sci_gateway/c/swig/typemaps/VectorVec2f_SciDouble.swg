// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

%fragment("SWIG_SciDouble_FromVectorVec2f", "header", fragment="SWIG_SciDouble_FromDoubleArrayAndSize") {
int SWIG_SciDouble_FromVectorVec2f(void *pvApiCtx, SwigSciObject iVarOut, std::vector<Vec2f> *vectorVec2f, char *fname) {
  int vecSize = (int) vectorVec2f->size();
  double *pdValues = (double *) malloc(2 * vecSize * sizeof(double));
  for (int i = 0; i < vecSize; i++) {
    Vec2f vec = vectorVec2f->at(i);
    pdValues[2*i] = vec[0];
    pdValues[2*i+1] = vec[1];
  }
  if (SWIG_SciDouble_FromDoubleArrayAndSize(pvApiCtx, SWIG_Scilab_GetOutputPosition(), 2, vecSize, pdValues) != SWIG_OK) {
    free(pdValues);
    return SWIG_ERROR;
  }
  free(pdValues);
  return SWIG_OK;

}
}
