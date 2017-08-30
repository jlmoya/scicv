// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

%fragment("SWIG_SciDouble_FromVectorVec4i", "header", fragment="SWIG_SciDouble_FromDoubleArrayAndSize") {
int SWIG_SciDouble_FromVectorVec4i(void *pvApiCtx, SwigSciObject iVarOut, std::vector<Vec4i> *vectorVec4i, char *fname) {
  int vecSize = (int) vectorVec4i->size();
  double *pdValues = (double *) malloc(4 * vecSize * sizeof(double));
  for (int i = 0; i < vecSize; i++) {
    Vec4i vec = vectorVec4i->at(i);
    pdValues[4*i] = vec[0];
    pdValues[4*i+1] = vec[1];
    pdValues[4*i+2] = vec[2];
    pdValues[4*i+3] = vec[3];
  }
  if (SWIG_SciDouble_FromDoubleArrayAndSize(pvApiCtx, SWIG_Scilab_GetOutputPosition(), 4, vecSize, pdValues) != SWIG_OK) {
    free(pdValues);
    return SWIG_ERROR;
  }
  free(pdValues);
  return SWIG_OK;

}
}
