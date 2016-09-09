// OpenCV Mat => Scilab hypermat

%fragment("SWIG_SciHypermat_FromMat", "header") {

#define copy_row_major_pixel_to_column_major_planar_data(src, dst) \
  for (int c = 0; c<nbchannels; c++) \
    for (int i = 0; i<height; i++) \
      for (int j = 0; j<width; j++) \
        dst[c*width*height + j*height + i] = src[c + nbchannels*(i*width + j)]

int SWIG_SciHypermat_FromMat(void *pvApiCtx, SwigSciObject iVarOut, cv::Mat *mat, char *fname) {
  int width = mat->cols;
  int height = mat->rows;
  int nbchannels = mat->channels();
  int size = width * height * nbchannels;

  int dims[3];
  dims[0] = height;
  dims[1] = width;
  dims[2] = nbchannels;

  SciErr sciErr;
  void *data;
  switch(mat->depth()) {
    case CV_8U: {
      data = malloc(size * sizeof(uint8_t));
      uint8_t *src = (uint8_t *)mat->data;
      uint8_t *dst = (uint8_t *)data;
      copy_row_major_pixel_to_column_major_planar_data(src, dst);
      sciErr = createHypermatOfUnsignedInteger8(pvApiCtx,
        SWIG_NbInputArgument(pvApiCtx) + iVarOut,
        dims, 3, (const unsigned char *)data);
      break;
    }
    case CV_8S:
    {
      data = malloc(size * sizeof(int8_t));
      int8_t *src = (int8_t *)mat->data;
      int8_t *dst = (int8_t *)data;
      copy_row_major_pixel_to_column_major_planar_data(src, dst);
      sciErr = createHypermatOfInteger8(pvApiCtx,
        SWIG_NbInputArgument(pvApiCtx) + iVarOut,
        dims, 3, (const char*)data);
      sciErr = createHypermatOfUnsignedInteger16(pvApiCtx,
         SWIG_NbInputArgument(pvApiCtx) + iVarOut,
         dims, 3, (const unsigned short *)data);
      break;
    }
    case CV_16U: {
      data = malloc(size * sizeof(uint16_t));
      uint16_t *src = (uint16_t *)mat->data;
      uint16_t *dst = (uint16_t *)data;
      copy_row_major_pixel_to_column_major_planar_data(src, dst);
      sciErr = createHypermatOfUnsignedInteger32(pvApiCtx,
        SWIG_NbInputArgument(pvApiCtx) + iVarOut,
        dims, 3, (const unsigned int *)data);
      break;
    }
    case CV_16S: {
      data = malloc(size * sizeof(int16_t));
      int16_t *src = (int16_t *)mat->data;
      int16_t *dst = (int16_t *)data;
      copy_row_major_pixel_to_column_major_planar_data(src, dst);
      sciErr = createHypermatOfInteger16(pvApiCtx,
        SWIG_NbInputArgument(pvApiCtx) + iVarOut,
        dims, 3, (const short *)data);
      break;
    }
    case CV_32S: {
      data = malloc(size * sizeof(int32_t));
      int32_t *src = (int32_t *)mat->data;
      int32_t *dst = (int32_t *)data;
      copy_row_major_pixel_to_column_major_planar_data(src, dst);
      sciErr = createHypermatOfInteger32(pvApiCtx,
        SWIG_NbInputArgument(pvApiCtx) + iVarOut,
        dims, 3, (const int *)data);
      break;
    }
    case CV_32F: {
      data = malloc(size * sizeof(double));
      float *src = (float *)mat->data;
      double *dst = (double *)data;
      copy_row_major_pixel_to_column_major_planar_data(src, dst);
      sciErr = createHypermatOfDouble(pvApiCtx,
        SWIG_NbInputArgument(pvApiCtx) + iVarOut,
        dims, 3, (const double *)data);
      break;
    }
    case CV_64F: {
      data = malloc(size * sizeof(double));
      double *src = (double *)mat->data;
      double *dst = (double *)data;
      copy_row_major_pixel_to_column_major_planar_data(src, dst);
      sciErr = createHypermatOfDouble(pvApiCtx,
        SWIG_NbInputArgument(pvApiCtx) + iVarOut,
        dims, 3, (const double *)data);
      break;
    }
    default: {
        return SWIG_ERROR;
    }
    // TODO: implement other pixel types
  }

  if (sciErr.iErr) {
    printError(&sciErr, 0);
    return SWIG_ERROR;
  }

  return SWIG_OK;
}

}

%typemap(in, noblock=1, fragment="SWIG_SciPtr_AsMat") cv::Mat& matIn {
  if (SWIG_SciPtr_AsMat(pvApiCtx, $input, &$1, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
}

%typemap(in, numinputs=0, noblock=1) cv::Mat* matOut (cv::Mat tmpMat) {
    $1 = &tmpMat;
}

%typemap(argout, noblock=1, fragment="SWIG_SciHypermat_FromMat") cv::Mat* matOut {
  if (SWIG_SciHypermat_FromMat(pvApiCtx, SWIG_Scilab_GetOutputPosition(), $1, SWIG_Scilab_GetFuncName()) == SWIG_OK) {
    SWIG_Scilab_SetOutput(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + SWIG_Scilab_GetOutputPosition());
  }
  else {
    return SWIG_ERROR;
  }
}





