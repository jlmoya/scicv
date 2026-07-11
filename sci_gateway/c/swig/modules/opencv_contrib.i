// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT

%{
#undef SKIP_INCLUDES
// OpenCV 5 moved the rgbd depth API (Odometry, depthTo3d, ...) to the ptcloud module
#include "opencv2/ptcloud/depth.hpp"
%}

%include opencv_contrib_ignore.i

%include "opencv2/ptcloud/depth.hpp" // RIGID_BODY_MOTION, ...