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

%include "opencv2/imgproc/types_c.h"
%include "opencv2/imgproc/imgproc.hpp"

%inline %{

void cvGetPtLists(PtLists& ptListsIn, PtLists* ptListsOut) {
    *ptListsOut = ptListsIn;
}

void cvGetPtList(PtList& ptListIn, PtList* ptListOut) {
    *ptListOut = ptListIn;
}

void cvGetPtList(PtLists& ptListsIn, int index, PtList* ptList) {
    *ptList = ptListsIn.at(index);
}

%}
