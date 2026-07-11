// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT

%{
#undef SKIP_INCLUDES
#include "opencv2/optflow/motempl.hpp"
// videoio/legacy/constants_c.h was removed in OpenCV 5 (CV_CAP_* / CV_FOURCC
// now come from scicv_legacy_constants.i); video/legacy survives.
#include "opencv2/video/legacy/constants_c.h"
#include "opencv2/videoio.hpp"
#include "opencv2/bgsegm.hpp"
#include "opencv2/optflow.hpp"
#include "opencv2/video.hpp"
#include "opencv2/tracking/feature.hpp"
using namespace cv;
%}

%include opencv_video_ignore.i
%ignore calcNormFactor; // Link issue (Linux)

%include opencv_video_rename.i

%include "opencv2/core/cvstd_wrapper.hpp" // cv::Ptr

%define SWIG_SHARED_PTR_TYPEMAPS(CONST, TYPE...)

// Replace the default "delete arg1" to delete the smart pointer itself instead
%feature("unref") TYPE "(void)arg1; delete smartarg1;"

%typemap(out) cv::Ptr< TYPE > %{
  if (SwigScilabPtrFromObject(pvApiCtx, SWIG_Scilab_GetOutputPosition(), &$1 ? new $1_ltype($1) : 0, SWIG_Scilab_TypeQuery("cv::Ptr< TYPE > *"), 0, "cv::Ptr< TYPE >") != SWIG_OK) {
    return SWIG_ERROR;
  }
  SWIG_Scilab_SetOutput(pvApiCtx, SWIG_NbInputArgument(pvApiCtx) + SWIG_Scilab_GetOutputPosition());
%}

%typemap(in) CONST TYPE * (cv::Ptr< CONST TYPE > *smartarg = 0) %{
  if (SwigScilabPtrToObject(pvApiCtx, $input, (void**)&smartarg, SWIG_Scilab_TypeQuery("cv::Ptr< TYPE > *"), 0, SWIG_Scilab_GetFuncName()) != SWIG_OK) {
    return SWIG_ERROR;
  }
  $1 = (TYPE *)(smartarg ? smartarg->get() : 0);
%}

%enddef

%define %cv_ptr(TYPE...)
  %feature("smartptr", noblock=1) TYPE { cv::Ptr< TYPE > }
  SWIG_SHARED_PTR_TYPEMAPS(, TYPE)
  SWIG_SHARED_PTR_TYPEMAPS(const, TYPE)
%enddef

%cv_ptr(cv::bgsegm::BackgroundSubtractorMOG)
%cv_ptr(cv::BackgroundSubtractorMOG2)

%include "opencv2/optflow/motempl.hpp" // updateMotionHistory
%include "opencv2/video/legacy/constants_c.h" // CV_LKFLOW_PYR_A_READY, ...
%include "opencv2/video/background_segm.hpp" // BackgroundSubtractorMOG2, ...
%include "opencv2/bgsegm.hpp" // BackgroundSubtractorMOG, BackgroundSubtractorGMG, ...
%include "opencv2/optflow.hpp" // calcOpticalFlowSF
%include "opencv2/videoio.hpp" // VideoCapture, VideoWriter, ...
%include "opencv2/video/tracking.hpp"

// Add apply method to BackgroundSubtractorMOG (not wrapped by default)
%{
    void cv_bgsegm_BackgroundSubtractorMOG_apply(cv::bgsegm::BackgroundSubtractorMOG* bgsub,InputArray image, OutputArray fgmask, double learningRate=-1) {
        bgsub->apply(image, fgmask, learningRate);
    }
%}
%extend cv::bgsegm::BackgroundSubtractorMOG {
    virtual void apply (InputArray image, OutputArray fgmask, double learningRate=-1) = 0;
}
