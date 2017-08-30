// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

%{
#undef SKIP_INCLUDES
#include "opencv2/features2d/features2d.hpp"
using namespace cv;
%}

%include opencv_features2d_ignore.i

%apply KeyPoints* { vector<cv::KeyPoint>& keypoints };

%include "opencv2/features2d/features2d.hpp"

%include opencv_features2d_helpers.i
