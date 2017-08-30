// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

%{
#include "opencv2/objdetect/objdetect.hpp"
using namespace cv;
using namespace std;
using std::vector;
%}

%include opencv_objdetect_ignore.i

%clear cv::Mat& image;
%apply cv::Mat& matIn { const cv::Mat& image };

%include "opencv2/objdetect/objdetect.hpp"

