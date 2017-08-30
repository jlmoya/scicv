// Scilab Computer Vision Module
// Copyright (C) 2017 - Scilab Enterprises

%{
#undef SKIP_INCLUDES
#include "opencv2/video/video.hpp"
using namespace cv;
%}

%include opencv_video_ignore.i

%include opencv_video_rename.i


%include "opencv2/video/video.hpp"
%include "opencv2/video/tracking.hpp"
%include "opencv2/video/background_segm.hpp"

