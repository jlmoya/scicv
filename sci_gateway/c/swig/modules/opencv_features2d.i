// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT

%{
#undef SKIP_INCLUDES
#include "opencv2/features2d.hpp"
#include "opencv2/xfeatures2d.hpp"
using namespace cv;
%}

%include opencv_features2d_ignore.i

%apply KeyPoints* { vector<cv::KeyPoint>& keypoints };

%include "opencv2/features2d.hpp" // BOWKMeansTrainer, ...
%include "opencv2/xfeatures2d.hpp" // StarDetector

%include opencv_features2d_helpers.i
