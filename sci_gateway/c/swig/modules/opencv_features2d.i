// Scilab Computer Vision Toolbox
// Copyright (C) 2017 - Scilab Enterprises

%{
#undef SKIP_INCLUDES
#include "opencv2/features2d/features2d.hpp"
using namespace cv;
%}

%ignore FlannBasedMatcher;
%ignore HammingMultilevel;
%ignore BOWTrainer;
%ignore BOWImgDescriptorExtractor;
%ignore BOWImgDescriptorExtractor;
%ignore GenericDescriptorMatcher;
%ignore VectorDescriptorMatcher;
%ignore BriefDescriptorExtractor;
%ignore FREAK;

%apply KeyPoints* { vector<cv::KeyPoint>& keypoints };

%include "opencv2/features2d/features2d.hpp"

%inline %{
void cvGetKeyPoints(KeyPoints& keyPointsIn, KeyPoints* keyPointsMatrixOut) {
    *keyPointsMatrixOut = keyPointsIn;
}
%}
