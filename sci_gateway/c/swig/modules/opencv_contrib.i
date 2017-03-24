// Scilab Computer Vision Toolbox
// Copyright (C) 2017 - Scilab Enterprises

%{
#undef SKIP_INCLUDES
#include "opencv2/contrib/contrib.hpp"
%}

%ignore CvAdaptiveSkinDetector;
%ignore CvFuzzyPoint;
%ignore CvFuzzyCurve;
%ignore CvFuzzyFunction;
%ignore CvFuzzyRule;
%ignore CvFuzzyController;
%ignore CvFuzzyMeanShiftTracker;
%ignore Octree;
%ignore SpinImageModel;
%ignore Mesh3D;
%ignore SelfSimDescriptor;
%ignore LevMarqSparse;
%ignore StereoVar;
%ignore LogPolar_Interp;
%ignore LogPolar_Overlapping;
%ignore LogPolar_Adjacent;
%ignore LDA;
%ignore TickMeter;
%ignore Directory;
%ignore FaceRecognizer;

%include "opencv2/contrib/contrib.hpp"
