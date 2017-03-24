// Scilab Computer Vision Toolbox
// Copyright (C) 2017 - Scilab Enterprises

%module scicv

%scilabconst(1);

%include <std_map.i>
%include <std_common.i>
%include <std_string.i>
%include <stl.i>
%include <std_vector.i>

%include operators.i

%include modules/opencv_core.i

%include scicv_datatypes.i

%include typemaps/opencv_typemaps.i

%include modules/opencv_highgui.i
%include modules/opencv_imgproc.i
%include modules/opencv_contrib.i
%include modules/opencv_objectdetect.i
%include modules/opencv_photo.i
%include modules/opencv_video.i
%include modules/opencv_features2d.i

