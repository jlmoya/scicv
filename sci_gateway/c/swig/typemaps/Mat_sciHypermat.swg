// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

// OpenCV Mat <=> Scilab hypermat

%fragment("SWIG_SciHypermat_AsMat", "header") {

#define copy_column_major_planar_to_row_major_pixel_data(type) \
  for (int c = 0; c<nc; c++) \
    for (int i = 0; i<h; i++) \
      for (int j = 0; j<w; j++) \
        ((type*)data)[c + nc*(i*w + j)] = src[c*w*h + j*h + i]

int SWIG_SciHypermat_AsMat(void *pvApiCtx, int iVarInput, cv::Mat **pMat, char *fname) {
  SciErr sciErr;
  int *piAddrVar = NULL;

  sciErr = getVarAddressFromPosition(pvApiCtx, iVarInput, &piAddrVar);
  if (sciErr.iErr) {
    printError(&sciErr, 0);
    return sciErr.iErr;
  }

  if (isEmptyMatrix(pvApiCtx, piAddrVar)) {
    *pMat = new cv::Mat();
    return SWIG_OK;
  }
  else if (isHypermatType(pvApiCtx, piAddrVar)) {
    int htype = 0;
    int iPrec = 0;
    int ndims = 0;
    int *dims = NULL;
    int w, h, nc, type = 0;
    void *data = NULL;
    int size = 0;

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
            size = w * h * nc * sizeof(uint8_t);
            data = malloc(size);
            copy_column_major_planar_to_row_major_pixel_data(uint8_t);
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
            size = w * h * nc * sizeof(int8_t);
            data = malloc(size);
            copy_column_major_planar_to_row_major_pixel_data(int8_t);
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
            size = w * h * nc * sizeof(uint16_t);
            data = malloc(size);
            copy_column_major_planar_to_row_major_pixel_data(uint16_t);
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
            size = w * h * nc * sizeof(int16_t);
            data = malloc(size);
            copy_column_major_planar_to_row_major_pixel_data(int16_t);
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
            size = w * h * nc * sizeof(uint32_t);
            data = malloc(size);
            copy_column_major_planar_to_row_major_pixel_data(uint32_t);
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
            size = w * h * nc * sizeof(int32_t);
            data = malloc(size);
            copy_column_major_planar_to_row_major_pixel_data(int32_t);
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
        size = w * h * nc * sizeof(double);
        data = malloc(size);
        copy_column_major_planar_to_row_major_pixel_data(double);
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

    *pMat = new cv::Mat(h, w, type);
    memcpy((*pMat)->data, data, size);
    free(data);

    return SWIG_OK;
  }
  else if (isVarMatrixType(pvApiCtx, piAddrVar)) {
    int iPrec = 0;
    int w, h, type = 0;
    int nc = 1;
    void *data = NULL;
    int size = 0;

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
            size = w * h * sizeof(uint8_t);
            data = malloc(size);
            copy_column_major_planar_to_row_major_pixel_data(uint8_t);
            type = CV_8UC1;
          }
          break;
        }
        case SCI_INT8: {
          int8_t *src = NULL;
          sciErr = getMatrixOfInteger8(pvApiCtx, piAddrVar, &h, &w, (char**)&src);
          if (sciErr.iErr == 0) {
            size = w * h * sizeof(int8_t);
            data = malloc(size);
            copy_column_major_planar_to_row_major_pixel_data(int8_t);
            type = CV_8SC1;
          }
          break;
        }
        case SCI_UINT16: {
          uint16_t *src = NULL;
          sciErr = getMatrixOfUnsignedInteger16(pvApiCtx, piAddrVar, &h, &w, (unsigned short**)&src);
          if (sciErr.iErr == 0) {
            size = w * h * sizeof(uint16_t);
            data = malloc(size);
            copy_column_major_planar_to_row_major_pixel_data(uint16_t);
            type = CV_16UC1;
          }
          break;
        }
        case SCI_INT16: {
          int16_t *src = NULL;
          sciErr = getMatrixOfInteger16(pvApiCtx, piAddrVar, &h, &w, (short**)&src);
          if (sciErr.iErr == 0) {
            size = w * h * sizeof(int16_t);
            data = malloc(size);
            copy_column_major_planar_to_row_major_pixel_data(int16_t);
            type = CV_16SC1;
          }
          break;
        }
        /*case SCI_UINT32: {
          uint32_t *src = NULL;
          sciErr = getMatrixOfUnsignedInteger32(pvApiCtx, piAddrVar, &h, &w,, (unsigned int**)&src);
          if (sciErr.iErr == 0) {
            size = w * h * sizeof(uint32_t);
            data = malloc(size);
            copy_column_major_planar_to_row_major_pixel_data(uint32_t);
            type = CV_32UC1;
          }
          break;
        }*/
        case SCI_INT32: {
          int32_t *src = NULL;
          sciErr = getMatrixOfInteger32(pvApiCtx, piAddrVar, &h, &w, (int**)&src);
          if (sciErr.iErr == 0) {
            size = w * h * sizeof(int32_t);
            data = malloc(size);
            copy_column_major_planar_to_row_major_pixel_data(int32_t);
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
        size = w * h * sizeof(double);
        data = malloc(size);
        copy_column_major_planar_to_row_major_pixel_data(double);
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

    *pMat = new cv::Mat(h, w, type);
    memcpy((*pMat)->data, data, size);
    free(data);

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

// N-D (pMat->dims > 2) row-major (OpenCV) -> column-major (Scilab hypermat)
// copy. OpenCV keeps channel as the fastest-varying axis in memory (see the
// 2-D macro above: c has coefficient 1, i.e. it is the innermost loop), then
// the last logical dimension, then the next-to-last, ..., with axis 0
// slowest. Scilab hypermats are column-major, so axis 0 is fastest there and
// channel (when kept, see below) is slowest of all -- exactly reversed from
// OpenCV's order. This is a genuine index transpose, not a reinterpretation
// of the same flat order: each source element is decoded into its
// (channel, axis[ndims-1], ..., axis[0]) tuple and that same tuple is
// recombined into the column-major destination offset.
//
// ndims/nbchannels/ndDims/dstStride/channelStride/totalElems are locals of
// SWIG_SciHypermat_FromMat's N-D branch below, in scope wherever this macro
// is expanded -- same convention as the macro above (which likewise reaches
// out to width/height/nbchannels/size).
//
// Unlike the 2-D macro, channel order is NOT reversed here: (nbchannels-1-c)
// exists only to flip OpenCV's BGR into Scilab's RGB for images. An N-D
// tensor (a dnn blob or output, ...) has no such colour semantics, and
// reversing it would corrupt the data instead of correcting it.
#define copy_row_major_nd_to_column_major_planar_data(src, dst) \
  for (long long ndIdx = 0; ndIdx < totalElems; ndIdx++) { \
    long long ndRem = ndIdx; \
    int ndChannel = 0; \
    if (nbchannels > 1) { \
      ndChannel = (int)(ndRem % nbchannels); \
      ndRem /= nbchannels; \
    } \
    long long ndDstOffset = (long long)ndChannel * channelStride; \
    for (int ndK = ndims - 1; ndK >= 0; ndK--) { \
      int ndAxisIdx = (int)(ndRem % ndDims[ndK]); \
      ndRem /= ndDims[ndK]; \
      ndDstOffset += (long long)ndAxisIdx * dstStride[ndK]; \
    } \
    dst[ndDstOffset] = src[ndIdx]; \
  }

int SWIG_SciHypermat_FromMat(void *pvApiCtx, SwigSciObject iVarOut, cv::Mat *pMat, char *fname) {
  if (pMat->dims > 2) {
    // OpenCV freezes rows/cols at -1 once a Mat has more than 2 dimensions
    // (documented behaviour -- e.g. any dnn blob or Net_forward output with
    // 3+ axes). That is what made the code below this branch silently
    // compute size = (-1)*(-1) = 1 and hand back one uninitialised element
    // described by negative dims. Read the real extents from pMat->size[]
    // instead, and refuse a non-contiguous Mat rather than read past the
    // end of pMat->data (pMat->step[] would be needed to walk it correctly;
    // easier and safer for callers to surface a clear error and let them
    // clone() first).
    if (!pMat->isContinuous()) {
      Scierror(999, _("%s: Cannot convert a non-contiguous N-D Mat (dims=%d) to a Scilab hypermatrix; call Mat_clone first.\n"), fname, pMat->dims);
      return SWIG_ERROR;
    }

    int ndims = pMat->dims;
    int nbchannels = pMat->channels();

    // Scilab hypermat dims, in the SAME order as pMat->size[] -- this is
    // what makes e.g. a blobFromImage() blob come back shaped
    // "1 x 3 x H x W", matching what Mat_shape()/MatShape_str() reports on
    // the source Mat, not reversed. Channel, only when there is more than
    // one, is appended as an extra trailing dimension -- same convention as
    // the 2-D path's dims = {height, width, nbchannels} below, and skipped
    // entirely for the common dnn case (nbchannels == 1) so a caller never
    // has to deal with a synthetic trailing singleton axis.
    std::vector<int> ndDims(ndims);
    long long channelStride = 1;
    for (int k = 0; k < ndims; k++) {
      ndDims[k] = pMat->size[k];
      channelStride *= pMat->size[k];
    }
    if (nbchannels > 1) {
      ndDims.push_back(nbchannels);
    }
    int outNdims = (int) ndDims.size();
    long long totalElems = channelStride * nbchannels;

    // Column-major stride for each spatial axis (axis 0 fastest); channel,
    // when appended, is slowest of all, at channelStride == product(ndDims).
    std::vector<long long> dstStride(ndims);
    dstStride[0] = 1;
    for (int k = 1; k < ndims; k++) {
      dstStride[k] = dstStride[k - 1] * ndDims[k - 1];
    }

    SciErr sciErr;
    switch (pMat->depth()) {
      case CV_8U: {
        uint8_t *dst = (uint8_t *) malloc((size_t)totalElems * sizeof(uint8_t));
        uint8_t *src = (uint8_t *) pMat->data;
        copy_row_major_nd_to_column_major_planar_data(src, dst);
        sciErr = createHypermatOfUnsignedInteger8(pvApiCtx,
          SWIG_NbInputArgument(pvApiCtx) + iVarOut,
          ndDims.data(), outNdims, (const unsigned char *)dst);
        free(dst);
        break;
      }
      case CV_8S: {
        int8_t *dst = (int8_t *) malloc((size_t)totalElems * sizeof(int8_t));
        int8_t *src = (int8_t *) pMat->data;
        copy_row_major_nd_to_column_major_planar_data(src, dst);
        sciErr = createHypermatOfInteger8(pvApiCtx,
          SWIG_NbInputArgument(pvApiCtx) + iVarOut,
          ndDims.data(), outNdims, (const char *)dst);
        free(dst);
        break;
      }
      case CV_16U: {
        uint16_t *dst = (uint16_t *) malloc((size_t)totalElems * sizeof(uint16_t));
        uint16_t *src = (uint16_t *) pMat->data;
        copy_row_major_nd_to_column_major_planar_data(src, dst);
        sciErr = createHypermatOfUnsignedInteger16(pvApiCtx,
          SWIG_NbInputArgument(pvApiCtx) + iVarOut,
          ndDims.data(), outNdims, (const unsigned short *)dst);
        free(dst);
        break;
      }
      case CV_16S: {
        int16_t *dst = (int16_t *) malloc((size_t)totalElems * sizeof(int16_t));
        int16_t *src = (int16_t *) pMat->data;
        copy_row_major_nd_to_column_major_planar_data(src, dst);
        sciErr = createHypermatOfInteger16(pvApiCtx,
          SWIG_NbInputArgument(pvApiCtx) + iVarOut,
          ndDims.data(), outNdims, (const short *)dst);
        free(dst);
        break;
      }
      case CV_32S: {
        int32_t *dst = (int32_t *) malloc((size_t)totalElems * sizeof(int32_t));
        int32_t *src = (int32_t *) pMat->data;
        copy_row_major_nd_to_column_major_planar_data(src, dst);
        sciErr = createHypermatOfInteger32(pvApiCtx,
          SWIG_NbInputArgument(pvApiCtx) + iVarOut,
          ndDims.data(), outNdims, (const int *)dst);
        free(dst);
        break;
      }
      case CV_32F: {
        double *dst = (double *) malloc((size_t)totalElems * sizeof(double));
        float *src = (float *) pMat->data;
        copy_row_major_nd_to_column_major_planar_data(src, dst);
        sciErr = createHypermatOfDouble(pvApiCtx,
          SWIG_NbInputArgument(pvApiCtx) + iVarOut,
          ndDims.data(), outNdims, (const double *)dst);
        free(dst);
        break;
      }
      case CV_64F: {
        double *dst = (double *) malloc((size_t)totalElems * sizeof(double));
        double *src = (double *) pMat->data;
        copy_row_major_nd_to_column_major_planar_data(src, dst);
        sciErr = createHypermatOfDouble(pvApiCtx,
          SWIG_NbInputArgument(pvApiCtx) + iVarOut,
          ndDims.data(), outNdims, (const double *)dst);
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

%fragment("SWIG_Check_SciHypermat", "header") {

int SWIG_Check_SciHypermat(void *pvApiCtx, int iVarInput, char *fname) {
  SciErr sciErr;
  int *piAddrVar = NULL;

  sciErr = getVarAddressFromPosition(pvApiCtx, iVarInput, &piAddrVar);
  if (sciErr.iErr) {
    printError(&sciErr, 0);
    return sciErr.iErr;
  }

  if (isEmptyMatrix(pvApiCtx, piAddrVar)) {
    return 1;
  }
  else if (isHypermatType(pvApiCtx, piAddrVar)) {
    int htype;
    sciErr = getHypermatType(pvApiCtx, piAddrVar, &htype);
    if (sciErr.iErr) {
      printError(&sciErr, 0);
      return sciErr.iErr;
    }
    return (htype == sci_ints) || (htype == sci_matrix);
  }
  else if (isVarMatrixType(pvApiCtx, piAddrVar)) {
    return (isDoubleType(pvApiCtx, piAddrVar) || isIntegerType(pvApiCtx, piAddrVar));
  }
  else {
    return 0;
  }
}

}






