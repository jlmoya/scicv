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

%include "opencv2/imgproc/types_c.h"
%include "opencv2/imgproc/imgproc.hpp"
