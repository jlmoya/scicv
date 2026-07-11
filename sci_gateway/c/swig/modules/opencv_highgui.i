// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT

%{
#undef SKIP_INCLUDES
// OpenCV 5 removed highgui_c.h (cvGetWindowName & the cv* Qt helpers); the
// modern C++ API covers the wrapped surface, and the classic CV_WINDOW_* /
// CV_EVENT_* constant names come from scicv_legacy_constants.i.
#include "opencv2/highgui.hpp"
using namespace cv;
%}

%apply cv::Mat& matIn { const cv::Mat& image };
%apply cv::Mat* matOut { cv::Mat& image };

%include "opencv2/highgui.hpp"


