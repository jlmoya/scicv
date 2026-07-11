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

// calcHist: under OpenCV 5 headers none of the raw cv:: overloads dispatches
// usefully from Scilab (the C-style pointer forms are uncallable and shadow the
// vector form; the vector form rejects scalar channel/histSize). Ignore them all
// and provide a single compat entry point in opencv_imgproc_helpers.i that keeps
// scicv's documented calling convention:
//   hist = calcHist(image, channel, mask, dims, histSize, ranges)
%ignore cv::calcHist;

// imgproc/types_c.h was removed in OpenCV 5; the classic CV_* imgproc constant
// names (CV_BGR2GRAY, CV_THRESH_*, ...) come from scicv_legacy_constants.i.
%ignore cv::fisheye; // its initUndistortRectifyMap & co collide with the cv:: ones
                     // (OpenCV 5 moved the fisheye namespace into imgproc.hpp)
%include "opencv2/imgproc.hpp"
%include "opencv2/calib3d.hpp" // initUndistortRectifyMap, ...

%include opencv_imgproc_helpers.i
