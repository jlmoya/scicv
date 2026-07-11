// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT

%{
#include "opencv2/objdetect.hpp"
#include "opencv2/xobjdetect.hpp" // OpenCV 5: CascadeClassifier/HOGDescriptor moved here
using namespace cv;
#include "opencv2/rgbd/linemod.hpp"
%}

%include opencv_objdetect_ignore.i

%include "opencv2/objdetect.hpp"
%include "opencv2/xobjdetect.hpp" // CascadeClassifier, HOGDescriptor, WBDetector (moved out of objdetect in 5)
%include "opencv2/rgbd/linemod.hpp" // ColorGradient, QuantizedPyramid, ...

