// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT

%{
#undef SKIP_INCLUDES
#include "opencv2/imgproc.hpp"
#include "opencv2/calib3d.hpp"
%}

%include opencv_imgproc_ignore.i

%apply cv::InputArray points { cv::InputArray contour };
%apply cv::InputArray points { cv::InputArray curve };
%apply cv::InputArray points { cv::InputArray contour1 };
%apply cv::InputArray points { cv::InputArray contour2 };

// redefines HoughLines and HoughLinesP to differentiate lines parameter
void HoughLines(cv::InputArray image, cv::OutputArray linesPolarCoordinates,
    double rho, double theta, int threshold,
    double srn=0, double stn=0);

void HoughLinesP(cv::InputArray image, cv::OutputArray linesCartesianCoordinates,
    double rho, double theta, int threshold,
    double minLineLength=0, double maxLineGap=0);

%ignore HoughLines;
%ignore HoughLinesP;

// Ignore this prototype of Canny as Scilab wrapper fails on detecting 3rd parameter type
// "OutputArray edges" (this prototype) vs "double threshold1" (other prototype which is kept as already present in 2.x versions)
%ignore Canny( InputArray dx, InputArray dy,
    OutputArray edges,
    double threshold1, double threshold2,
    bool L2gradient = false );

%include "opencv2/imgproc/types_c.h"
%include "opencv2/imgproc.hpp"
%ignore cv::fisheye; // initUndistortRectifyMap, ... are also defined in this namespace
%include "opencv2/calib3d.hpp" // initUndistortRectifyMap, ...

%include opencv_imgproc_helpers.i
