// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT

%{
#undef SKIP_INCLUDES
#include "opencv2/highgui/highgui.hpp"
using namespace cv;
%}

// Not available in pre-build OpenCV versions in thirdparty/
%ignore cvFontQt;
%ignore cvLoadWindowParameters;
// Not available in pre-build OpenCV versions in thirdparty/ (Windows only)
%ignore cvFontQt;
%ignore cvAddText; 
%ignore cvDisplayOverlay;
%ignore cvDisplayStatusBar;
%ignore cvSaveWindowParameters;
%ignore cvStartLoop;
%ignore cvStopLoop;
%ignore cvCreateButton;

%apply cv::Mat& matIn { const cv::Mat& image };
%apply cv::Mat* matOut { cv::Mat& image };

%import  "opencv2/core/types_c.h"
%include "opencv2/highgui/highgui.hpp"
%include "opencv2/highgui/highgui_c.h"


