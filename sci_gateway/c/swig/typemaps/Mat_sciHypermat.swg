// OpenCV Mat <=> Scilab hypermat

%fragment("SWIG_SciHypermat_AsMat", "header") {

#define copy_column_major_planar_to_row_major_pixel_data(src, dst) \
  for (int c = 0; c<nc; c++) \
    for (int i = 0; i<h; i++) \
      for (int j = 0; j<w; j++) \
        dst[c + nc*(i*w + j)] = src[c*w*h + j*h + i]

int SWIG_SciHypermat_AsMat(void *pvApiCtx, int iVarInput, cv::Mat *pMat, char *fname) {
  SciErr sciErr;
  int *piAddrVar = NULL;

  sciErr = getVarAddressFromPosition(pvApiCtx, iVarInput, &piAddrVar);
  if (sciErr.iErr) {
    printError(&sciErr, 0);
    return sciErr.iErr;
  }

  if (isHypermatType(pvApiCtx, piAddrVar)) {
    int htype = 0;
    int iPrec = 0;
    int ndims = 0;
    int *dims = NULL;
    int w, h, nc, type = 0;
    void *data = NULL;

    sciErr = getHypermatType(pvApiCtx, piAddrVar, &htype);
    if (sciErr.iErr) {
      printError(&sciErr, 0);
      return sciErr.iErr;
    }

    if (htype == sci_ints) {
      sciErr = getHypermatOfIntegerPrecision(pvApiCtx, piAddrVar, &iPrec);
      if (sciErr.iErr) {
        printError(&sciErr, 0);
        return sciErr.iErr;
      }

      switch (iPrec) {
        case SCI_UINT8: {
          uint8_t *src = NULL;
          sciErr = getHypermatOfUnsignedInteger8(pvApiCtx, piAddrVar, &dims, &ndims, (unsigned char**)&src);
          if (sciErr.iErr == 0) {
            h = dims[0];
            w = dims[1];
            nc = dims[2];
            uint8_t *dst = (uint8_t *) malloc(w * h * nc * sizeof(uint8_t));
            copy_column_major_planar_to_row_major_pixel_data(src, dst);
            data = dst;
            type = (nc > 1) ? CV_8UC3 : CV_8UC1;
          }
          break;
        }
        case SCI_INT8: {
          int8_t *src = NULL;
          sciErr = getHypermatOfInteger8(pvApiCtx, piAddrVar, &dims, &ndims, (char**)&src);
          if (sciErr.iErr == 0) {
            h = dims[0];
            w = dims[1];
            nc = dims[2];
            int8_t *dst = (int8_t *) malloc(w * h * nc * sizeof(int8_t));
            copy_column_major_planar_to_row_major_pixel_data(src, dst);
            data = dst;
            type = (nc > 1) ? CV_8SC3 : CV_8SC1;
          }
          break;
        }
        case SCI_UINT16: {
          uint16_t *src = NULL;
          sciErr = getHypermatOfUnsignedInteger16(pvApiCtx, piAddrVar, &dims, &ndims, (unsigned short**)&src);
          if (sciErr.iErr == 0) {
            h = dims[0];
            w = dims[1];
            nc = dims[2];
            uint16_t *dst = (uint16_t *) malloc(w * h * nc * sizeof(uint16_t));
            copy_column_major_planar_to_row_major_pixel_data(src, dst);
            data = dst;
            type = (nc > 1) ? CV_16UC3 : CV_16UC1;
          }
          break;
        }
        case SCI_INT16: {
          int16_t *src = NULL;
          sciErr = getHypermatOfInteger16(pvApiCtx, piAddrVar, &dims, &ndims, (short**)&src);
          if (sciErr.iErr == 0) {
            h = dims[0];
            w = dims[1];
            nc = dims[2];
            int16_t *dst = (int16_t *) malloc(w * h * nc * sizeof(int16_t));
            copy_column_major_planar_to_row_major_pixel_data(src, dst);
            data = dst;
            type = (nc > 1) ? CV_16SC3 : CV_16SC1;
          }
          break;
        }
        /*case SCI_UINT32: {
          uint32_t *src = NULL;
          sciErr = getHypermatOfUnsignedInteger32(pvApiCtx, piAddrVar, &dims, &ndims, (unsigned int**)&src);
          if (sciErr.iErr == 0) {
            h = dims[0];
            w = dims[1];
            nc = dims[2];
            uint32_t *dst = (uint32_t *) malloc(w * h * nc * sizeof(uint32_t));
            data = dst;
            copy_column_major_planar_to_row_major_pixel_data(src, dst);
            data = dst;
            type = (nc > 1) ? CV_32UC3 : CV_32UC1;
          }
          break;
        }*/
        case SCI_INT32: {
          int32_t *src = NULL;
          sciErr = getHypermatOfInteger32(pvApiCtx, piAddrVar, &dims, &ndims, (int32_t**)&src);
          if (sciErr.iErr == 0) {
            h = dims[0];
            w = dims[1];
            nc = dims[2];
            int32_t *dst = (int32_t *) malloc(w * h * nc * sizeof(int32_t));
            copy_column_major_planar_to_row_major_pixel_data(src, dst);
            data = dst;
            type = (nc > 1) ? CV_32SC3 : CV_32SC1;
          }
          break;
        }
      }
    }
    else if (htype == sci_matrix) {
      double *src = NULL;
      sciErr = getHypermatOfDouble(pvApiCtx, piAddrVar, &dims, &ndims, &src);
      if (sciErr.iErr == 0) {
        h = dims[0];
        w = dims[1];
        nc = dims[2];
        double *dst = (double *) malloc(w * h * nc * sizeof(double));
        copy_column_major_planar_to_row_major_pixel_data(src, dst);
        data = dst;
        type = (nc > 1) ? CV_64FC3 : CV_64FC1;
      }
    }
    else {
      Scierror(999, _("%s: Wrong type for input argument #%d: A hypermatrix of integer or double is expected.\n"), fname, iVarInput);
      return sciErr.iErr;
    }

    if (sciErr.iErr) {
      printError(&sciErr, 0);
      return sciErr.iErr;
    }

    *pMat = cv::Mat(h, w, type, data, cv::Mat::AUTO_STEP);

    return SWIG_OK;
  }
  else if (isVarMatrixType(pvApiCtx, piAddrVar)) {
    int iPrec = 0;
    int w, h, type = 0;
    int nc = 1;
    void *data = NULL;

    if (isIntegerType(pvApiCtx, piAddrVar)) {
      sciErr = getMatrixOfIntegerPrecision(pvApiCtx, piAddrVar, &iPrec);
      if(sciErr.iErr) {
        printError(&sciErr, 0);
        return sciErr.iErr;
      }

      switch (iPrec) {
        case SCI_UINT8: {
          uint8_t *src = NULL;
          sciErr = getMatrixOfUnsignedInteger8(pvApiCtx, piAddrVar, &h, &w, (unsigned char**)&src);
          if (sciErr.iErr == 0) {
            uint8_t *dst = (uint8_t *) malloc(w * h * sizeof(uint8_t));
            copy_column_major_planar_to_row_major_pixel_data(src, dst);
            data = dst;
            type = CV_8UC1;
          }
          break;
        }
        case SCI_INT8: {
          int8_t *src = NULL;
          sciErr = getMatrixOfInteger8(pvApiCtx, piAddrVar, &h, &w, (char**)&src);
          if (sciErr.iErr == 0) {
            int8_t *dst = (int8_t *) malloc(w * h * sizeof(int8_t));
            copy_column_major_planar_to_row_major_pixel_data(src, dst);
            data = dst;
            type = CV_8SC1;
          }
          break;
        }
        case SCI_UINT16: {
          uint16_t *src = NULL;
          sciErr = getMatrixOfUnsignedInteger16(pvApiCtx, piAddrVar, &h, &w, (unsigned short**)&src);
          if (sciErr.iErr == 0) {
            uint16_t *dst = (uint16_t *) malloc(w * h * sizeof(uint16_t));
            copy_column_major_planar_to_row_major_pixel_data(src, dst);
            data = dst;
            type = CV_16UC1;
          }
          break;
        }
        case SCI_INT16: {
          int16_t *src = NULL;
          sciErr = getMatrixOfInteger16(pvApiCtx, piAddrVar, &h, &w, (short**)&src);
          if (sciErr.iErr == 0) {
            int16_t *dst = (int16_t *) malloc(w * h * sizeof(int16_t));
            copy_column_major_planar_to_row_major_pixel_data(src, dst);
            data = dst;
            type = CV_16SC1;
          }
          break;
        }
        /*case SCI_UINT32: {
          uint32_t *src = NULL;
          sciErr = getMatrixOfUnsignedInteger32(pvApiCtx, piAddrVar, &h, &w,, (unsigned int**)&src);
          if (sciErr.iErr == 0) {
            uint32_t *dst = (uint32_t *) malloc(w * h * sizeof(uint32_t));
            copy_column_major_planar_to_row_major_pixel_data(src, dst);
            data = dst;
            type = CV_32UC1;
          }
          break;
        }*/
        case SCI_INT32: {
          int32_t *src = NULL;
          sciErr = getMatrixOfInteger32(pvApiCtx, piAddrVar, &h, &w, (int**)&src);
          if (sciErr.iErr == 0) {
            int32_t *dst = (int32_t *) malloc(w * h * sizeof(int32_t));
            copy_column_major_planar_to_row_major_pixel_data(src, dst);
            data = dst;
            type = CV_32SC1;
          }
          break;
        }
      }
    }
    else if (isDoubleType(pvApiCtx, piAddrVar)) {
      double *src = NULL;
      sciErr = getMatrixOfDouble(pvApiCtx, piAddrVar, &h, &w, (double**)&src);
      if (sciErr.iErr == 0) {
        double *dst = (double *) malloc(w * h * sizeof(double));
        copy_column_major_planar_to_row_major_pixel_data(src, dst);
        data = dst;
        type = CV_64FC1;
      }
    }
    else {
      Scierror(999, _("%s: Wrong type for input argument #%d: A matrix of integer or double is expected.\n"), fname, iVarInput);
      return sciErr.iErr;
    }

    if (sciErr.iErr) {
      printError(&sciErr, 0);
      return sciErr.iErr;
    }

    *pMat = cv::Mat(h, w, type, data, cv::Mat::AUTO_STEP);

    return SWIG_OK;
  }
  else {
    Scierror(999, _("%s: Wrong type for input argument #%d: A hypermatrix or a matrix is expected.\n"), fname, iVarInput);
    return sciErr.iErr;
  }
}

}


%fragment("SWIG_SciHypermat_FromMat", "header") {

#define copy_row_major_pixel_to_column_major_planar_data(src, dst) \
  for (int c = 0; c<nbchannels; c++) \
    for (int i = 0; i<height; i++) \
      for (int j = 0; j<width; j++) \
        dst[(nbchannels-1-c)*size + j*height + i] = src[c + nbchannels*(i*width + j)]

int SWIG_SciHypermat_FromMat(void *pvApiCtx, SwigSciObject iVarOut, cv::Mat *pMat, char *fname) {
  int width = pMat->cols;
  int height = pMat->rows;
  int nbchannels = pMat->channels();
  int size = width * height;

  int dims[3];
  dims[0] = height;
  dims[1] = width;
  dims[2] = nbchannels;

  SciErr sciErr;
  switch(pMat->depth()) {
    case CV_8U: {
      uint8_t *dst = (uint8_t *) malloc(size * nbchannels * sizeof(uint8_t));
      uint8_t *src = (uint8_t *) pMat->data;
      copy_row_major_pixel_to_column_major_planar_data(src, dst);
      sciErr = createHypermatOfUnsignedInteger8(pvApiCtx,
        SWIG_NbInputArgument(pvApiCtx) + iVarOut,
        dims, 3, (const unsigned char *)dst);
      free(dst);
      break;
    }
    case CV_8S: {
      int8_t *dst = (int8_t *) malloc(size * nbchannels * sizeof(int8_t));
      int8_t *src = (int8_t *) pMat->data;
      copy_row_major_pixel_to_column_major_planar_data(src, dst);
      sciErr = createHypermatOfInteger8(pvApiCtx,
        SWIG_NbInputArgument(pvApiCtx) + iVarOut,
        dims, 3, (const char*)dst);
      free(dst);
      break;
    }
    case CV_16U: {
      uint16_t *dst = (uint16_t *) malloc(size * nbchannels * sizeof(uint16_t));
      uint16_t *src = (uint16_t *) pMat->data;
      copy_row_major_pixel_to_column_major_planar_data(src, dst);
      sciErr = createHypermatOfUnsignedInteger32(pvApiCtx,
        SWIG_NbInputArgument(pvApiCtx) + iVarOut,
        dims, 3, (const unsigned int *)dst);
      free(dst);
      break;
    }
    case CV_16S: {
      int16_t *dst = (int16_t *) malloc(size * nbchannels * sizeof(int16_t));
      int16_t *src = (int16_t *) pMat->data;
      copy_row_major_pixel_to_column_major_planar_data(src, dst);
      sciErr = createHypermatOfInteger16(pvApiCtx,
        SWIG_NbInputArgument(pvApiCtx) + iVarOut,
        dims, 3, (const short *)dst);
      free(dst);
      break;
    }
    case CV_32S: {
      int32_t *dst = (int32_t *) malloc(size * nbchannels * sizeof(int32_t));
      int32_t *src = (int32_t *) pMat->data;
      copy_row_major_pixel_to_column_major_planar_data(src, dst);
      sciErr = createHypermatOfInteger32(pvApiCtx,
        SWIG_NbInputArgument(pvApiCtx) + iVarOut,
        dims, 3, (const int *)dst);
      free(dst);
      break;
    }
    case CV_32F: {
      double *dst = (double *) malloc(size * nbchannels * sizeof(double));
      float *src = (float *) pMat->data;
      copy_row_major_pixel_to_column_major_planar_data(src, dst);
      sciErr = createHypermatOfDouble(pvApiCtx,
        SWIG_NbInputArgument(pvApiCtx) + iVarOut,
        dims, 3, (const double *)dst);
      free(dst);
      break;
    }
    case CV_64F: {
      double *dst = (double *) malloc(size * nbchannels * sizeof(double));
      double *src = (double *) pMat->data;
      copy_row_major_pixel_to_column_major_planar_data(src, dst);
      sciErr = createHypermatOfDouble(pvApiCtx,
        SWIG_NbInputArgument(pvApiCtx) + iVarOut,
        dims, 3, (const double *)dst);
      free(dst);
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






