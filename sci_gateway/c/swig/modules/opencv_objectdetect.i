// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT

%{
#include "opencv2/objdetect.hpp"
using namespace cv;
#include "opencv2/rgbd/linemod.hpp"
%}

%include opencv_objdetect_ignore.i

%include "opencv2/objdetect.hpp"
%include "opencv2/rgbd/linemod.hpp" // ColorGradient, QuantizedPyramid, ...

