// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

%{
#undef SKIP_INCLUDES
#include "opencv2/imgproc/imgproc.hpp"
%}

%ignore FilterEngine;
%ignore Algorithm;
%ignore Moments;
%ignore CvConnectedComp;
%ignore CvSubdiv2DPointLocation;
%ignore CvNextEdgeType;
%ignore CvHuMoments;
%ignore CvSubdiv2DPoint;
%ignore CvQuadEdge2D;
%ignore CvMoments;
%ignore CvChainPtReader;
%ignore CvConvexityDefect;
%ignore CvFeatureTree;
%ignore CvLSH;
%ignore CvSubdiv2D;
%ignore CvHuMoments;
%ignore CvConnectedComp;
%ignore CvLSHOperations;

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


%include "opencv2/imgproc/types_c.h"
%include "opencv2/imgproc/imgproc.hpp"


%inline %{

void cvGetPtList(PtLists& ptListsIn, int index, PtList* ptList) {
    *ptList = ptListsIn.at(index);
}

int cvGetPtListsSize(PtLists& ptListsIn) {
    return ptListsIn.size();
}

void cvPtListExtract(PtList& ptListIn, PtList* ptListOut) {
    *ptListOut = ptListIn;
}

%}
