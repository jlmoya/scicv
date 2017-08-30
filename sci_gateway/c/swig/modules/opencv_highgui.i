// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

%{
#undef SKIP_INCLUDES
#include "opencv2/highgui/highgui.hpp"
using namespace cv;
%}


%ignore cvLoadWindowParameters();

%apply cv::Mat& matIn { const cv::Mat& image };
%apply cv::Mat* matOut { cv::Mat& image };

%import  "opencv2/core/types_c.h"
%include "opencv2/highgui/highgui.hpp"
%include "opencv2/highgui/highgui_c.h"


