// Scilab: Mat pointer <=> OpenCV: Input array & OutputArray 

%{
int SWIG_SciPtr_AsMat(void *pvApiCtx, SwigSciObject iVar, cv::Mat **mat, char *fname) {
  SciErr sciErr;
  int *piAddrVar = NULL;
  int iType = 0;
  void *pvPtr = NULL;

  sciErr = getVarAddressFromPosition(pvApiCtx, iVar, &piAddrVar);
  if (sciErr.iErr) {
    printError(&sciErr, 0);
    return SWIG_ERROR;
  }

  sciErr = getVarType(pvApiCtx, piAddrVar, &iType);
  if (sciErr.iErr) {
    printError(&sciErr, 0);
    return SWIG_ERROR;
  }

  if (iType == sci_tlist) {
    int iItemCount = 0;
    void *pvTypeinfo = NULL;

    sciErr = getListItemNumber(pvApiCtx, piAddrVar, &iItemCount);
    if (sciErr.iErr)
    {
      printError(&sciErr, 0);
      return SWIG_ERROR;
    }
    if (iItemCount < 3) {
      return SWIG_ERROR;
    }

    sciErr = getPointerInList(pvApiCtx, piAddrVar, 2, &pvTypeinfo);
    if (sciErr.iErr) {
      printError(&sciErr, 0);
      return SWIG_ERROR;
    }

    // TODO check we have Mat pointer

    sciErr = getPointerInList(pvApiCtx, piAddrVar, 3, &pvPtr);
    if (sciErr.iErr) {
      printError(&sciErr, 0);
      return SWIG_ERROR;
    }
    
    *mat = static_cast<Mat*>(pvPtr);

    return SWIG_OK;
  }
  else {
    return SWIG_ERROR;
  }
}
%}

%typemap(typecheck, precedence=SWIG_TYPECHECK_POINTER) cv::InputArray, cv::OutputArray {
  cv::Mat *mat = NULL;
  $1 = SWIG_SciPtr_AsMat(pvApiCtx, $input, &mat, SWIG_Scilab_GetFuncName()) == SWIG_OK ? 1 : 0;
}

%typemap(in, noblock=1) cv::InputArray {
  cv::Mat *mat$input = NULL;
  if (SWIG_SciPtr_AsMat(pvApiCtx, $input, &mat$input, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
  $1 = new cv::_InputArray(*mat$input);
}

%typemap(in, noblock=1) cv::OutputArray {
  cv::Mat *mat$input = NULL;
  if (SWIG_SciPtr_AsMat(pvApiCtx, $input, &mat$input, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
  $1 = new cv::_OutputArray(*mat$input);
}

%typemap(freearg, noblock=1) cv::InputArray, cv::OutputArray {
  delete $1;
}

%{
int SWIG_SciPtr_FromMat(void *pvApiCtx, SwigSciObject iVarOut, cv::Mat *mat, char *fname) {
  SciErr sciErr;
  swig_type_info *descriptor = NULL; 

  if (mat == NULL) {
    return SWIG_ERROR;
  } 
  
  descriptor = SWIG_TypeQuery("p_cv__Mat");
  if (descriptor) {
    int *piTListAddr = NULL;
    const char *pstString = NULL;

    sciErr = createTList(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + iVarOut, 3, &piTListAddr);
    if (sciErr.iErr) {
      printError(&sciErr, 0);
      return SWIG_ERROR;
    }

    pstString = SWIG_TypeName(descriptor);
    sciErr = createMatrixOfStringInList(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + iVarOut, piTListAddr, 1, 1, 1, &pstString);
    if (sciErr.iErr) {
      printError(&sciErr, 0);
      return SWIG_ERROR;
    }

    sciErr = createPointerInList(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + iVarOut, piTListAddr, 2, descriptor);
    if (sciErr.iErr) {
      printError(&sciErr, 0);
      return SWIG_ERROR;
    }

    sciErr = createPointerInList(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + iVarOut, piTListAddr, 3, mat);
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


// Scilab: double 1x2 <=> OpenCV Point

%{
int SWIG_SciDoubleOrInt32_AsPoint(void *pvApiCtx, SwigSciObject iVar, cv::Point *point, char *fname) {
  int *piValues = NULL;
  int iRows = 0;
  int iCols = 0;
  if (SWIG_SciDoubleOrInt32_AsIntArrayAndSize(pvApiCtx, iVar, &iRows, &iCols, &piValues, fname) != SWIG_OK) {
    return SWIG_ERROR;
  }
  
  if (iRows * iCols == 2) {      
    point->x = piValues[0];
    point->y = piValues[1];
    return SWIG_OK;
  } 
  else {
    return SWIG_ERROR;
  }
}
%}
 
// TODO: fix precedence
%typemap(typecheck, precedence=SWIG_TYPECHECK_DOUBLE) cv::Point, const cv::Point& {
  cv::Point point;
  $1 = SWIG_SciDoubleOrInt32_AsPoint(pvApiCtx, $input, &point, SWIG_Scilab_GetFuncName()) == SWIG_OK ? 1 : 0;
} 

%typemap(in, noblock=1) cv::Point {
  if (SWIG_SciDoubleOrInt32_AsPoint(pvApiCtx, $input, &$1, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
}

%typemap(in, noblock=1) cv::Point& (cv::Point tmpPoint)  {
  $1 = &tmpPoint;
  if (SWIG_SciDoubleOrInt32_AsPoint(pvApiCtx, $input, $1, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
}

// Scilab: double 1x2 <=> OpenCV Size

%{
int SWIG_SciDoubleOrInt32_AsSize(void *pvApiCtx, SwigSciObject iVar, cv::Size *size, char *fname) {
  int *piValues = NULL;
  int iRows = 0;
  int iCols = 0;
  if (SWIG_SciDoubleOrInt32_AsIntArrayAndSize(pvApiCtx, iVar, &iRows, &iCols, &piValues, fname) != SWIG_OK) {
    return SWIG_ERROR;
  }
  
  if (iRows * iCols == 2) {      
    size->width = piValues[0];
    size->height = piValues[1];
    return SWIG_OK;
  } 
  else {
    return SWIG_ERROR;
  }
}
%}
 
// TODO: fix precedence
%typemap(typecheck, precedence=SWIG_TYPECHECK_DOUBLE) cv::Size, const cv::Size& {
  cv::Size size;
  $1 = SWIG_SciDoubleOrInt32_AsSize(pvApiCtx, $input, &size, SWIG_Scilab_GetFuncName()) == SWIG_OK ? 1 : 0;
} 

%typemap(in, noblock=1) cv::Size {
  if (SWIG_SciDoubleOrInt32_AsSize(pvApiCtx, $input, &$1, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
}

%typemap(in, noblock=1) cv::Size& (cv::Size tmpSize)  {
  $1 = &tmpSize;
  if (SWIG_SciDoubleOrInt32_AsSize(pvApiCtx, $input, $1, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
}

// Scilab: double 1x4 <=> OpenCV Rect
%{
int SWIG_SciDoubleOrInt32_AsRect(void *pvApiCtx, SwigSciObject iVar, cv::Rect *rect, char *fname) {
  int *piValues = NULL;
  int iRows = 0;
  int iCols = 0;
  if (SWIG_SciDoubleOrInt32_AsIntArrayAndSize(pvApiCtx, iVar, &iRows, &iCols, &piValues, fname) != SWIG_OK) {
    return SWIG_ERROR;
  }
  
  if (iRows * iCols == 4) {  
    rect->x = piValues[0];
    rect->y = piValues[1];    
    rect->width = piValues[2];
    rect->height = piValues[3];
    return SWIG_OK;
  } 
  else {
    return SWIG_ERROR;
  }
}
%}
 
// TODO: fix precedence
%typemap(typecheck, precedence=SWIG_TYPECHECK_DOUBLE) cv::Rect, const cv::Rect& {
  cv::Rect rect;
  $1 = SWIG_SciDoubleOrInt32_AsRect(pvApiCtx, $input, &rect, SWIG_Scilab_GetFuncName()) == SWIG_OK ? 1 : 0;
} 

%typemap(in, noblock=1) cv::Rect {
  if (SWIG_SciDoubleOrInt32_AsRect(pvApiCtx, $input, &$1, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
}

%typemap(in, noblock=1) cv::Rect& (cv::Rect tmpRect)  {
  $1 = &tmpRect;
  if (SWIG_SciDoubleOrInt32_AsRect(pvApiCtx, $input, $1, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
}


// Scilab: list matrix[1,4] <=> OpenCV std::vector<Rect>
%typemap(in, numinputs=0, noblock=1) vector<cv::Rect_<int>>& (vector<cv::Rect_<int>> vRect) {
  $1 = &vRect;
}

%typemap(argout, noblock=0) vector<cv::Rect_<int>>& {
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

/*
// Scilab: list matrix[1,6] <=> OpenCV std::vector<KeyPoint>
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




/*
// Scilab: double 1x7 <=> OpenCV KeyPoint
%{
int SWIG_SciDoubleOrInt32_AsKeyPoint(void *pvApiCtx, SwigSciObject iVar, cv::KeyPoint *keypoint, char *fname) {
  int *piValues = NULL;
  int iRows = 0;
  int iCols = 0;
  if (SWIG_SciDoubleOrInt32_AsIntArrayAndSize(pvApiCtx, iVar, &iRows, &iCols, &piValues, fname) != SWIG_OK) {
    return SWIG_ERROR;
  }
  
  if (iRows * iCols == 7) {  
    keypoint->x = piValues[0];
    keypoint->y = piValues[1];    
    keypoint->size = piValues[2];
    keypoint->angle = piValues[3];
    keypoint->response = piValues[4];
    keypoint->octave =piValues[5];
    keypoint->class_id =piValues[6];

    return SWIG_OK;
  } 
  else {
    return SWIG_ERROR;
  }
}
%}
 
// TODO: fix precedence
%typemap(typecheck, precedence=SWIG_TYPECHECK_DOUBLE) cv::KeyPoint, const cv::KeyPoint& {
  cv::KeyPoint keypoint;
  $1 = SWIG_SciDoubleOrInt32_AsKeyPoint(pvApiCtx, $input, &keypoint, SWIG_Scilab_GetFuncName()) == SWIG_OK ? 1 : 0;
} 

%typemap(in, noblock=1) cv::KeyPoint {
  if (SWIG_SciDoubleOrInt32_AsKeyPoint(pvApiCtx, $input, &$1, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
}

%typemap(in, noblock=1) cv::KeyPoint& (cv::KeyPoint tmpRect)  {
  $1 = &tmpKeyPoint;
  if (SWIG_SciDoubleOrInt32_AsKeyPoint(pvApiCtx, $input, $1, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
}
*/

// Scilab: double matrix <=> OpenCV float** ranges 
%typemap(typecheck, noblock=0) float** ranges {
  int *piAddr;
  SciErr sciErr = getVarAddressFromPosition(pvApiCtx, $input, &piAddr);
  if (sciErr.iErr) {	
     printError(&sciErr, 0);
     return SWIG_ERROR;
  }
  $1 = isDoubleType(pvApiCtx, piAddr);
}
/**/
%typemap(in, noblock=1, fragment="SWIG_SciDouble_AsDoubleArrayAndSize") float** ranges (double *pdValues, int rowCount, int colCount)
{
  if (SWIG_SciDouble_AsDoubleArrayAndSize(pvApiCtx, $input, &rowCount, &colCount, &pdValues, fname) != SWIG_OK) {
    *$1 = new float[rowCount * colCount];
    for (int i=0; i<rowCount * colCount; i++) {
      (*$1)[i] = (float)pdValues[i];
    }
    // TODO delete pdValues
    return SWIG_ERROR;
  }
}

%include mat_typemaps.i



